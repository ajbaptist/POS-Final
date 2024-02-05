import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:thermal_printer_example/controllers/compatibility_controller.dart';

class Compatibility extends StatefulWidget {
  const Compatibility({super.key});

  @override
  State<Compatibility> createState() => _CompatibilityState();
}

class _CompatibilityState extends State<Compatibility> {
  var controller = Get.put(CompatibilityController());

  @override
  void initState() {
    //  PrinterManager.instance.stateUSB is only supports on Android
    controller.subscriptionUsbStatus =
        PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      controller.currentUsbStatus.value = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected) {
          controller.scanDevices();
        } else if (status == USBStatus.none) {
          controller.devices.clear();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.subscription?.cancel();

    controller.subscriptionUsbStatus?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Lottie.asset('assets/printer.json',
                    alignment: Alignment.center)),
            const SizedBox(),
            if (controller.devices.isEmpty) ...{
              Transform.scale(
                  scale: 0.5, child: const CircularProgressIndicator()),
              const SizedBox(),
              const Text(
                'Printer Initialization',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            } else ...{
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  color: Colors.black45,
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                    ),
                    title: Text(
                      controller.devices.first.deviceName ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Text(
                      'Product ID: ${controller.devices.first.productId}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    trailing: IconButton.filled(
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.white),
                      icon: const Icon(
                        Icons.print_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        controller.printData();
                      },
                    ),
                  ),
                ),
              )
            }
          ],
        ),
      );
    });
  }
}
