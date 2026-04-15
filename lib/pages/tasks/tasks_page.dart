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
  bool _showFilters = false;
  bool _showSearch = false;

  int? _selectedClientId;
  String? _selectedStatus;

  bool get _canReorder {
    return _searchController.text.trim().isEmpty && _selectedStatus == null;
  }

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
    final List<TaskListItem> repositoryTasks = await _taskRepository.getAll(
      search: _searchController.text,
      clientId: _selectedClientId,
      status: _selectedStatus == 'Abertos' ? null : _selectedStatus,
    );

    final List<TaskListItem> visibleTasks = _selectedStatus == null
        ? repositoryTasks.where((TaskListItem item) {
      final String normalizedStatus =
      item.task.status.trim().toLowerCase();

      return normalizedStatus == 'pendente' ||
          normalizedStatus == 'em andamento';
    }).toList()
        : _selectedStatus == 'Abertos'
        ? repositoryTasks.where((TaskListItem item) {
      final String normalizedStatus =
      item.task.status.trim().toLowerCase();

      return normalizedStatus == 'pendente' ||
          normalizedStatus == 'em andamento';
    }).toList()
        : repositoryTasks;

    if (!mounted) {
      return;
    }

    setState(() {
      _clients = clients;
      _tasks = visibleTasks;
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

  Future<void> _openConcludePage(TaskListItem item) async {
    final bool? updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => TaskExecutionPage(taskItem: item),
      ),
    );

    if (updated == true) {
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

  Future<void> _clearFilters() async {
    setState(() {
      _selectedClientId = null;
      _selectedStatus = null;
    });

    await _loadData();
  }

  void _toggleSearch() {
    final bool nextValue = !_showSearch;

    setState(() {
      _showSearch = nextValue;
    });

    if (!nextValue && _searchController.text.isNotEmpty) {
      _searchController.clear();
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (!_canReorder) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final List<TaskListItem> reorderedList = List<TaskListItem>.from(_tasks);
    final TaskListItem movedItem = reorderedList.removeAt(oldIndex);
    reorderedList.insert(newIndex, movedItem);

    setState(() {
      _tasks = reorderedList;
    });

    await _taskRepository.updatePriorityOrder(
      orderedVisibleTaskIds: reorderedList
          .map((TaskListItem item) => item.task.id)
          .toList(),
      clientId: _selectedClientId,
    );

    await _loadData();
  }

  bool get _hasActiveFilters {
    return _selectedClientId != null || _selectedStatus != null;
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
              _TasksHeader(totalTasks: _tasks.length),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  _HeaderIconButton(
                    tooltip: 'Nova tarefa',
                    icon: Icons.add,
                    onPressed: () => _openForm(),
                    isFilled: true,
                  ),
                  const SizedBox(width: 8),
                  _HeaderIconButton(
                    tooltip: _showSearch ? 'Ocultar pesquisa' : 'Pesquisar',
                    icon: _showSearch
                        ? Icons.search_off_outlined
                        : Icons.search_outlined,
                    onPressed: _toggleSearch,
                  ),
                  const SizedBox(width: 8),
                  _HeaderIconButton(
                    tooltip: _showFilters ? 'Ocultar filtros' : 'Filtros',
                    icon: _showFilters
                        ? Icons.filter_alt_off_outlined
                        : Icons.filter_alt_outlined,
                    onPressed: () {
                      setState(() {
                        _showFilters = !_showFilters;
                      });
                    },
                  ),
                ],
              ),
              if (_showSearch) ...<Widget>[
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por título, cliente, solicitante...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ],
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: <Widget>[
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
                            value: 'Abertos',
                            child: Text('Abertos'),
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
                      if (_hasActiveFilters) ...<Widget>[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: _clearFilters,
                            child: const Text('Limpar filtros'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                crossFadeState: _showFilters
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
              ),
              if (_canReorder) ...<Widget>[
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.drag_indicator,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _selectedClientId == null
                            ? 'Pressione e arraste os cards para definir a prioridade.'
                            : 'Pressione e arraste os cards para definir a prioridade deste cliente.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _tasks.isEmpty
                    ? const _EmptyTasksState()
                    : _canReorder
                    ? ReorderableListView.builder(
                  buildDefaultDragHandles: true,
                  itemCount: _tasks.length,
                  onReorder: _onReorder,
                  proxyDecorator: (
                      Widget child,
                      int index,
                      Animation<double> animation,
                      ) {
                    return Material(
                      color: Colors.transparent,
                      child: child,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final TaskListItem item = _tasks[index];

                    return Padding(
                      key: ValueKey<int>(item.task.id),
                      padding: EdgeInsets.only(
                        bottom:
                        index == _tasks.length - 1 ? 0 : 12,
                      ),
                      child: _TaskCard(
                        item: item,
                        onEdit: () => _openForm(item: item),
                        onDelete: () => _deleteTask(item),
                        onConclude: () =>
                            _openConcludePage(item),
                      ),
                    );
                  },
                )
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
                      onConclude: () =>
                          _openConcludePage(item),
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
  });

  final int totalTasks;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Tarefas - $totalTasks cadastradas',
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isFilled = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 52,
        height: 52,
        child: isFilled
            ? FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Icon(icon, size: 22),
        )
            : OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide(color: colorScheme.outlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onConclude,
  });

  final TaskListItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onConclude;

  Color _getCardBackgroundColor() {
    final String status = item.task.status.trim().toLowerCase();

    if (status == 'pendente') {
      return const Color(0xFFFFF4E5);
    }

    if (status == 'em andamento') {
      return const Color(0xFFEAF7EE);
    }

    if (status == 'concluído') {
      return const Color(0xFFEEEAFE);
    }

    return Colors.white;
  }

  Color _getStatusColor() {
    final String status = item.task.status.trim().toLowerCase();

    if (status == 'pendente') {
      return const Color(0xFFE65100);
    }

    if (status == 'em andamento') {
      return const Color(0xFF1B5E20);
    }

    if (status == 'concluído') {
      return const Color(0xFF4A148C);
    }

    return AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color cardBackgroundColor = _getCardBackgroundColor();
    final Color statusColor = _getStatusColor();

    return Container(
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withAlpha(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.task.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data/Hora: ${dateFormat.format(item.task.date)} às ${item.task.time}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(170),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.task.status,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Editar',
                  child: IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                Tooltip(
                  message: 'Concluir',
                  child: IconButton(
                    onPressed: onConclude,
                    icon: const Icon(Icons.check_circle_outline),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                Tooltip(
                  message: 'Excluir',
                  child: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
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
              'Clique em "Nova tarefa" para começar.',
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

  late DateTime _selectedDate;
  late String _selectedTime;
  late int _selectedClientId;

  bool _isSaving = false;

  bool get _isEditing => widget.taskItem != null;

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();
    final Task? task = widget.taskItem?.task;

    _selectedDate = task?.date ?? now;
    _selectedTime = task?.time ??
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _selectedClientId = task?.clientId ?? widget.clients.first.id;

    _titleController = TextEditingController(text: task?.title ?? '');
    _requesterController = TextEditingController(text: task?.requester ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _requesterController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    if (_isEditing) {
      await _repository.update(
        id: widget.taskItem!.task.id,
        clientId: _selectedClientId,
        title: _titleController.text,
        date: _selectedDate,
        time: _selectedTime,
        requester: _requesterController.text,
        description: _descriptionController.text,
        doneDescription: widget.taskItem!.task.doneDescription,
        hours: widget.taskItem!.task.hours,
        status: widget.taskItem!.task.status,
      );
    } else {
      await _repository.create(
        clientId: _selectedClientId,
        title: _titleController.text,
        date: _selectedDate,
        time: _selectedTime,
        requester: _requesterController.text,
        description: _descriptionController.text,
        doneDescription: null,
        hours: 0,
        status: 'Pendente',
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
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dados da tarefa',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Preencha as informações principais da tarefa.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
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
                        ],
                      ),
                    ),
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
                      onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(false),
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

class TaskExecutionPage extends StatefulWidget {
  const TaskExecutionPage({
    required this.taskItem,
    super.key,
  });

  final TaskListItem taskItem;

  @override
  State<TaskExecutionPage> createState() => _TaskExecutionPageState();
}

class _TaskExecutionPageState extends State<TaskExecutionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TaskRepository _repository = TaskRepository();

  late final TextEditingController _doneDescriptionController;
  late final TextEditingController _hoursController;

  late String _selectedStatus;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final Task task = widget.taskItem.task;

    _doneDescriptionController = TextEditingController(
      text: task.doneDescription ?? '',
    );

    _hoursController = TextEditingController(
      text: task.hours > 0 ? task.hours.toStringAsFixed(2) : '',
    );

    _selectedStatus = task.status;
  }

  @override
  void dispose() {
    _doneDescriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _saveExecution() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final Task task = widget.taskItem.task;

    final double hours = double.tryParse(
      _hoursController.text.replaceAll(',', '.').trim(),
    ) ??
        0;

    await _repository.update(
      id: task.id,
      clientId: task.clientId,
      title: task.title,
      date: task.date,
      time: task.time,
      requester: task.requester,
      description: task.description,
      doneDescription: _doneDescriptionController.text,
      hours: hours,
      status: _selectedStatus,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Execução da tarefa atualizada com sucesso.'),
      ),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final Task task = widget.taskItem.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Concluir tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          task.title,
                          style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cliente: ${widget.taskItem.clientName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Preencha os dados de execução da tarefa.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _doneDescriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'O que foi feito',
                            hintText: 'Descreva o que foi realizado',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hoursController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Horas trabalhadas',
                            hintText: 'Digite as horas trabalhadas',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status *',
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _saveExecution,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed:
                    _isSaving ? null : () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
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