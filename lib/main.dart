import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

import 'scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final picker = ImagePicker();

  String _platformVersion = 'Unknown';

  String qrcode = 'Unknown';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [

              Text('Running on: $_platformVersion\n'),
              Wrap(
                children: [
                  ElevatedButton(
                    child: const Text("parse from image"),
                    onPressed: () async {
                     final res = await picker.pickImage(source: ImageSource.gallery);
                      if (res != null) {
                        String? str = await Scan.parse(res.path);
                        if (str != null) {
                          setState(() {
                            qrcode = str;
                          });
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text('go scan page'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) {
                            return ScanPage();
                          }));
                    },
                  ),
                ],
              ),
              Text('scan result is $qrcode'),
            ],
          ),
        ),
      },
    );
  }
}


