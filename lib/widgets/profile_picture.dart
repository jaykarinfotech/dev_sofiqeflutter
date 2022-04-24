import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/provider/account_provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  Future<File> getProfilePicture() async {
    var dir = (await getExternalStorageDirectory());
    File file = File(join(dir!.path, 'front_facing.jpg'));
    return file;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (!Provider.of<AccountProvider>(context, listen: false).isLoggedIn) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size.height * 0.1)),
        child: Container(
            color: Colors.white,
            height: size.height * 0.1,
            width: size.height * 0.1,
            child: Center(
                child: Text(
              'Not logged in',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                  ),
            ))),
      );
    }
    return FutureBuilder(
        future: getProfilePicture(),
        builder: (BuildContext _, snapshot) {
          if (snapshot.data != null) {
            File file = snapshot.data as File;
            if (!file.existsSync()) {
              return ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(size.height * 0.1)),
                child: Container(
                    color: Colors.white,
                    height: size.height * 0.1,
                    width: size.height * 0.1,
                    child: Center(
                        child: Text(
                      'No Image',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                    ))),
              );
            }
            return ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(size.height * 0.1)),
              child: Container(
                height: size.height * 0.1,
                width: size.height * 0.1,
                child: Image.file(
                  snapshot.data as File,
                  fit: BoxFit.cover,
                  height: size.height * 0.09,
                  width: size.height * 0.09,
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
