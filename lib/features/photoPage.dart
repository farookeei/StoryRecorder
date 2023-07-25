import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../themes/color_variables.dart';

class PhotoPage extends StatelessWidget {
  final XFile file;

  const PhotoPage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Preview',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: ReplyColors.white),
            ),
            elevation: 0,
            backgroundColor: ReplyColors.neutralBold,
            actions: [
              IconButton(
                  onPressed: () {
                    Share.shareXFiles([file], text: 'Check out this video!');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: ReplyColors.white,
                  )),
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: ReplyColors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]),
        body: Container(
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.white),
            // imageProvider: AssetImage(filePath),
            imageProvider: FileImage(File(file.path)),
          ),
        ));
  }
}
