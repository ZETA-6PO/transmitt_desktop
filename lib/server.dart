import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:socket_io/socket_io.dart';
import 'package:transmitt_desktop/converter.dart';
import 'package:transmitt_desktop/task_class.dart';

var io = new Server();

List<Task> tasks = [];
void server(String scode) {
  io.on('connection', (client) {
    print("conencted");
    client.on('request', (data) {
      print("x");
      print("my ${data["name"]}");
      if (data["rtype"] == "upload") {
        if (data["scode"] == scode) {
          tasks.add(Task(data["uuid"],  Utf8Decoder().convert(Uint8List.fromList(List<int>.from(data["name"]))), data["size"], data["idcode"], data["ext"]));
          client.emit('response', [{
            "type": "accepted",
            "uuid": data["uuid"],
          }]);
        }else{
          client.emit('response', [{
            "type": "error",
          }]);
        }
      }

    });


    client.on('task', (data) {

      if (data[0]["type"] == "transfer") {
          try {
            Task x = tasks.firstWhere(
              (element) {
                return element.uuid == data[0]["uuid"] && element.idcode == data[0]["idcode"];
              },
            );
            x.data = fromStr(data[0]["data"]);
            client.emit('response', JsonEncoder().convert({
              "type": "validate",
              "uuid": x.uuid
            }).toString());
            FileSaver.instance.saveFile(
              x.filename,
              x.data,
              x.ext,
              mimeType: MimeType.OTHER);
            x.termin();
          }on StateError{
            client.emit('response', JsonEncoder().convert({
              "type": "error",
            }).toString());//no task found
            return;
          }
      }

    });

    
  });
  io.listen(12221);
}
