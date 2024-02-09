// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  String name;
  int date;
  int month;
  int year;

  DataModel(
      {required this.name,
      required this.date,
      required this.month,
      required this.year});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      name: json["name"],
      date: json["date"],
      month: json["month"],
      year: json["year"] ?? 2000);

  Map<String, dynamic> toJson() =>
      {"name": name, "date": date, "month": month, "year": year};
}
