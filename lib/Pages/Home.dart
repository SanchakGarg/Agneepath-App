import 'package:agneepath_app/Pages/Dashboard.dart';
import 'package:agneepath_app/Pages/QR.dart';
import 'package:flutter/material.dart';
import 'package:agneepath_app/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
Set choice={'in'};

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final idcontroller = TextEditingController();
  void find(){
    setState(() {
      UserData.scannedId = idcontroller.text;

      showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const InfoSheet())).then(
              (value) {
            setState(() {
              UserData.Report = false;
            });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Home'),),backgroundColor: Colors.white,
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Column(mainAxisAlignment: MainAxisAlignment.center,children: [const choicebutton(),
            ElevatedButton(
              onPressed: () async {Navigator.push (context, MaterialPageRoute(builder: (context) => const Scanner()));},
              child: const Text('Start scanning'),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width*0.78,
                  height: 40,
                  child: TextField(
                    controller: idcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      hintText: 'Enter ID',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14,),contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),),),),
                      ElevatedButton(onPressed: find, child: const Text('Find'))
              ],
            )],),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
              onPressed: ()  {signout();},
              child: const Text('sign out'),
            ),
          ],


        ),)

    );
  }
}






class choicebutton extends StatefulWidget {
  const choicebutton({super.key});


  @override
  State<choicebutton> createState() => _choicebuttonState();
}

class _choicebuttonState extends State<choicebutton> {
  @override

  Widget build(BuildContext context) {
    return SegmentedButton(segments: const [ButtonSegment(value: 'in',label: Text(' check in')),ButtonSegment(value: 'out' , label: Text('check out'))], selected: choice  , onSelectionChanged: (selected){
      print('mode: $selected');
      setState(() {choice=selected;});
      print(choice.first);
    } ,);
  }
}



class Navigate extends StatefulWidget {
  const Navigate({super.key});

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  var CurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(destinations: const [NavigationDestination(icon: Icon(FontAwesomeIcons.qrcode), label: 'QR-scan'),NavigationDestination(icon: Icon(FontAwesomeIcons.tableColumns), label: 'Dashboard')],
        selectedIndex: CurrentIndex,
        onDestinationSelected: (int index){

          setState(() {CurrentIndex = index;});
        },
      ),
      body: [const Home(),const Dashboard()][CurrentIndex],
    );
  }
}