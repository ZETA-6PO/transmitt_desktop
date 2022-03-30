import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/services.dart';
import 'package:socket_io/socket_io.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:flutter/material.dart';
import 'package:transmitt_desktop/server.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transmitt',
      theme: ThemeData(
        primarySwatch: Colors.teal  ,
      ),
      home: const MyHomePage(title: 'Transmitt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;

  String code = "";
  Future<String> getIp() async{
    List<NetworkInterface> x = await NetworkInterface.list();
    Iterable<NetworkInterface> v = x.where((element) {
      return element.name.toLowerCase().contains("wi-fi");
    });
    for (var i = 0; i < v.length; i++) {
      String ip = v.elementAt(i).addresses.firstWhere((element)  {
        return element.type == InternetAddressType.IPv4;
      }).address.toString();
      if (ip.split(".")[0]+ip.split(".")[1] == "192168") {
        return ip;
      }
    }
    return "";
    
    

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DesktopWindow.setMinWindowSize(Size(420,600));
    DesktopWindow.setMaxWindowSize(Size(420,600));
    var idcode = (Random().nextInt(9999)+1000).toString();
    getIp().then((value) async {
      code = '$value@$idcode';
      setState(() {
        loaded = true;
      });
    });
    server(idcode);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loaded?BarcodeWidget(
              barcode: Barcode.qrCode(
                
              ),
              data: code,
              width: 200,
              height: 200,
            ):CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top:30),
              child: Text("TO SEND A FILE TO THIS PC\nSCAN THIS WITH TRANSMITT ON YOUR PHONE", textAlign: TextAlign.center,textScaleFactor: 2,),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: 'Send file',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
