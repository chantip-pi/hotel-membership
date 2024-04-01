import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class FirebaseImageUtils {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadImageFromGallery(String folderName) async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        String fileName =
            '$folderName/${DateTime.now().millisecondsSinceEpoch}_${pickedImage.name}';

        final firebase_storage.Reference reference =
            storage.ref().child(fileName);

        await reference.putFile(File(pickedImage.path));
        String imageUrl = await reference.getDownloadURL();
        return imageUrl;
      } else {
        throw Exception('Image selection from gallery cancelled.');
      }
    } catch (e) {
        print('Error uploading image from gallery: $e');
        rethrow;
    }
  }

  Future<String> uploadImageFromCamera(String folderName) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      if (pickedImage != null) {
        String fileName = '$folderName/${DateTime.now().millisecondsSinceEpoch}_${pickedImage.name}';

        final firebase_storage.Reference reference =
            storage.ref().child(fileName);

        await reference.putFile(File(pickedImage.path));
        String imageUrl = await reference.getDownloadURL();
        return imageUrl;
      } else {
        throw Exception('Image capture from camera cancelled.');
      }
    } catch (e) {
        print('Error capturing image from camera: $e');
        rethrow;
    }
  }

  Future<void> deletePictureByUrl(String imageUrl) async {
    try {
      // Convert the imageUrl to a storage Reference
      final firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the file
      await reference.delete();
      print('Picture deleted successfully');
    } catch (e) {
      print('Error deleting picture: $e');
      // Handle error as needed
    }
  }
}
