import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_scheduler/core/constants/app_colors.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/models/task_list_item.dart';
import 'package:task_scheduler/repositories/client_repository.dart';
import 'package:task_scheduler/repositories/task_repository.dart';
import 'package:task_scheduler/widgets/app_scaffold.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskRepository _taskRepository = TaskRepository();
  final ClientRepository _clientRepository = ClientRepository();
  final TextEditingController _searchController = TextEditingController();

  List<TaskListItem> _tasks = <TaskListItem>[];
  List<Client> _clients = <Client>[];

  bool _isLoading = true;
  int? _selectedClientId;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_loadData);
    _loadData();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_loadData)
      ..dispose();

    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final List<Client> clients = await _clientRepository.getAll();
    final List<TaskListItem> tasks = await _taskRepository.getAll(
      search: _searchController.text,
      clientId: _selectedClientId,
      status: _selectedStatus,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _clients = clients;
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _openForm({TaskListItem? item}) async {
    if (_clients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cadastre ao menos um cliente antes de criar tarefas.',
          ),
        ),
      );
      return;
    }

    final bool? saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TaskFormSheet(
          taskItem: item,
          clients: _clients,
        );
      },
    );

    if (saved == true) {
      await _loadData();
    }
  }

  Future<void> _deleteTask(TaskListItem item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir tarefa'),
          content: Text(
            'Deseja realmente excluir "${item.task.title}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _taskRepository.delete(item.task.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa excluída com sucesso.'),
      ),
    );

    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tarefas',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _TasksHeader(
                totalTasks: _tasks.length,
                onAddPressed: () => _openForm(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar por título, cliente, solicitante...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                initialValue: _selectedClientId,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                ),
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  ..._clients.map(
                        (Client client) => DropdownMenuItem<int?>(
                      value: client.id,
                      child: Text(client.name),
                    ),
                  ),
                ],
                onChanged: (int? value) async {
                  setState(() {
                    _selectedClientId = value;
                  });
                  await _loadData();
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: const <DropdownMenuItem<String?>>[
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'Pendente',
                    child: Text('Pendente'),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'Em andamento',
                    child: Text('Em andamento'),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'Concluído',
                    child: Text('Concluído'),
                  ),
                ],
                onChanged: (String? value) async {
                  setState(() {
                    _selectedStatus = value;
                  });
                  await _loadData();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _tasks.isEmpty
                    ? const _EmptyTasksState()
                    : ListView.separated(
                  itemCount: _tasks.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final TaskListItem item = _tasks[index];

                    return _TaskCard(
                      item: item,
                      onEdit: () => _openForm(item: item),
                      onDelete: () => _deleteTask(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TasksHeader extends StatelessWidget {
  const _TasksHeader({
    required this.totalTasks,
    required this.onAddPressed,
  });

  final int totalTasks;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tarefas',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$totalTasks cadastradas',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 170,
          child: FilledButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            label: const Text('Nova Tarefa'),
          ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskListItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.task.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Editar',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  tooltip: 'Excluir',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Cliente/Projeto: ${item.clientName}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Data/Hora: ${dateFormat.format(item.task.date)} às ${item.task.time}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Solicitante: ${(item.task.requester ?? '').isEmpty ? '-' : item.task.requester}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${item.task.status}',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Horas gastas: ${item.task.hours.toStringAsFixed(2)}',
              style: textTheme.bodyMedium,
            ),
            if ((item.task.description ?? '').isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                item.task.description!,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyTasksState extends StatelessWidget {
  const _EmptyTasksState();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.list_alt_outlined,
              size: 56,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma tarefa cadastrada',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Clique em "Nova Tarefa" para começar.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskFormSheet extends StatefulWidget {
  const TaskFormSheet({
    required this.clients,
    this.taskItem,
    super.key,
  });

  final List<Client> clients;
  final TaskListItem? taskItem;

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TaskRepository _repository = TaskRepository();

  late final TextEditingController _titleController;
  late final TextEditingController _requesterController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _doneDescriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _hoursController;

  late DateTime _selectedDate;
  late String _selectedTime;
  late int _selectedClientId;
  late String _selectedStatus;

  bool _isSaving = false;

  bool get _isEditing => widget.taskItem != null;

  @override
  void initState() {
    super.initState();

    final Task? task = widget.taskItem?.task;
    _selectedDate = task?.date ?? DateTime.now();
    _selectedTime = task?.time ?? '08:00';
    _selectedClientId = task?.clientId ?? widget.clients.first.id;
    _selectedStatus = task?.status ?? 'Pendente';

    _titleController = TextEditingController(text: task?.title ?? '');
    _requesterController = TextEditingController(text: task?.requester ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
    _doneDescriptionController =
        TextEditingController(text: task?.doneDescription ?? '');
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_selectedDate),
    );
    _timeController = TextEditingController(text: _selectedTime);
    _hoursController = TextEditingController(
      text: (task?.hours ?? 0).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _requesterController.dispose();
    _descriptionController.dispose();
    _doneDescriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = picked;
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }

  Future<void> _pickTime() async {
    final List<String> parts = _selectedTime.split(':');
    final TimeOfDay initialTime = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 8,
      minute: int.tryParse(parts.last) ?? 0,
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked == null) {
      return;
    }

    final String formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    setState(() {
      _selectedTime = formatted;
      _timeController.text = formatted;
    });
  }

  Future<void> _save() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final double hours = double.tryParse(
      _hoursController.text.replaceAll(',', '.').trim(),
    ) ??
        0;

    if (_isEditing) {
      await _repository.update(
        id: widget.taskItem!.task.id,
        clientId: _selectedClientId,
        title: _titleController.text,
        date: _selectedDate,
        time: _selectedTime,
        requester: _requesterController.text,
        description: _descriptionController.text,
        doneDescription: _doneDescriptionController.text,
        hours: hours,
        status: _selectedStatus,
      );
    } else {
      await _repository.create(
        clientId: _selectedClientId,
        title: _titleController.text,
        date: _selectedDate,
        time: _selectedTime,
        requester: _requesterController.text,
        description: _descriptionController.text,
        doneDescription: _doneDescriptionController.text,
        hours: hours,
        status: _selectedStatus,
      );
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _isEditing ? 'Editar Tarefa' : 'Nova Tarefa',
                          style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título *',
                      hintText: 'Digite o título da tarefa',
                    ),
                    validator: (String? value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Informe o título da tarefa.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedClientId,
                    decoration: const InputDecoration(
                      labelText: 'Cliente/Projeto *',
                    ),
                    items: widget.clients
                        .map(
                          (Client client) => DropdownMenuItem<int>(
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
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Data *',
                            hintText: 'Selecione a data',
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          onTap: _pickDate,
                          validator: (String? value) {
                            if ((value ?? '').trim().isEmpty) {
                              return 'Informe a data.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Hora *',
                            hintText: 'Selecione a hora',
                            suffixIcon: Icon(Icons.access_time_outlined),
                          ),
                          onTap: _pickTime,
                          validator: (String? value) {
                            if ((value ?? '').trim().isEmpty) {
                              return 'Informe a hora.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _requesterController,
                    decoration: const InputDecoration(
                      labelText: 'Solicitante',
                      hintText: 'Digite o solicitante',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descrição completa',
                      hintText: 'Descreva a tarefa',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _doneDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'O que foi feito',
                      hintText: 'Descreva o que foi feito',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hoursController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Horas gastas',
                      hintText: 'Digite as horas gastas',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: 'Pendente',
                        child: Text('Pendente'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Em andamento',
                        child: Text('Em andamento'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Concluído',
                        child: Text('Concluído'),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSaving ? null : _save,
                      child: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}