import 'package:bunkerlink/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/files/service.dart';

class Avatar extends StatefulWidget {
  final User user;

  const Avatar({super.key, required this.user});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final FileService _fileService = FileService();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Show dialog or bottom sheet to upload image
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Avatar'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        final file = await FileService.pickImageFromGallery();
                        if (file == null) return;
                        final newAvatar = await _fileService.uploadAvatar(file);
                        Navigator.of(context).pop();
                        setState(() {
                          widget.user.setAvatar(newAvatar);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          'Choose from Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      onTap: () async {
                        final file = await FileService.takePhotoFromCamera();
                        if (file == null) return;
                        final newAvatar = await _fileService.uploadAvatar(file);
                        Navigator.of(context).pop();
                        setState(() {
                          widget.user.setAvatar(newAvatar);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          'Take a Photo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
          widget.user.avatar == ''
              ? 'https://via.placeholder.com/150'
              : widget.user.avatar!,
        ),
      ),
    );
  }
}
