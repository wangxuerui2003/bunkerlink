import 'dart:io';
import 'package:bunkerlink/services/pocketbase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class FileService {
  final PocketBase client = PocketBaseClient().client;

  FileService();

  static Future<File?> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<File?> takePhotoFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<String> uploadAvatar(File file) async {
    try {
      final response = await client.collection('users').update(
        client.authStore.model!.id,
        files: [
          http.MultipartFile.fromBytes('avatar', file.readAsBytesSync(),
              filename: file.path),
        ],
      );
      final avatarFilename = response.data['avatar'];
      final avatarUrl =
          client.files.getUrl(response, avatarFilename, thumb: '100x250');
      return avatarUrl.toString();
    } on ClientException catch (e) {
      throw e.response['message'];
    }
  }
}
