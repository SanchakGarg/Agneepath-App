import 'dart:io';

import 'Home.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Group related variables into a class
class UserData {
  static String? Name;
  static String? Batch;
  static String? PhoneNo;
  static String? Designation;
  static String? CurrentStatus;
  static String? scannedId;
  static bool Report = false;
}
bool updatephoto = false;
bool updatedata = false;
bool scan = true;

// class Scanner extends StatefulWidget {
//   const Scanner({super.key});
//
//   @override
//   State<Scanner> createState() => _ScannerState();
// }
//
// class _ScannerState extends State<Scanner> {
//   FlutterBarcodeSdk _barcodeReader = FlutterBarcodeSdk();
//
//   void ini()async{
//     await _barcodeReader.setLicense('DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==');
//     await _barcodeReader.init();
//   }
//   @override
//   void initState(){
//     super.initState();
//     ini();
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(backgroundColor: Colors.transparent,),
//       body: Stack(children: [
//
//         ,QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))],),
//     );
//   }
// }
//

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  bool scanStatus = false;
  late QRViewController controller;

  void closeSheet() {
    setState(() {
      UserData.Report = false;
      scan = true;
      updatedata = false;

      if (kIsWeb != true) {
        controller.resumeCamera();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    UserData.Report = false;
    UserData.scannedId = null;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text('scanner'),),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     IconButton(
            //         onPressed: () {
            //           Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const Navigate()));
            //         ,
            //         icon: const Icon(
            //           FontAwesomeIcons.arrowLeft,
            //           color: Colors.black,
            // //         ))
            //   ],
            // ),
            // backgroundColor: Colors.transparent),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            if (kIsWeb)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.6),
                child: QRScannerOverlay(
                    overlayColour: Colors.black.withOpacity(
                        0.5)), // Set the background color with opacity
              ),
            Positioned(bottom: 10, child: buildResult()),
          ],
        ),
      ),
    );
  }

  Widget buildResult() => Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white24),
      child: Text(barcode != null ? 'result: ${barcode!.code}' : 'scan a code!',
          maxLines: 3));

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: kIsWeb != true
            ? QrScannerOverlayShape(
                borderWidth: 15,
                borderRadius: 10,
                borderLength: 50,
                borderColor: Colors.purple,
                cutOutSize: 400,
              )
            : null,
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
        // controller.stopCamera();
        if (kIsWeb != true) {
          controller.pauseCamera();
        } else {}

        if (scan) {
          setState(() {
            scan = false;
          });
          showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              context: context,
              builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const InfoSheet())).then((value) => closeSheet());
        }
        // else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Scaffold(body:InfoSheet())));
        UserData.scannedId = barcode.code;
      });
    });
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late String imageUrl;
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    if(updatephoto){ setState(() {
    });}
    imageUrl = '';
    getImageUrl();

  }

  void getImageUrl() async {

    final ref = storage.ref().child('${UserData.scannedId}.jpg');
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  void imagehandler() async {
    updatephoto = false;

    // if(kIsWeb) final picker =
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera,maxHeight: 300,maxWidth: 300,imageQuality: 30);
    // final pickedFile = await
    print(pickedFile?.path ?? 'null');
    final storage = FirebaseStorage.instance;
    if (pickedFile != null) {
      final ref = storage.ref().child('${UserData.scannedId}.jpg');
      ref.putFile(File(pickedFile.path)).then((value) {getImageUrl();
      });
    } else {}
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: 70,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => const SizedBox(
        height: 140,
        width: 140,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error_outline_outlined,
        size: 140,
      ),
    ),SizedBox(
      height: 25,
      width: 150,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.black),
          onPressed: imagehandler,
          child: Text(
            'Upload image',
          )),
    )],);
  }
}

class InfoSheet extends StatefulWidget {
  const InfoSheet({super.key, Key? key1});

  @override
  State<InfoSheet> createState() => _InfoSheetState();
}

class _InfoSheetState extends State<InfoSheet> {
  final audioPlayer = AudioPlayer();
  double _width = 200;

  void changeupdatestate() {
    setState(() {
      updatedata = !updatedata;
    });
  }

