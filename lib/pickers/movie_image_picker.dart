import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MovieImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  MovieImagePicker(this.imagePickFn);
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<MovieImagePicker> {
  File _image;
  final picker = ImagePicker();

  void getImages(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.imagePickFn(_image);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  void _openImagePicker(BuildContext context, theme, mediaQuery) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: mediaQuery.size.height * 0.28,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: mediaQuery.size.height * 0.01,
                ),
                Row(children: <Widget>[
                  Text(
                    'pick image',
                    style: theme.textTheme.headline5,
                  ),
                ]),
                SizedBox(
                  height: mediaQuery.size.height * 0.05,
                ),
                FlatButton(
                  textColor: theme.primaryColor,
                  child: Text(
                    'use Camera',
                    style: theme.textTheme.bodyText1,
                  ),
                  onPressed: () => getImages(context, ImageSource.camera),
                ),
                FlatButton(
                  textColor: theme.primaryColor,
                  child: Text(
                    "use Gallary",
                    style: theme.textTheme.bodyText1,
                  ),
                  onPressed: () => getImages(context, ImageSource.gallery),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            _openImagePicker(
                context, Theme.of(context), MediaQuery.of(context));
          },
        ),
      ],
    );
  }
}
