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

class selectgal extends StatefulWidget {
  @override
  _selectgal createState() => _selectgal();
}

class _selectgal extends State<selectgal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: FullWidthButton(
        width: double.infinity,
        text: "galerie",
        press: () async {
        },
      ),
    );
  }
}