import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadImageScreen extends StatefulWidget {
  const DownloadImageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadImageScreenState();
}

class _DownloadImageScreenState extends State<DownloadImageScreen> {
  bool downloading = false;
  String progressString = "";
  String filePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Large File Example'),
      ),
      body: Center(
        child: downloading
            ? SizedBox(
                height: 120.0,
                width: 200.0,
                child: Card(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        'Downloading File: $progressString',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : filePath.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(File(filePath)),
                      const SizedBox(height: 20),
                      Text(
                        'Download Complete: $filePath',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : const Text('No file downloaded yet.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: downloadFile,
        child: const Icon(Icons.file_download),
      ),
    );
  }

  Future<void> downloadFile() async {
    setState(() {
      downloading = true;
      progressString = "";
    });

    var dio = Dio();
    try {
      var dir = await getTemporaryDirectory();
      String imagePath = '${dir.path}/myimage.jpg';

      await dio.download(
        'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg',
        imagePath,
        onReceiveProgress: (rec, total) {
          setState(() {
            progressString = '${((rec / total) * 100).toStringAsFixed(0)}%';
          });
        },
      );
      setState(() {
        filePath = imagePath;
        progressString = 'Completed';
        downloading = false;
      });
    } catch (e) {
      setState(() {
        progressString = 'Error';
        downloading = false;
      });
      print(e);
    }
  }
}
