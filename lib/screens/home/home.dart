import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'bottom_nav.dart' as bn;
import 'package:http/http.dart' as http;
import 'package:wiredash/wiredash.dart';



class Home extends StatefulWidget {
  Home({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraController controller;
  late ImagePicker picker;
  late PickedFile? pickedImage;

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.camera, ResolutionPreset.max);
    picker = ImagePicker();
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }
  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // read picked image byte data.
    Uint8List imagebytes = await image!.readAsBytes();
    String base64Image = base64.encode(imagebytes);
    Map<String, String> data = {"body": base64Image};
    String apiUrl = "https://eewd3ide09.execute-api.eu-west-3.amazonaws.com/Deepqual/api-yolo";

    Map<String, String> data1 = {"body": base64Image};
    String apiUrl1 = "https://eewd3ide09.execute-api.eu-west-3.amazonaws.com/Deepqual/api-yolo";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    http.Response response = await http.post(Uri.parse(apiUrl1),
        body: json.encode(data1));
    String responseBody = response.body;
    if (response.statusCode == 200) {
      Navigator.pop(context); // Close the waiting bar dialog
      Uint8List bytesImage = const Base64Decoder().convert(responseBody);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  bn.Feedback(imageBytes: bytesImage, data : data1 ),
        ),
      );



    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Loading error. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
  }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          CameraPreview(controller),

          Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/images/camera_box.png',
                // width: 150,
                // height: 150,
              ),
            ),
          ),
          bn.BottomNav(cameraController: controller),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Text('Load Image'),
              ),
            ),
          ),



        ],
      ),
    );
  }
}



