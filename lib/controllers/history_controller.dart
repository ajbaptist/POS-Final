import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:thermal_printer_example/model/history_model.dart';
import 'package:thermal_printer_example/utils/database_helper.dart';

class PrintingHistoryController extends GetxController {
  var historyData = <HistroyModel>[
    HistroyModel(
        name: DateTime.now(),
        printerName: 'printer Name Example Demo For Testing Application')
  ].obs;

  getPrinterData() async {
    try {
      List<HistroyModel> data = DatabaseManager.instance.fetcHistoryData();
      if (data.isNotEmpty) {
        historyData.value = data;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  void onInit() {
    getPrinterData();
    super.onInit();
  }
}
