import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:thermal_printer_example/controllers/history_controller.dart';
import 'package:thermal_printer_example/utils/responsive.dart';

class PrintingHistory extends StatefulWidget {
  const PrintingHistory({super.key});

  @override
  State<PrintingHistory> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PrintingHistory> {
  //
  var controller = Get.put(PrintingHistoryController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Printing History'),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Date",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                  ),
                  Text(
                    "Printer Name",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 1.hp,
              ),
              if (controller.historyData.isEmpty) ...{
                SizedBox(
                  height: 20.hp,
                ),
                Text(
                  'No History Recorded',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                )
              } else ...{
                SingleChildScrollView(
                  child: Column(
                    children: controller.historyData
                        .map((element) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      element.name.toIso8601String(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      element.printerName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                )
              }
            ],
          ),
        );
      }),
    );
  }
}
