import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'screen/camera_screen.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CameraApp();
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if(!mounted) {
        return;
      }

      setState(() {});
    }).catchError((e) {
      if(e is CameraException){
        switch(e.code) {
          case 'CameraAccessDenied':
            print('CameraAccessDenied');
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          child: CameraPreview(_controller),
        ),
          Column(
            children: [
              Center(
                child: MaterialButton(
                  onPressed: () async {
                    if (!_controller.value.isInitialized) {
                      return null;
                    }
                    if (_controller.value.isTakingPicture) {
                      return null;
                    }

                    try {
                      await _controller.setFlashMode((FlashMode.auto));
                      XFile file = await _controller.takePicture();

                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ImgPreview(file))
                      );
                    } on CameraException catch (e) {
                      debugPrint('Error taking picture: $e');
                      return null;
                    }
                  },
                  color: Colors.amberAccent,
                  child: Text('Photo'),
                ),
              )
            ],
          ),
      ],
    );
  }
}
