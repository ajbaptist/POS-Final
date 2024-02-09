import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:thermal_printer_example/controllers/compatibility_controller.dart';
import 'package:thermal_printer_example/model/data_model.dart';
import 'package:thermal_printer_example/utils/responsive.dart';
import 'package:thermal_printer_example/view/history/printing_history.dart';

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
          controller.scanDevices(type: PrinterType.usb);
        } else if (status == USBStatus.none) {
          controller.devices.clear();
        }
      }
    });

    // subscription to listen change status of bluetooth connection
    controller.subscriptionBtStatus =
        PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');

      if (status == BTStatus.connected) {
        controller.scanDevices(type: PrinterType.bluetooth);
      } else if (status == BTStatus.none) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.subscription?.cancel();

    controller.subscriptionUsbStatus?.cancel();

    controller.subscriptionBtStatus?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton.filled(
              onPressed: () {
                Get.to(const PrintingHistory());
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
            ),
            IconButton.filled(
              onPressed: () {
                if (controller.userData.isNotEmpty) {
                  for (var element in controller.userData) {
                    if (kDebugMode) {
                      print('data from list ${element.toJson()}');
                    }
                  }
                }
              },
              icon: Text(
                controller.userData.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final value = await showBottomSheet(context);

            if (value != null) {
              log('received on button');
              controller.writeData(value);
            }

            log('received on $value');
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15.hp,
              ),
              Center(
                  child: Lottie.asset('assets/printer.json',
                      frameRate: FrameRate.composition,
                      alignment: Alignment.center)),
              const SizedBox(),
              if (controller.devices.isEmpty) ...{
                Transform.scale(
                    scale: 0.5, child: const CircularProgressIndicator()),
                const SizedBox(),
                const Text(
                  'Printer Initialization',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              } else ...{
                Column(
                  children: controller.devices
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            color: Colors.black45,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 15.sp,
                                backgroundColor: Colors.white,
                                child: (e.productId != null)
                                    ? const Icon(
                                        Icons.usb,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.bluetooth),
                              ),
                              title: Text(
                                e.deviceName ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                'Product ID: ${e.productId ?? e.address}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              trailing: IconButton.filled(
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.white),
                                icon: const Icon(
                                  Icons.print_rounded,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  if (controller.userData.isNotEmpty) {
                                    controller.printData(printer: e);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                          'Printer Data Not Available. Kindly Add Some Data And Check Back Again'),
                                    ));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              }
            ],
          ),
        ),
      );
    });
  }
}

Future<DataModel?> showBottomSheet(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final date = TextEditingController();
  final month = TextEditingController();
  final year = TextEditingController();

  final res = await showModalBottomSheet<DataModel?>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              // Wrap the entire content with a Form widget
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: date,
                    inputFormatters: <TextInputFormatter>[
                      // for below version 2 use this
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(2),
// for version 2 and greater youcan also use this
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(labelText: 'Date'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: month,
                    inputFormatters: <TextInputFormatter>[
                      // for below version 2 use this
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(2),
// for version 2 and greater youcan also use this
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Month'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a month';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: year,
                    inputFormatters: <TextInputFormatter>[
                      // for below version 2 use this
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(4),
// for version 2 and greater youcan also use this
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'year'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onPressed: () {
                      // Validate the entire form
                      if (formKey.currentState!.validate()) {
                        final datamodel = DataModel(
                            name: name.text.trim(),
                            year: int.parse(year.text.trim()),
                            date: int.parse(date.text.trim()),
                            month: int.parse(month.text.trim()));
                        // Handle submit button logic here
                        return Navigator.pop(
                            context, datamodel); // Close the bottom sheet
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    // This function is called when the bottom sheet is dismissed
    // Unfocus any currently focused text field to hide the keyboard
    FocusScope.of(context).unfocus();

    return value;
  });

  return res;
}
