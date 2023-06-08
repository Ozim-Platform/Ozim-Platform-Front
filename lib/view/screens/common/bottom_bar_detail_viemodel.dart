import 'dart:developer';

import 'package:charity_app/data/db/local_questionaires_db.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/post_url_helper.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/screens/other/comment_screen.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

class BottomBarDetailViewModel extends BaseViewModel {
  final instance;

  BottomBarDetailViewModel({this.instance});

  ApiProvider _apiProvider = new ApiProvider();
  BuildContext context;

  ValueNotifier<Data> _dataValueNotifier = ValueNotifier(null);

  ValueNotifier<Data> get dataValueNotifier => _dataValueNotifier;

  Data _data;

  int _id;

  bool _isLoading = false;

  List<Data> _folders = [];

  var _currentIndex = 0;

  bool get isLoading => _isLoading;

  Data get data => _data;

  int get currentIndex => _currentIndex;

  List<Data> get folders => _folders;

  addMockFolder(Data folder) {
    _folders.add(folder);
  }

  setFolders(List<Data> folders) {
    _folders = folders;
  }

  Future<void> initContext(BuildContext context, Data article) async {
    this.context = context;
    _data = article;
    _dataValueNotifier = ValueNotifier(_data);
    _id = article.id;
    await view();
    await getBookmarksFolders();
  }

