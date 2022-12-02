import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:upmarket/controller/AddingService.dart';

import '../models/details.dart';
import 'home.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({Key? key}) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

File? pic;
String? path;
String? fileName;
bool _isLoading = false;
final addService = Get.put(AddingService());

final nameController = TextEditingController();

class _AddDetailsState extends State<AddDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: (pic != null) ? FileImage(pic!) : null,
              ),
              MaterialButton(
                onPressed: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg'],
                  );
                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Not selected any image')));
                    return null;
                  }
                  path = results.files.single.path!;
                  fileName = results.files.single.name;
                  File convert = File(path!);
                  setState(() {
                    pic = convert;
                  });
                  print('this is path name ${path}');
                  print("file name${fileName}");
                  imageService.uploadFile(path!, fileName!).then((value) {
                    print("Done");
                  });
                },
                child: const Text('Add Image'),
                color: Colors.green,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty && pic != null) {
                    return 'Enter name and image';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await addService.addNameImage(Details(
                        id: null,
                        title: nameController.text.trim(),
                        downloadUrl: imageService.downloadString.value));
                    setState(() {
                      _isLoading = false;
                    });
                    Get.back();
                  },
                  child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
