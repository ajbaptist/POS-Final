import 'dart:async';

import 'package:get/state_manager.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:thermal_printer_example/main.dart';
import 'package:thermal_printer_example/utils/print_templates.dart';

class CompatibilityController extends GetxController {
  @override
  void onInit() {
    scanDevices();
    super.onInit();
  }

  var type = PrinterType.usb;

  var printerManager = PrinterManager.instance;

  var devices = <BluetoothPrinter>[].obs;

  StreamSubscription<PrinterDevice>? subscription;

  StreamSubscription<USBStatus>? subscriptionUsbStatus;

  var printerStates = PrinterStates.initial.obs;

  BluetoothPrinter get printDevice => devices.first;

  var currentUsbStatus = USBStatus.none.obs;

  scanDevices() async {
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

  printData() async {
    switch (printDevice.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: printDevice.typePrinter,
            model: UsbPrinterInput(
                name: printDevice.deviceName,
                productId: printDevice.productId,
                vendorId: printDevice.vendorId));

        break;
      default:
    }

    var bytes = await Templates.template1();

    printerManager.send(type: type, bytes: bytes);
  }
}

enum PrinterStates { initial, eligilbe, notEligible, granted, notGranded }