  Future<void> onTabTapped(int index) async {
    _currentIndex = index;
    switch (index) {
      case 0:
        if (_data.type != null) {
          await toggleLike(_data);
        }
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommentScreen(instance, _data)));
        break;
      case 2:
        await onShareData(context, _data);
        break;
      case 3:
        if (_data.inBookmarks) {
          _data.inBookmarks = false;
          removeInstanceFromFavorite(_data.id, _data.type);
        } else
          await onBookMarks(context, _data);
        break;
      default:
        print('error', level: 1);
        break;
    }
    notifyListeners();
  }

  Future<void> toggleLike(data) async {
    // print(instance.runtimeType);
    if (_data.type == 'article') {
      if (_data.isLiked) {
        await articleDislike();
        _data.isLiked = false;
      } else {
        await addLike();
        _data.isLiked = true;
      }
      //TODO обновление
      // if (instance is ArticleViewModel) {
      //   instance.getAllArticle(new List<Category>());
      // }
    } else {
      if (_data.isLiked) {
        await otherDislike();
        _data.isLiked = false;
      } else {
        await otherLike();
        _data.isLiked = true;
      }
    }

    _dataValueNotifier.notifyListeners();
  }

  Future<void> view() async {
    if (_data.type == 'article') {
      await articleView();
    } else {
      await otherView();
    }
  }

  Future<void> onShareData(BuildContext context, Data data) async {
    final RenderBox box = context.findRenderObject();
    String type = data.type;
    int id = data.id;
    String url = PostUrlHelper.generateUrl(type, id);

    {
      await Share.share(url,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    var localData = await SharedPreferencesHelper(key: url).readData();
    // store the datetime of the share
    if (localData == null) {
      // if this article had already been shared within previous 15 minutes, then do not add points
      await _apiProvider.receivePoints(20);
      Map<String, dynamic> data = new Map<String, dynamic>();
      data["article_id"] = _id;
      data["share_date"] = DateTime.now().toString();

      SharedPreferencesHelper(key: url).saveData(data);
    } else if (DateTime.parse(localData["share_date"])
            .compareTo(DateTime.now().add(Duration(minutes: 15))) >
        0) {
      await _apiProvider.receivePoints(20);
    }
  }

  Future<void> articleView() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = _id;
    _isLoading = true;
    _apiProvider
        .articleView(data)
        .then(
          (value) => {
            if (value.error == null)
              {_data.views++}
            else
              {log("Error: ${value.error}", level: 1)}
          },
        )
        .catchError((error, trace) {
      print("Error: $error", level: 1);
      print(trace, level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> addLike() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = _id;
    _isLoading = true;
    _apiProvider.articleLike(data).then((value) {
      if (value.error == null) {
        _data.likes++;
      }
    }).catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> articleDislike() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = _id;
    _isLoading = true;
    _apiProvider.articleDislike(data).then((value) {
      if (value.error == null) {
        _data.likes--;
      }
    }).catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> otherView() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['record_id'] = _id;
    data['type'] = _data.type;
    _isLoading = true;
    _apiProvider
        .otherView(data)
        .then((value) => {
              if (value.error == null)
                {_data.views++}
              else
                {log("Error: ${value.error}", level: 1)}
            })
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> otherLike() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['record_id'] = _id;
    data['type'] = _data.type;
    _isLoading = true;
    _apiProvider.otherLike(data).then((value) {
      if (value.error == null) {
        _data.likes != null ? _data.likes++ : _data.likes = 1;
      }
    }).catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> otherDislike() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['record_id'] = _id;
    data['type'] = _data.type;
    _isLoading = true;
    _apiProvider.otherDislike(data).then((value) {
      if (value.error == null) {
        _data.likes != null ? _data.likes-- : _data.likes = 0;
      }
    }).catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> getBookmarksFolders() async {
    // _apiProvider.getBookMarkFolders(type: _data.type).then((value) {
    _apiProvider.getBookMarkFolders().then((value) {
      _folders = value;
    }).catchError((error) {
      print("Error: $error", level: 1);
    });
  }

  Future<void> createFolder(String foldername,
      {Function initCallbak,
      Function afterDoCallback,
      bool addToBookmark = false}) async {
    ///Закрыть модалку
    initCallbak();

    ///Создать папку
    if (foldername != null && foldername != '') {
      Map<String, dynamic> data = {"name": foldername, "type": _data.type};
      _apiProvider.bookMarkStore(data).then((value) async {
        if (value.error == null) {
          if (value.data != null) {
            if (addToBookmark == true && value.data['id'] != null) {
              await addToFolder(value.data['id'], closeModal: () {
                Navigator.of(context).pop();
              });
            }
            ToastUtils.toastSuccessGeneral(value.success, context);

            ///Для обновления view
            Data folder = Data.fromJson(value.data);
            addMockFolder(folder);

            ///Открыть исходную модалку
            await onBookMarks(context, _data);
          }
        } else {
          ToastUtils.toastErrorGeneral(value.error, context);
        }
      }).catchError((error, trace) {
        print("Error: $error", level: 1);
        print(trace, level: 1);

        ///Получить список папок
      }).whenComplete(() => {
            getBookmarksFolders(),
            _dataValueNotifier.notifyListeners(),
          });
    }
  }

  Future<void> deleteFolder(
      List<Data> folders, int index, Function updateCallback) async {
    int folderid = folders[index].id;
    _apiProvider.bookMarkDelete(folderid, _data.type).then((value) {
      if (value.error == null) {
        folders.removeAt(index);
        updateCallback();
      }
    }).catchError((onError) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {
          _isLoading = false,
          getBookmarksFolders(),
          _dataValueNotifier.notifyListeners(),
        });
  }

  Future<void> renameFolder(String folderName, List<Data> folders, int index,
      Function updateCallback, Function initCallback) async {
    print('rename');
    // initCallback();
    if (folderName != null && folderName != '') {
      Map<String, dynamic> data = {
        "name": folderName,
        "folder": folders[index].id
      };
      _apiProvider.bookMarkUpdate(data, _data.type).then((value) async {
        if (value.error == null) {
          folders[index].name = folderName;
          _folders = folders;
          initCallback();
        }
      }).catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {
            _isLoading = false,
            getBookmarksFolders(),
            onBookMarks(context, _data),
            _dataValueNotifier.notifyListeners(),
          });
    }
  }

  Future<void> addToFolder(int folderid, {Function closeModal}) async {
    Map<String, dynamic> data = {"folder": folderid, "type": _data.type};
    // if (_data.type == 'article') {
    //   data['article_id'] = _id;
    // } else {
    data['record_id'] = _id;
    // }
    print(_data.type);
    if (_data.inBookmarks) {
      _apiProvider.moveBookmark(data).catchError((error, trace) {
        print("Error: $error", level: 1);
        print(trace, level: 1);
      }).whenComplete(() => {
            _isLoading = false,
            _data.inBookmarks = true,
            getBookmarksFolders(),
            closeModal(),
            notifyListeners(),
            _dataValueNotifier.notifyListeners(),
          });
    } else {
      _apiProvider.storeBookmark(data).catchError((error, trace) {
        print("Error: $error", level: 1);
        print(trace, level: 1);
      }).whenComplete(() => {
            _isLoading = false,
            _data.inBookmarks = true,
            getBookmarksFolders(),
            closeModal(),
            notifyListeners(),
            _dataValueNotifier.notifyListeners(),
          });
    }
  }

  Future<void> updateFolderPopup(
      Function initcallback, TextEditingController controller, updateCallback,
      {renameold = false,
      Data folder,
      int index,
      bool addToBookmark = false}) async {
    assert(renameold ? folder != null && index != null : true);

    _createFolder(String text) {
      if (renameold) {
        renameFolder(
            controller.text, folders, index, updateCallback, initcallback);
      } else {
        createFolder(text, initCallbak: initcallback);
      }
    }

    if (renameold) {
      controller.text = folder.name;
    }

    initcallback();
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: controller,
                autofocus: true,
                focusNode: FocusNode(),
                textInputAction: TextInputAction.send,
                onSubmitted: _createFolder,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  hintText: getTranslated(context, 'name_of_folder'),
                  hintStyle: AppThemeStyle.normalText,
                  hintMaxLines: 1,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnUI(
                  height: 45,
                  width: 125,
                  isLoading: false,
                  textColor: Colors.white,
                  color: AppThemeStyle.primaryColor,
                  text: getTranslated(context, 'cancel'),
                  onTap: () {
                    initcallback();
                    updateCallback();
                  },
                ),
                BtnUI(
                  height: 45,
                  width: 125,
                  isLoading: false,
                  textColor: Colors.white,
                  color: AppThemeStyle.primaryColor,
                  text: getTranslated(context, 'save'),
                  onTap: () {
                    if (renameold) {
                      renameFolder(controller.text, folders, index,
                          updateCallback, initcallback);
                    } else {
                      createFolder(controller.text,
                          initCallbak: initcallback,
                          addToBookmark: addToBookmark);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
    // await  _apiProvider.bookMarkStore(),
  }

  Future<void> removeInstanceFromFavorite(int id, String type) async {
    ApiProvider _apiProvider = ApiProvider();
    // print(data);
    Map<String, dynamic> data = {'type': type};
    // if (type == 'article') {
    //   data['article_id'] = id;
    // } else {
    data['record_id'] = id;
    // }
    _apiProvider
        .removeFromBookmarkStore(data)
        .then((value) {})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() {
      _dataValueNotifier.notifyListeners();
    });
  }

  Future<void> onBookMarks(BuildContext context, data,
      {List<Data> initFolders, bool directly = true}) async {
    // var b = await _apiProvider.getBookMark();
    // print(b.toJson());
    if (initFolders != null) {
      setFolders(initFolders);
    }

    _closeModal() {
      Navigator.pop(context);
    }

    // if (initFolders != null) {
    //   if (initFolders.isNotEmpty) {
    //     if (!data.inBookmarks && directly) {
    //       addToFolder(folders[0].id, closeModal: _closeModal);
    // print('here');
    // return;
    // }
    // }
    // }

    TextEditingController _controller = TextEditingController();

    _addToAnother() {
      _closeModal();
    }

    ///Создание и переименование папки, если переименование, передать папку и index

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter mystate) {
            _updateWidget() {
              mystate(() {});
            }
            // print(folders);

            return Container(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.inBookmarks)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              height: 60.0,
                              color: Color(0xfff2f2f2),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: AppThemeStyle.primaryColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    getTranslated(
                                        context, 'already_added_to_bookmarks'),
                                    style: AppThemeStyle.subHeaderPrimary,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _addToAnother,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                height: 60.0,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Constants.ligtherMainTextColor),
                                    bottom: BorderSide(
                                        color: Constants.ligtherMainTextColor),
                                  ),
                                ),
                                child: Text(
                                  getTranslated(
                                      context, 'add_to_another_folder'),
                                  style: AppThemeStyle.subHeaderLigther,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (folders != null)
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Container(
                            height: 180,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: folders.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            addToFolder(folders[i].id,
                                                closeModal: _closeModal);
                                          },
                                          child: Text(
                                            folders[i].name,
                                            style:
                                                AppThemeStyle.normalTextBigger,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                updateFolderPopup(_closeModal,
                                                    _controller, _updateWidget,
                                                    renameold: true,
                                                    folder: folders[i],
                                                    index: i);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color:
                                                    AppThemeStyle.primaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                deleteFolder(
                                                    folders, i, _updateWidget);
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color:
                                                    AppThemeStyle.primaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),

                  ///Создать новую папку
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          updateFolderPopup(
                              _closeModal, _controller, _updateWidget,
                              addToBookmark: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          height: 53,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '+ ' + getTranslated(context, 'create_new_folder'),
                            style: AppThemeStyle.subHeaderBigger,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
