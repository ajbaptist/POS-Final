import 'package:intl/intl.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';

class Templates {
  static Future<List<int>> template1() async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    // final profile = await CapabilityProfile.load(name: 'XP-N160I');

    CapabilityProfile profile = await CapabilityProfile.load();

    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);

    // bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text("Printer Task",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(
        "18th Main Road, Ganapathy Phase, J. P. Nagar, Coimbatore, TamilNadu 627001",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +919787108888',
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 1,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Test Item 1",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "10", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "2", width: 1),
      PosColumn(
          text: "Test Item 2",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "30",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "30", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "3", width: 1),
      PosColumn(
          text: "Test Item 3",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "50",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "50", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "4", width: 1),
      PosColumn(
          text: "Test Item 4",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "70",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "70", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: "160",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);

    bytes += generator.text(timestamp,
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('Note: Tested for Development Purpose Only.',
        styles: const PosStyles(align: PosAlign.center, bold: false));

    bytes += generator.feed(2);

    bytes += generator.cut();

    return bytes;
  }
}
