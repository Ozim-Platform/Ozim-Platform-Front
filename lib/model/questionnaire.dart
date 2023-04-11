
class QuestionnaireData {
  int id;
  int childId;
  int age;
  String questionareTitle;
  List<QuestionPageData> questionList = [];
  String author;
  String authorPosition;
  int likes;
  int views;
  bool isLiked;
  bool inBookmarks;
  String bookmarkFolder;
  int createdAt;
  QuestionaireAnswers
      questionaireAnswers; // these questionaire answers which we got from the backend

  QuestionnaireData({
    this.id,
    this.age,
    this.childId,
    this.questionareTitle,
    this.questionList,
    this.author,
    this.authorPosition,
    this.likes,
    this.views,
    this.isLiked,
    this.inBookmarks,
    this.bookmarkFolder,
    this.createdAt,
    this.questionaireAnswers,
  });

  QuestionnaireData.fromJson(Map<String, dynamic> json, int childId) {
    List<QuestionPageData> _questionList = [];

    if (json['questions'] is List == false) {
      for (int i = 0; i < json['questions'].length; i++) {
        // allJsonQuestions = <"questions", <map with questions for each page and ranges>>
        Map<String, dynamic> allJsonQuestions = json["questions"];

        // <map with questions for each page and ranges> = Map<String,Map<dynamic>>

        //  Map<String,Map<dynamic>> = Map<title,<Map<String,dynamic>>>

        // QuestionPageData is generated from this Map<title,<Map<String,dynamic>>>
        String keyOfCurrent = allJsonQuestions.keys.elementAt(i);
        Map<String, dynamic> currentQuestionPageDataJson =
            allJsonQuestions[keyOfCurrent];

        // this is what is passed to the QuestionPageData.fromJson();

        // <Map<String,dynamic>> = dynamic => List<String>
        //                         dynamic => Map<String,Map<String,String>>

        // List<String> = list of string questions in one page

        QuestionPageData tempQuestion = QuestionPageData.fromJson(
          currentQuestionPageDataJson,
          i,
          keyOfCurrent,
        );

        _questionList.add(tempQuestion);
      }
    }

    id = json['id'];
    age = json['age'];
    childId = childId;
    questionareTitle = json['title'];
    questionList = _questionList;
    author = json['author'];
    authorPosition = json['author_position'];
    likes = json['likes'];
    views = json['views'];
    isLiked = json['is_liked'];
    inBookmarks = json['in_bookmarks'];
    bookmarkFolder = json['bookmark_folder'];
    createdAt = json['created_at'];
  }
}

class QuestionPageData {
  String title;
  int questionIndex;
  List<dynamic> questions = [];
  Map<String, String> ranges;

  QuestionPageData({
    this.title,
    this.questions,
    this.ranges,
    this.questionIndex,
  });

  factory QuestionPageData.fromJson(Map<dynamic, dynamic> questionJson,
      int questionIndex, String currentKey) {
    //  Map<String,Map<dynamic>> = Map<title,<Map<String,dynamic>>>

    // <Map<String,dynamic>> = dynamic => List<String>
    //                         dynamic => Map<String,Map<String,String>>

    return QuestionPageData(
      title: currentKey,
      questions: questionJson["questions"],
      questionIndex: questionIndex,
      ranges: questionJson["ranges"] != null
          ? Map<String, String>.from(questionJson["ranges"])
          : null,
    );
  }
}

class QuestionaireAnswers {
  int answerId;
  int childId;
  int questionnaireId;
  List<QuestionaireAnswer> answers = [];

  QuestionaireAnswers({this.answerId, this.childId, this.answers});

  Map<String, dynamic> toJson(QuestionaireAnswers answer) {
    // preprocessing our answer such that it will be in the right order
    // answer.answers.sort(
    //   (a, b) => a.questionIndex.compareTo(b.questionIndex),
    // );

    var answersToSubmit = [];
    answer.answers.forEach(
      (element) {
        answersToSubmit.add(element.toJson());
      },
    );

    return {
      
      "child_id": answer.childId,
      "answers": answersToSubmit,
    };
  }

  factory QuestionaireAnswers.fromJson(
    Map<dynamic, dynamic> jsonData,
    int childId,
  ) {
    List<QuestionaireAnswer> answers = [];
    int i = 0;
    // 
    jsonData.forEach(
      (key, value) {
        answers.add(
          // what are we passing as value here when locally storing it?
          QuestionaireAnswer.fromJson(key, value, i),
        );
        i++;
      },
    );

    return QuestionaireAnswers(
      answerId: jsonData["id"],
      childId: childId,
      answers: answers,
    );
  }

