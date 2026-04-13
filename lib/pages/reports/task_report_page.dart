import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/models/task_list_item.dart';
import 'package:task_scheduler/repositories/client_repository.dart';
import 'package:task_scheduler/repositories/task_repository.dart';
import 'package:task_scheduler/services/task_report_pdf_service.dart';
import 'package:task_scheduler/widgets/app_scaffold.dart';

class TaskReportPage extends StatefulWidget {
  const TaskReportPage({super.key});

  @override
  State<TaskReportPage> createState() => _TaskReportPageState();
}

class _TaskReportPageState extends State<TaskReportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClientRepository _clientRepository = ClientRepository();
  final TaskRepository _taskRepository = TaskRepository();

  List<Client> _clients = <Client>[];

  int? _selectedClientId;
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = true;
  bool _isGenerating = false;

  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _loadClients();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    final List<Client> clients = await _clientRepository.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _clients = clients;
      _isLoading = false;
      if (clients.isNotEmpty) {
        _selectedClientId = clients.first.id;
      }
    });
  }

  Future<void> _pickStartDate() async {
    final DateTime initialDate = _startDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _startDate = picked;
      _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }

  Future<void> _pickEndDate() async {
    final DateTime initialDate = _endDate ?? _startDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _endDate = picked;
      _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }

  Future<void> _generateReport() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_selectedClientId == null || _startDate == null || _endDate == null) {
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A data final não pode ser menor que a data inicial.'),
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    final Client selectedClient = _clients.firstWhere(
          (Client client) => client.id == _selectedClientId,
    );

    final List<TaskListItem> tasks = await _taskRepository.getTasksForReport(
      clientId: _selectedClientId!,
      startDate: _startDate!,
      endDate: _endDate!,
    );

    if (!mounted) {
      return;
    }

    if (tasks.isEmpty) {
      setState(() {
        _isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma tarefa encontrada para o período informado.'),
        ),
      );
      return;
    }

    await TaskReportPdfService.generateAndOpen(
      clientName: selectedClient.name,
      startDate: _startDate!,
      endDate: _endDate!,
      tasks: tasks,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Rel. de tarefas',
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _clients.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Cadastre ao menos um cliente para gerar relatórios.',
              textAlign: TextAlign.center,
            ),
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rel. de tarefas',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecione o cliente e o período para gerar o PDF.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField<int>(
                          initialValue: _selectedClientId,
                          decoration: const InputDecoration(
                            labelText: 'Cliente *',
                          ),
                          items: _clients
                              .map(
                                (Client client) =>
                                DropdownMenuItem<int>(
                                  value: client.id,
                                  child: Text(client.name),
                                ),
                          )
                              .toList(),
                          onChanged: (int? value) {
                            if (value == null) {
                              return;
                            }

                            setState(() {
                              _selectedClientId = value;
                            });
                          },
                          validator: (int? value) {
                            if (value == null) {
                              return 'Selecione um cliente.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _startDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Data inicial *',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _pickStartDate,
                          validator: (String? value) {
                            if ((value ?? '').trim().isEmpty) {
                              return 'Informe a data inicial.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _endDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Data final *',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _pickEndDate,
                          validator: (String? value) {
                            if ((value ?? '').trim().isEmpty) {
                              return 'Informe a data final.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed:
                            _isGenerating ? null : _generateReport,
                            icon: const Icon(
                              Icons.picture_as_pdf_outlined,
                            ),
                            label: Text(
                              _isGenerating
                                  ? 'Gerando...'
                                  : 'Gerar PDF',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}