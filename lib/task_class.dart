import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class Task{
  final String uuid;
  final String filename;
  final String ext;
  final int size;
  final String idcode;

  Uint8List _data = Uint8List(0);

  Uint8List get data => _data;

  set data(Uint8List data) {
    _data = data;
  }

  bool _terminate = false;
  void termin() {
    _terminate = true;
  }
  bool isTerminated () {
    return _terminate;
  }
  Task(this.uuid, this.filename, this.size, this.idcode, this.ext);

  
}