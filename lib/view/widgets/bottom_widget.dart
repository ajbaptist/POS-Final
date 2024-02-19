import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thermal_printer_example/model/data_model.dart';

Future<DataModel?> showBottomSheetWidget(BuildContext context) async {
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
                    keyboardType: TextInputType.name,
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
