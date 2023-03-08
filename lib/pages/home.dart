// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallpaper_verse_admin/resources/firestore_res.dart';
import 'package:wallpaper_verse_admin/utils/loader.dart';
import 'package:wallpaper_verse_admin/utils/pick_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _image;
  // Initial Selected Value
  String categoryDefaultValue = 'Nature';
  final CustomLoader _loader = CustomLoader();
  final TextEditingController _controller = TextEditingController();
  String ed_text = '';

  // List of items in our dropdown menu
  var categoryItems = [
    'Nature',
    'Animals',
    'Anime',
    'Sport car',
  ];
  //Pick Image.
  pickImage() async {
    Uint8List? im = await getPickedImage(ImageSource.gallery);
    // set state because we need to display the image.
    setState(() {
      _image = im;
    });
  }

  //UploadImage to storage.
  uploadImageToStorage() async {
    String status = await FirestoreRes().uploadUrl(
      _image!,
      categoryDefaultValue,
      _controller.text.trim(),
    );

    if (status == 'success') {
      //remove picked image.
      setState(() {
        _image = null;
      });
      //remove text.
      setState(() {
        ed_text = '';
      });
      //remove text from textfield.
      setState(() {
        _controller.text = '';
      });
      //hide loader
      _loader.hideLoader();
    } else {
      //show error
      print('An error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
      ),
      body: Stack(
        children: [
          //The body Column.
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Admin App',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        'Upload wallpapers',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                //Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.memory(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Pick Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Choose category.
                SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: DropdownButton(
                              // Initial Value
                              value: categoryDefaultValue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: categoryItems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    categoryDefaultValue = newValue!;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      //Name section.
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                content: Container(
                                  color: Colors.white,
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextField(
                                          controller: _controller,
                                          onSubmitted: (value) {
                                            setState(() {
                                              ed_text = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Wallpaper name',
                                            contentPadding:
                                                EdgeInsets.only(left: 8),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            ed_text = _controller.text.trim();
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.lightBlue,
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                'Continue',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 60,
                              color: Colors.white,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  ed_text.isEmpty ? 'Wallpaper name' : ed_text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //The upload button.
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: _image != null && ed_text.isNotEmpty
                  ? () {
                      uploadImageToStorage();
                      _loader.showLoader(context);
                    }
                  : () {
                      //print no image selected.
                      print('No image selected!');
                    },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _image != null && ed_text.isNotEmpty
                        ? Colors.lightBlue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  child: Center(
                    child: Text(
                      'Upload wallpaper',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
