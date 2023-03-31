
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isLoading = true;
  String _path = '';

  @override
  void initState() {
    _openPdf('https://ozimplatform.kz/1.pdf');
    super.initState();
  }

  Future<void> _openPdf(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    _path = file.path;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ozim Platform'),
        leading: IconButton(
          iconSize: 25.0,
          splashRadius: 20,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PdfView(path: _path),
    );
  }
}
