import 'package:camera/camera.dart';

import 'camera_page.dart';



List<CameraDescription> cameras;

const CAMERA_PAGE = "camera_page";
final ROUTES = {
  CAMERA_PAGE: (context) => CameraPage(cameras[0]),
};