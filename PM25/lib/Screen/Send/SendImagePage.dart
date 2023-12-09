import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/PreviewSendImagePage.dart';

class SendImagePage extends StatefulWidget {
  @override
  _SendImagePageState createState() => _SendImagePageState();
}

class _SendImagePageState extends State<SendImagePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewSendImagePage(image: pickedImage)),
      );
    }
  }
  Future<void> _pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewSendImagePage(image: pickedImage)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Image')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickImageFromCamera,
            child: Text('카메라'),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery, // 사진첩 버튼 클릭 이벤트
            child: Text('사진첩'),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1,),

    );
  }
}
