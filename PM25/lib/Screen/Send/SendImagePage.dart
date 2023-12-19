import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/PreviewSendImagePage.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      appBar: AppBar(
        title: Text(
          '자료 생성',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "원하시는 학습자료를 만들기 위해 하나를 선택해 주세요!",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: _pickImageFromCamera,
              icon: SvgPicture.asset(
                'assets/imgs/Camera.svg',
                width: 100,
                height: 100,
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '카메라',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 150),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: SvgPicture.asset(
                'assets/imgs/image.svg',
                width: 100,
                height: 100,
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '사진첩',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 150),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}