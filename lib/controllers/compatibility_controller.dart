import 'dart:async';
import 'dart:developer';

import 'package:get/state_manager.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:thermal_printer_example/main.dart';
import 'package:thermal_printer_example/model/data_model.dart';
import 'package:thermal_printer_example/model/history_model.dart';
import 'package:thermal_printer_example/utils/database_helper.dart';
import 'package:thermal_printer_example/utils/print_templates.dart';

class CompatibilityController extends GetxController {
  @override
  void onInit() {
    fetchData();
    scanDevices(type: PrinterType.bluetooth);
    scanDevices(type: PrinterType.usb);

    super.onInit();
  }

  var userData = <DataModel>[].obs;

  var printerManager = PrinterManager.instance;

  var devices = <BluetoothPrinter>[].obs;

  StreamSubscription<PrinterDevice>? subscription;

  StreamSubscription<BTStatus>? subscriptionBtStatus;

  StreamSubscription<USBStatus>? subscriptionUsbStatus;

  var blStates = BlStates.granted.obs;

  var currentUsbStatus = USBStatus.none.obs;

  scanDevices({required PrinterType type}) async {
    subscription =
        printerManager.discovery(type: type, isBle: false).listen((device) {
      final res = devices.any(
        (e) => e.productId == device.productId,
      );

      if (!res) {
        devices.add(BluetoothPrinter(
          deviceName: device.name,
          address: device.address,
          isBle: false,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: type,
        ));
      }
    });
  }

  void printData({required BluetoothPrinter printer}) async {
    try {
      switch (printer.typePrinter) {
        case PrinterType.usb:
          await printerManager.connect(
              type: printer.typePrinter,
              model: UsbPrinterInput(
                  name: printer.deviceName,
                  productId: printer.productId,
                  vendorId: printer.vendorId));
          break;
        case PrinterType.bluetooth:
          await printerManager.connect(
              type: printer.typePrinter,
              model: BluetoothPrinterInput(
                name: printer.deviceName,
                address: printer.address!,
                isBle: printer.isBle ?? false,
              ));
          break;
        default:
      }

      var bytes = await Templates.template1(data: userData);

      final res =
          await printerManager.send(type: printer.typePrinter, bytes: bytes);

      if (res) {
        writeTableData(HistroyModel(
            name: DateTime.now(),
            printerName: printer.deviceName ?? "unknow printer"));
      }
    } catch (e) {
      log('printer error occured ---- $e');
    }
  }

  Future<void> fetchData() async {
    try {
      List<DataModel> data = DatabaseManager.instance.fetchData();
      userData.value = data;
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  writeData(DataModel data) {
    log('received on controller');
    userData.add(data);

    DatabaseManager.instance.insertData(data);
  }

  writeTableData(HistroyModel data) {
    DatabaseManager.instance.insertHistoryData(data);
  }
}

enum BlStates { granted, notGranded, denied }
