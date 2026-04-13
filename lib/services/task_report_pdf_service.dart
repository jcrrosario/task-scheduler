import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:task_scheduler/models/task_list_item.dart';

class TaskReportPdfService {
  TaskReportPdfService._();

  static Future<void> generateAndOpen({
    required String clientName,
    required DateTime startDate,
    required DateTime endDate,
    required List<TaskListItem> tasks,
  }) async {
    final pw.Document document = pw.Document();
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateFormat fileDateFormat = DateFormat('ddMMyyyy_HHmm');

    final double totalHours = tasks.fold<double>(
      0,
          (double previous, TaskListItem item) => previous + item.task.hours,
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              'Tarefas do cliente: $clientName',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Período: ${dateFormat.format(startDate)} até ${dateFormat.format(endDate)}',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headers: const <String>[
                'Data',
                'Título',
                'Solicitante',
                'Horas trabalhadas',
                'Status',
              ],
              data: tasks.map((TaskListItem item) {
                return <String>[
                  dateFormat.format(item.task.date),
                  item.task.title,
                  item.task.requester ?? '',
                  item.task.hours.toStringAsFixed(2),
                  item.task.status,
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Total de horas trabalhadas: ${totalHours.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ];
        },
      ),
    );

    final Uint8List bytes = await document.save();

    await Printing.layoutPdf(
      name:
      'relatorio_tarefas_${clientName}_${fileDateFormat.format(DateTime.now())}.pdf',
      onLayout: (PdfPageFormat format) async => bytes,
    );
  }
}