  Future<void> addDataToSheet(name, University, PhoneNo, Mode) async {
    var url = "https://script.google.com/macros/s/AKfycbxrHMfImN8Mc3kH0P5P8RBqWr69qjKNCyd3Cf_4aNJjKXx0cJ4NxxZ9vJuD_z0ew63rYQ/exec";
    var data = {
      'Time': '${DateTime.now()}',
      'Name': '$name',
      'University': '$University"',
      'PhoneNo': '$PhoneNo',
      'Mode': '$Mode',
      'Authorised_by': Authorisation_person,
      'ID': UserData.scannedId,
      // 'U':U,
    };
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
    } else {}
  }

  @override
  void initState() {
    super.initState();
    UserData.Report = false;
    readData();
  }

  void readData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Guests/${UserData.scannedId}').get();
    if (snapshot.exists) {
      setState(() {
        // _width = MediaQuery.of(context).size.width*0.7;

        UserData.Name =
            snapshot.child('Name').value?.toString() ?? 'Not Available';
        UserData.Batch =
            snapshot.child('Batch').value?.toString() ?? 'Not Available';
        UserData.Designation =
            snapshot.child('Designation').value?.toString() ?? 'Not Available';
        UserData.PhoneNo =
            snapshot.child('PhoneNo').value?.toString() ?? 'Not Available';
        UserData.CurrentStatus =
            snapshot.child('Current Status').value?.toString() ??
                'Not Available';
      });
    } else {
      setState(() {
        UserData.Name = "Not Available";
        UserData.Batch = "Not Available";
        UserData.Designation = "Not Available";
        UserData.PhoneNo = "Not Available";
        UserData.CurrentStatus = "Not Available";
      });
    }

    if (UserData.CurrentStatus == choice.first) {
      setState(() {
        UserData.Report = true;
        audioPlayer.stop();
        audioPlayer.play(AssetSource('audio/error.mp3'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Stack(
        children: [
          Positioned(
              left: 15,
              top: 15,
              child: IconButton(
                  onPressed: changeupdatestate,
                  icon: Icon(updatedata
                      ? FontAwesomeIcons.xmark
                      : FontAwesomeIcons.penToSquare))),
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width * 0.31,
            child: Column(
              children: [
                const ImageWidget(),

              ],
            ),
          ),
          Positioned(
            top: 210,
            left: MediaQuery.of(context).size.width * 0.1,
            child: updatedata
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Name: '),
                              SizedBox(
                                  height: 30,
                                  width: _width,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: UserData.Name),
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                    ),
                                    onChanged: (value) {
                                      UserData.Name = value;
                                    },
                                  ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Batch: '),
                              SizedBox(
                                  height: 30,
                                  width: _width,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: UserData.Batch),
                                    decoration: InputDecoration(
                                      hintText: 'Batch',
                                    ),
                                    onChanged: (value) {
                                      UserData.Batch = value;
                                    },
                                  ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Designation: '),
                              SizedBox(
                                  height: 30,
                                  width: _width,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: UserData.Designation),
                                    decoration: InputDecoration(
                                      hintText: 'Designation',
                                    ),
                                    onChanged: (value) {
                                      UserData.Designation = value;
                                    },
                                  ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phone Number: '),
                              SizedBox(
                                  height: 30,
                                  width: _width,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: UserData.PhoneNo),
                                    decoration: InputDecoration(
                                      hintText: 'Phoneno',
                                    ),
                                    onChanged: (value) {
                                      UserData.PhoneNo = value;
                                    },
                                  ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Current status: ${UserData.CurrentStatus}'),
                            ],
                          ))
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${UserData.Name}'),
                      Text('Batch: ${UserData.Batch}'),
                      Text('Designation: ${UserData.Designation}'),
                      Text('Phone Number: ${UserData.PhoneNo}'),
                      Text('Current status: ${UserData.CurrentStatus}')
                    ],
                  ),
          ),
          if (UserData.Report == true && updatedata == false)
            Positioned(
                bottom: 50,
                left: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  'The person is already ${UserData.CurrentStatus}',
                  style: const TextStyle(color: Colors.red),
                )),
          if (UserData.Report == true && updatedata == false)
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.red),
                onPressed: () {
                  final rpData = {
                    "${DateTime.now()}": {
                      'Name': UserData.Name,
                      'Batch': UserData.Batch,
                      'Designation': UserData.Designation,
                      'Phone Number': UserData.PhoneNo,
                      'Desc': 'Person Was already ${UserData.CurrentStatus}'
                    }
                  };
                  FirebaseFirestore.instance
                      .collection('Reports')
                      .doc(UserData.scannedId)
                      .update(rpData)
                      .then((value) {
                    addDataToSheet(
                        UserData.Name,
                        UserData.Designation,
                        UserData.PhoneNo,
                        'Report: The person is already ${UserData.CurrentStatus}');
                    setState(() {
                      scan = true;
                    });
                    // if(kIsWeb) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Scanner()));
                    Navigator.pop(context);

                    audioPlayer.stop();
                    audioPlayer.play(AssetSource('audio/report.mp3'));
                  }).catchError((error) {
                    // Handle error during update

                    // Retry with set in case update fails
                    FirebaseFirestore.instance
                        .collection('Reports')
                        .doc(UserData.scannedId)
                        .set(rpData)
                        .then((value) {
                      Navigator.pop(context);
                      audioPlayer.stop();
                      audioPlayer.play(AssetSource('audio/report.mp3'));
                    }).catchError((error) {
                      // Handle error during set
                    });
                  });
                },
                child: const Row(
                  children: [Icon(Icons.error), Text('Report')],
                ),
              ),
            ),
          if (UserData.Report == false &&
              choice.first == 'in' &&
              updatedata == false)
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  FirebaseDatabase.instance
                      .ref('Guests/${UserData.scannedId}')
                      .update({'Current Status': 'in'}).then((value) {
                    FirebaseDatabase.instance.ref('Data/Status').update({
                      'in': ServerValue.increment(1),
                      'out': ServerValue.increment(-1)
                    }).then((value) {
                      addDataToSheet(UserData.Name, UserData.Designation,
                          UserData.PhoneNo, 'checked in');
                      // if(kIsWeb) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Scanner()));
                      Navigator.pop(context);
                      setState(() {
                        scan = true;
                      });
                      audioPlayer.stop();
                      audioPlayer.play(AssetSource('audio/check.mp3'));
                    });
                  });
                },
                child: const Text('Check in'),
              ),
            ),
          if (UserData.Report == false &&
              choice.first == 'out' &&
              updatedata == false)
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: () {
                  FirebaseDatabase.instance
                      .ref('Guests/${UserData.scannedId}')
                      .update({'Current Status': 'out'}).then((value) {
                    FirebaseDatabase.instance.ref('Data/Status').update({
                      'in': ServerValue.increment(-1),
                      'out': ServerValue.increment(1)
                    }).then((value) {
                      addDataToSheet(UserData.Name, UserData.Designation,
                          UserData.PhoneNo, 'checked out');
                      // if(kIsWeb) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Scanner()));
                      Navigator.pop(context);
                      audioPlayer.stop();
                      setState(() {
                        scan = true;
                      });
                      audioPlayer.play(AssetSource('audio/check.mp3'));
                    });
                  });
                },
                child: const Text('Check out'),
              ),
            ),
          Positioned(
            bottom: 10,
            left: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  UserData.Report = false;
                  scan = true;
                });
                // if(kIsWeb) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Scanner()));
                Navigator.pop(context);
                audioPlayer.stop();
                audioPlayer.play(AssetSource('audio/wrong.mp3'));
              },
              child: const Text('Deny/close'),
            ),
          ),
          if (updatedata)
            Positioned(
              right: 10,
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black),
                onPressed: () {
                  setState(() {
                    updatedata = false;
                  });
                  setState(() async {
                    DatabaseReference ref = FirebaseDatabase.instance.ref();
                    final snapshot =
                        await ref.child('Guests/${UserData.scannedId}').update({
                      'Name': UserData.Name,
                      'Batch': UserData.Batch,
                      'Designation': UserData.Designation,
                      'PhoneNo': UserData.PhoneNo
                    }).then((value) =>  addDataToSheet(UserData.Name, UserData.Designation,
                          UserData.PhoneNo, 'Updated the data'));
                    audioPlayer.stop();
                    audioPlayer.play(AssetSource('audio/check.mp3'));
                  });
                  // if(kIsWeb) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Scanner()));
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ),
        ],
      ),
    );
  }
}

class ErrorWidget extends StatefulWidget {
  const ErrorWidget({super.key, Key? key2});

  @override
  State<ErrorWidget> createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<ErrorWidget> {
  bool errorDis = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      errorDis = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        errorDis = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: errorDis
          ? const Icon(
              Icons.error,
              size: 140,
            )
          : const SizedBox(
              height: 140,
              width: 140,
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key, required this.overlayColour});

  final Color overlayColour;

  @override
  Widget build(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width * 0.8;
    return Stack(children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            overlayColour, BlendMode.srcOut), // This one will create the magic
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: scanArea,
                width: scanArea,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: CustomPaint(
          foregroundPainter: BorderPainter(),
          child: SizedBox(
            width: scanArea + 25,
            height: scanArea + 25,
          ),
        ),
      ),
    ]);
  }
}

// Creates the white borders
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    const radius = 20.0;
    const tRadius = 3 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    const clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarReaderSize {
  static double width = 200;
  static double height = 200;
}

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(size.width - 44, size.height - 44), radius: 40))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}
