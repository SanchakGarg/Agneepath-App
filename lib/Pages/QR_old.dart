import 'Home.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
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
      controller.resumeCamera();
    });
  }
  @override
  void initState() {
    super.initState();
    UserData.Report = false;
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
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
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
    overlay: QrScannerOverlayShape(
      borderWidth: 15,
      borderRadius: 10,
      borderLength: 50,
      borderColor: Colors.purple,
      cutOutSize: MediaQuery.of(context).size.width * 0.8,
    ),
  );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
        controller.pauseCamera();
        print('changed');
        showModalBottomSheet(isDismissible: false,
            context: context, builder: (context) => const InfoSheet()).then(
                (value) => closeSheet());
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

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
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
      errorWidget: (context, url, error) =>
      const Icon(Icons.error_outline_outlined, size: 140,),
    );
  }
}

class InfoSheet extends StatefulWidget {
  const InfoSheet({super.key, Key? key1});

  @override
  State<InfoSheet> createState() => _InfoSheetState();
}

class _InfoSheetState extends State<InfoSheet> {
  final audioPlayer = AudioPlayer();

  Future<void> addDataToSheet(name,University,PhoneNo,Mode) async {
    var url = "https://script.google.com/macros/s/AKfycbwCH2Ae2ZlCU_oYo50k49oJDtjKGNDgQcl0HsFbuNAElyqSoaRowp_fTNjpbG5oW4Tvzg/exec";
    var data = {
      'Time': '${DateTime.now()}',
      'Name': '$name',
      'University': '$University"',
      'PhoneNo': '$PhoneNo',
      'Mode': '$Mode',
      'Authorised_by': Authorisation_person,
    };
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      print('Data added successfully');
    } else {
      print('Error adding data');
    }
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
        UserData.Name = snapshot.child('Name').value?.toString() ?? 'Not Available';
        UserData.Batch = snapshot.child('Batch').value?.toString() ?? 'Not Available';
        UserData.Designation = snapshot.child('Designation').value?.toString() ?? 'Not Available';
        UserData.PhoneNo = snapshot.child('PhoneNo').value?.toString() ?? 'Not Available';
        UserData.CurrentStatus = snapshot.child('Current Status').value?.toString() ?? 'Not Available';
      });
      print(
          '---------------------------------------------------------------------${UserData.Name},${UserData.Batch},${UserData.Designation},${UserData.PhoneNo},${UserData.CurrentStatus}');
    } else {
      setState(() {
        UserData.Name = "Not Available";
        UserData.Batch = "Not Available";
        UserData.Designation = "Not Available";
        UserData.PhoneNo = "Not Available";
        UserData.CurrentStatus = "Not Available";
        print('No data available.');
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
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width * 0.31,
            child: const ImageWidget(),
          ),
          Positioned(
            top: 190,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Column(
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
          if(UserData.Report == true) Positioned(bottom: 50,left: MediaQuery.of(context).size.width*0.3,child: Text('The person is already ${UserData.CurrentStatus}',style: const TextStyle(color: Colors.red),)),
          if (UserData.Report == true)
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, foregroundColor: Colors.red),
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
                    addDataToSheet(UserData.Name, UserData.Designation, UserData.PhoneNo, 'Report: The person is already ${UserData.CurrentStatus}');

                    Navigator.pop(context);
                    audioPlayer.stop();
                    audioPlayer.play(AssetSource('audio/report.mp3'));
                  })
                      .catchError((error) {
                    // Handle error during update
                    print('Update failed: $error');
                    // Retry with set in case update fails
                    FirebaseFirestore.instance
                        .collection('Reports')
                        .doc(UserData.scannedId)
                        .set(rpData)
                        .then((value) {
                      Navigator.pop(context);
                      audioPlayer.stop();
                      audioPlayer.play(AssetSource('audio/report.mp3'));
                    })
                        .catchError((error) {
                      // Handle error during set
                      print('Set failed: $error');
                    });
                  });

                },
                child: const Row(
                  children: [Icon(Icons.error), Text('Report')],
                ),
              ),
            ),
          if (UserData.Report == false)
            if (choice.first == 'in')
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
                        .update({'Current Status': 'in'}).then((value){FirebaseDatabase.instance.ref('Data/Status').update(
                      {'in':ServerValue.increment(1),'out':ServerValue.increment(-1)}
                    ).then((value) {
                      addDataToSheet(UserData.Name, UserData.Designation, UserData.PhoneNo, 'checked in');
                      Navigator.pop(context);
                    audioPlayer.stop();
                    audioPlayer.play(AssetSource('audio/check.mp3'));});});

                  },
                  child: const Text('Check in'),
                ),
              ),
          if (UserData.Report == false)
            if (choice.first == 'out')
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
                        .update({'Current Status': 'out'}).then((value) { FirebaseDatabase.instance.ref('Data/Status').update(
                      {'in':ServerValue.increment(-1),'out':ServerValue.increment(1)}
                    ).then((value) {
                      addDataToSheet(UserData.Name, UserData.Designation, UserData.PhoneNo, 'checked out');
                      Navigator.pop(context);
                      audioPlayer.stop();
                      audioPlayer.play(AssetSource('audio/check.mp3'));
                    });});

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
                });
                Navigator.pop(context);
                audioPlayer.stop();
                audioPlayer.play(AssetSource('audio/wrong.mp3'));
              },
              child: const Text('Deny'),
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
          ? const Icon(Icons.error, size: 140,)
          : const SizedBox(
        height: 140,
        width: 140,
        child: CircularProgressIndicator(),
      ),
    );
  }
}