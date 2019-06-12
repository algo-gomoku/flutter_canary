import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  var cameras;

  CameraPage(this.cameras);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;

  String imagePath;

  bool _toggleCamera = false;

  @override
  void initState() {
    super.initState();
    onCameraSelected(widget.cameras[0]);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    print(controller.value.aspectRatio);
    return Stack(
      children: <Widget>[
        Center(child: AspectRatio(aspectRatio: controller.value.aspectRatio,child: CameraPreview(controller))),
        buildCaptureButton(),
        Mask()
      ],
    );
  }

  Widget buildCaptureButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 120.0,
        padding: EdgeInsets.all(20.0),
        color: Color.fromRGBO(00, 00, 00, 0.7),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  onTap: () {
                    _captureImage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.camera,
                      size: 72.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  onTap: () {
                    if (!_toggleCamera) {
                      onCameraSelected(widget.cameras[1]);
                      setState(() {
                        _toggleCamera = true;
                      });
                    } else {
                      onCameraSelected(widget.cameras[0]);
                      setState(() {
                        _toggleCamera = false;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.flip,
                      size: 42.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showMessage('Camera Error: ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showException(e);
    }

    if (mounted) setState(() {});
  }

  void _captureImage() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          showMessage('Picture saved to $filePath');
          setCameraResult();
        }
      }
    });
  }

  void setCameraResult() {
    Navigator.pop(context, imagePath);
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showMessage('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/FlutterCanary';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      showException(e);
      return null;
    }
    return filePath;
  }

  void showException(CameraException e) {
    logError(e.code, e.description);
    showMessage('Error: ${e.code}\n${e.description}');
  }

  void showMessage(String message) {
    print(message);
  }

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  Future<Directory> getApplicationDocumentsDirectory() async {
    return Directory("/sdcard");
  }
}

class Mask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MaskState();
  }
}

class MaskState extends State<Mask> {
  var opacity = 0.5;
  var path = null;

  @override
  void initState() {
    super.initState();
    getMaskFile().then((f) {
      setState(() {
        path = f;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return path == null
        ? Text("")
        : GestureDetector(
            child: Center(
                child: Opacity(
              opacity: opacity,
              child: Image.file(path, scale: 0.5),
            )),
            onVerticalDragUpdate: (detail) {
              print(detail);
              opacity += detail.delta.dy / 30;
              if (opacity > 1.0) opacity = 1.0;
              if (opacity < 0) opacity = 0;
              setState(() {});
            });
  }

  Future<File> getMaskFile() async {
    var dir = Directory("/sdcard/FlutterCanary");
    var files = await dir.list().toList();
    files.sort((a, b) {
      return a.statSync().changed.compareTo(b.statSync().changed);
    });
    return File(files.last.path);
  }
}
