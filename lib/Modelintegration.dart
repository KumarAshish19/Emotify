import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ModelIntegration extends StatefulWidget {
  const ModelIntegration({super.key});

  @override
  State<ModelIntegration> createState() => _ModelIntegrationState();
}

class _ModelIntegrationState extends State<ModelIntegration> {
  XFile? _image;
  List? _outputs;

  @override
  void initState() {
    super.initState();

    loadmodel();
  }

  Future<void> loadmodel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        // defaults to 1
        isAsset: true,
        // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
        false // defaults to false, set to true to use GPU delegate
    );
  }

  Future<void> runonimage(XFile image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        // required
        imageMean: 0.0,
        // defaults to 117.0
        imageStd: 255.0,
        // defaults to 1.0
        numResults: 2,
        // defaults to 5
        threshold: 0.2,
        // defaults to 0.1
        asynch: true // defaults to true
    );

    setState(() {
      _outputs = recognitions;
    });
  }

  pickedimage() async {
    final imagepicked =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = imagepicked;
    });

    runonimage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Emote Expression Detector"),
          backgroundColor: Colors.lightBlue,
        ),
        body: Column(
          children: [
            _image == null
                ? Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 300,
                  width: 300,
                  child: Image.asset(
                    "assets/f.gif",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
                : Center(
              child: Container(
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.fill,
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _image == null
                ? Container()
                : _outputs != null
                ? Text(
              _outputs![0]["label"],
              style: TextStyle(color: Colors.black, fontSize: 25),
            )
                : Text(""),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: pickedimage,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent),
                child: Text(
                  "Pick Image",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }
}