  factory QuestionaireAnswers.fromLocal(
    Map<dynamic, dynamic> jsonData,
    int childId,
  ) {
    List<QuestionaireAnswer> answers = [];
    int i = 0;
    jsonData.forEach((key, value) {
      if (key == "answers") {
        jsonData["answers"].forEach(
          (answer) {
            answers.add(
              QuestionaireAnswer.fromJson(
                  i.toString(), answer.values.elementAt(1), i),
            );
            i++;
          },
        );
      }
    });

    return QuestionaireAnswers(
      childId: childId,
      answers: answers,
    );
  }

  Map<String, dynamic> toSaveLocally(int questionnaireId) {
    var answersToSave = [];

    answers.forEach(
      (element) {
        answersToSave.add(
          element.toSaveLocally(),
        );
      },
    );

    return {
      "questionnaire_id": questionnaireId,
      "child_id": childId,
      "answers": answersToSave,
    };
  }
}

class QuestionaireAnswer {
  int questionIndex;
  String questionaireTitle;
  // List of either AnswerWithoutComment or AnswerWithComment
  var answers;

  QuestionaireAnswer({
    this.questionIndex,
    this.answers,
    this.questionaireTitle,
  });

  factory QuestionaireAnswer.withAnswerType(
      int questionIndex, String questionaireTitle) {
    // our questionare has 5 questions with numerical answers and 1 question with text answers it is static

    if (questionIndex == 5) {
      List answerList = [];
      // creating a list of five answers with comments

      for (int i = 0; i <= 5; i++) {
        answerList.add(
          AnswerWithComment(),
        );
      }

      return QuestionaireAnswer(
        questionaireTitle: questionaireTitle,
        questionIndex: questionIndex,
        answers: answerList,
      );
    } else {
      List answerList = [];
      for (int i = 0; i <= 5; i++) {
        answerList.add(
          AnswerWithoutComment(),
        );
      }
      return QuestionaireAnswer(
        questionIndex: questionIndex,
        answers: answerList,
      );
    }
  }

  factory QuestionaireAnswer.fromJson(
      String key, Map<String, dynamic> json, int _questionIndex) {
    var answers = [];
    // its value is either list, or
    if (_questionIndex == 5) {
      final List<dynamic> answerList = json["answers"];

      answerList.forEach(
        (element) {
          answers.add(
            AnswerWithComment.fromJson(
              element,
            ),
          );
        },
      );
    } else {
      final List<dynamic> answerList = json["answers"];

      answerList.forEach((element) {
        answers.add(
          AnswerWithoutComment.fromJson(
            element,
          ),
        );
      });
    }

    return QuestionaireAnswer(
        questionaireTitle: json.keys.first, answers: answers);
  }

  List<dynamic> toJson() {
    final List<dynamic> answerList = [];

    // Convert the map to a list, making sure the answers are in order
    for (int i = 0; i < answers.length; i++) {
      if (questionIndex == 5) {
        // will return a {"value": false, "comment": "Комментарии"},
        answerList.add(
          answers[i].toJson(),
        );
      } else {
        // should return a list of answer values
        answerList.add(
          answers[i].value,
        );
      }
    }

    return answerList;
  }

  Map<String, dynamic> toSaveLocally() {
    Map<String, dynamic> answerToReturn;

    final List<dynamic> answerList = [];

    // Convert the map to a list, making sure the answers are in order
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == null) {
        break;
      }
      if (questionIndex == 5) {
        // will return a {"value": false, "comment": "Комментарии"},
        answerList.add(
          answers[i].toJson(),
        );
      } else {
        // should return a list of answer values
        answerList.add(
          answers[i].value,
        );
      }
    }

    return {
      "questionIndex": questionIndex,
      // some of the titles were null, therefore, I decided to save according to the index
      questionIndex.toString(): {
        "answers": answerList,
      },
    };
  }

  QuestionaireAnswer fromLocalStorage() {
    // get the data from local storage
    // convert it to a QuestionaireAnswer
    // return it

    return QuestionaireAnswer(
      questionIndex: questionIndex,
      answers: answers,
    );
  }

  bool isComplete() {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].value == null) {
        return false;
      }
    }
    return true;
  }
}

class AnswerWithoutComment {
  int value;

  AnswerWithoutComment({this.value});

  factory AnswerWithoutComment.fromJson(int value) {
    return AnswerWithoutComment(
      value: value,
    );
  }
}

class AnswerWithComment {
  bool value;
  String comment;

  AnswerWithComment({this.value, this.comment});

  factory AnswerWithComment.fromJson(Map<String, dynamic> json) {
    return AnswerWithComment(
      value: json != null ? json["value"] : null,
      comment: json != null ? json["comment"] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "comment": comment,
    };
  }
}

mixin ComputeOperations {
  static List<QuestionnaireData> parseQuestionare(
    dynamic responseBody,
    int childId,
  ) {
    final List<dynamic> questionareJson = responseBody as List<dynamic>;
    final List<QuestionnaireData> questionares = questionareJson
        .map((json) => QuestionnaireData.fromJson(json, childId))
        .toList();
    return questionares;
  }
}
