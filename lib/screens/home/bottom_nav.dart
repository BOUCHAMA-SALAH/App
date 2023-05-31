import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poc_app/models/object.dart';

import '../../components/full_width_btn.dart';
import '../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:wiredash/wiredash.dart';
import 'package:poc_app/screens/home/home.dart';



// display The result :

class ImageScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final Map<String, String> data;

  ImageScreen({required this.imageBytes ,required this.data});
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Result"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.memory(
                widget.imageBytes,
                width: 400,
                height: 400,
              ),
            ),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              String apiUrl = "https://qlvpsmcs5m.execute-api.eu-west-3.amazonaws.com/saveimg/api-saveimages";
              http.Response response = await http.post(Uri.parse(apiUrl), body: json.encode(widget.data));
              Wiredash.of(context).show();
            },
            child: Text('Feedback'),
          ),
        ],
      ),
    );
  }
}





class BottomNav extends StatefulWidget {

  final CameraController cameraController;

  const BottomNav({
    Key? key, required this.cameraController
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int x = 0;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: FullWidthButton(
        width: double.infinity,
        text: "Check",
        press: () async {
          setState(() {
            isLoading = true;
          });

          /**
           * Prendre la photo*/
          XFile xImage = await widget.cameraController.takePicture();
          // xImage.saveTo("${docsDir.path}/camera_photo.jpg");

          /**
           * Conversion en base64
           */
          final bytes = await xImage.readAsBytes();
          String base64Image = base64Encode(bytes);
          //print("imageData length type = ${base64Image}");


          Map<String, String> data = {"body": base64Image};
          String apiUrl = "https://eewd3ide09.execute-api.eu-west-3.amazonaws.com/Deepqual/api-yolo";

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

          http.Response response = await http.post(Uri.parse(apiUrl),
                body: json.encode(data));
          String responseBody = response.body;
          if (response.statusCode == 200) {
            Navigator.pop(context); // Close the waiting bar dialog
            Uint8List bytesImage = const Base64Decoder().convert(responseBody);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Feedback(imageBytes: bytesImage, data : data ),
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



        },
      ),
    );
  }
}



class Feedback extends StatelessWidget {
  final Uint8List imageBytes;
  final Map<String, String> data;
  Feedback({required this.imageBytes ,required this.data});


  @override
  Widget build(BuildContext context) {
    return Wiredash(
      theme: WiredashThemeData.fromColor(
        // Customize Brightness and Colors
        // Primary button color, step indicator, focused input border
        primaryColor: Colors.indigo,
        // Secondary button color (optional)
        secondaryColor: Colors.purple,
        brightness: Brightness.light,
      ).copyWith(
        // i.e. selected labels, buttons on cards, input border
        primaryContainerColor: Colors.cyan,
        textOnPrimaryContainerColor: Colors.black,

        // i.e. labels when not selected
        secondaryContainerColor: Colors.blue,
        textOnSecondaryContainerColor: Colors.white,

        // the color behind the application, only visible when your app is
        // translucent
        appBackgroundColor: Colors.white,
        // The color of the "Return to app" bar
        appHandleBackgroundColor: Colors.blue[700],

        // The background gradient, top to bottom
        primaryBackgroundColor: Colors.white,
        secondaryBackgroundColor: Color(0xFFEDD9F6),

        errorColor: Colors.deepOrange,

        firstPenColor: Colors.yellow,
        secondPenColor: Colors.black,
        thirdPenColor: Color(0xffffebeb),
        fourthPenColor: Color(0xffced9e3),
      ),
      feedbackOptions: WiredashFeedbackOptions(
        labels: [
          // Take the label ids from your project console
          // https://console.wiredash.io/ -> Settings -> Labels
          Label(
            id: 'lbl-r65egsdf',
            title: 'WRONG DAMAGE DETECTION',
          ),
          Label(
            id: 'lbl-6543df23s',
            title: 'MISSING DAMAGE',
          ),
          Label(
            id: 'lbl-6543df23s',
            title: 'INSIGNIFICANT DAMAGE',
          )

        ],),

      projectId: 'testwiredash-burl1b1',
      secret: 'Q-7z6gUP1SYWppLxKo_Psf1ICxyHxjiO',
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: ImageScreen(imageBytes: imageBytes, data : data ),
      ),
    );
  }
}


