import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttergg/pages/home.dart';
import 'package:fluttergg/widgets/header.dart';
import 'package:image_picker/image_picker.dart';
final StorageReference storageRef = FirebaseStorage.instance.ref();

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username='abcd';
  File file;
  String _uploadedFileURL;
  StorageReference storageReference;

//  TextEditingController captionController = TextEditingController();
  bool isUploading = false;

  submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });

    }
  }


  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
      print('file is +$file');

    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }


  Future uploadFile() async {
    storageReference = FirebaseStorage.instance
        .ref()
        .child("userImageList/userImage${currentUser.id}.jpg");
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');

//    storageReference.getDownloadURL().then((fileURL) {
//
//
//
//setState(() {
//  _uploadedFileURL = fileURL;
//  print('inuploadfile   $_uploadedFileURL');
//});
//
//    });
  }


  handleSubmit() async {

   // print(Firestore.instance.collection('users').document(currentUser.id));

    if(file==null) {

      print('fie is nyllll $username');

       await Firestore.instance.collection('users')
          .document(currentUser.id)
          .updateData(
          {
            'displayName': username,
          });
    }

    else
      {
        await uploadFile();

        _uploadedFileURL = await storageReference.getDownloadURL();
        await Firestore.instance.collection('users').document(currentUser.id).updateData(
            {
              'displayName': username,
              'coverlink': _uploadedFileURL
            }
        );
      }


//    captionController.clear();
//    setState(() {
//      file = null;
//      isUploading = false;
//    });
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,
          titleText: "Set up your profile", removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create a username",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "Username too short";
                          } else if (val.trim().length > 12) {
                            return "Username too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          setState((){
                             username = val;
                            print('usernmae is $username');
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                      ),
                    ),
                  ),
                ),
                //Text('ascasd'),

                Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 30),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Upload Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                      color: Colors.deepOrange,
                      onPressed: () => selectImage(context)
                  ),
                ),


                GestureDetector(
                  onTap: ()async{

                    await submit();
                    handleSubmit();

                  },
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
