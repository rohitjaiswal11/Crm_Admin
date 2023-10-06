import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ToastClass.dart';

Future<File?> pickImageFromGallery({int? imageQuality}) async {
  var status = await Permission.storage.request();

  if (status.isDenied) {
    ToastShowClass.toastShow(null,'Storage Permission Required!!', Colors.red);
    return null;
  } else {
    // ignore: invalid_use_of_visible_for_testing_member
    var picture = await ImagePicker.platform
        .getImage(source: ImageSource.gallery, imageQuality: imageQuality);
    if (picture != null) {
      File _imageFilePicked = File(picture.path);
      return _imageFilePicked;
    } else {
      return null;
    }
  }
}

Future<File?> pickImageFromCamera({int? imageQuality}) async {
  var status = await Permission.camera.request();

  if (status.isDenied) {
    ToastShowClass.toastShow(null,'Camera Permission Required!!', Colors.red);
    return null;
  } else {
    var picture = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: imageQuality);
    print('picture ===>>> $picture <<<>>>  path = ${picture!.path}');
    // ignore: unnecessary_null_comparison
    if (picture != null) {
      File _imageFilePicked = File(picture.path);
      return _imageFilePicked;
    } else {
      return null;
    }
  }

  // XFile? pickedFile = await ImagePicker().pickImage(
  //   source: ImageSource.camera,
  //   maxWidth: 500,
  //   maxHeight: 500,
  // );
  // if (pickedFile != null) {
  //   File imageFile = File(pickedFile.path);
  //   return imageFile;
  // }
}
