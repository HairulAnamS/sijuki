import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sijuki/model/posting.dart';

class ViewPdfPage extends StatefulWidget {
  final Posting posting;
  final String namaUserPosting;
  const ViewPdfPage({
    Key key,
    @required this.posting,
    @required this.namaUserPosting,
  }) : super(key: key);

  @override
  _ViewPdfPageState createState() => _ViewPdfPageState();
}

class _ViewPdfPageState extends State<ViewPdfPage> {
  PDFDocument doc;
  @override
  void initState() {
    super.initState();
    viewPdf();
    getPermission();
  }

  void viewPdf() async {
    doc = await PDFDocument.fromURL(widget.posting.urlFile);
    if (doc != null) {
      setState(() {});
    }
  }

  void getPermission() async {
    print('GET PERMISSION');
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  var dio = Dio();

  Future processDownload(Dio dio, String urlFile, String savePath) async {
    try {
      Response respon = await dio.get(urlFile,
          onReceiveProgress: showDownloadProgress,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }));

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(respon.data);
      await raf.close();
    } catch (e) {
      print(e.toString());
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      var presentase = received / total * 100;
      print((presentase).toStringAsFixed(0) + "%");
      if (presentase == 100) {
        showSnackBar("Download selesai..");
      }
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String msg) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.red[700]),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              "View Pdf",
              style: TextStyle(
                  color: Colors.red[700], fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: Colors.red[700],
                  ),
                  onPressed: () async {
                    String basePath =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                    String path = widget.namaUserPosting.replaceAll(' ', '') +
                        "_" +
                        DateFormat('yyyyMMdd_kkmmss').format(DateTime.now());
                    String fullPath = basePath + "/" + path + ".pdf";
                    print(fullPath);
                    processDownload(dio, widget.posting.urlFile, fullPath);

                    // showSnackBar("Download selesai..");
                  })
            ],
          ),
          body: (doc == null)
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: doc)),
    );
  }
}
