// To parse this JSON data, do
//
//     final histroyModel = histroyModelFromJson(jsonString);

import 'dart:convert';

HistroyModel histroyModelFromJson(String str) =>
    HistroyModel.fromJson(json.decode(str));

String histroyModelToJson(HistroyModel data) => json.encode(data.toJson());

class HistroyModel {
  DateTime name;
  String printerName;

  HistroyModel({
    required this.name,
    required this.printerName,
  });

  factory HistroyModel.fromJson(Map<String, dynamic> json) => HistroyModel(
        name: DateTime.parse(json["name"]),
        printerName: json["printerName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name.toIso8601String(),
        "printerName": printerName,
      };
}
