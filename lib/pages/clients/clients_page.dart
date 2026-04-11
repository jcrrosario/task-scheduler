import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_scheduler/core/constants/app_colors.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/repositories/client_repository.dart';
import 'package:task_scheduler/widgets/app_scaffold.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final ClientRepository _repository = ClientRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Client> _clients = <Client>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();

    super.dispose();
  }

  Future<void> _loadClients() async {
    setState(() {
      _isLoading = true;
    });

    final List<Client> data = await _repository.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _clients = data;
      _isLoading = false;
    });
  }

  Future<void> _onSearchChanged() async {
    final List<Client> data = await _repository.search(_searchController.text);

    if (!mounted) {
      return;
    }

    setState(() {
      _clients = data;
    });
  }

  Future<void> _openForm({Client? client}) async {
    final bool? saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _ClientFormSheet(client: client);
      },
    );

    if (saved == true) {
      await _loadClients();
    }
  }

  Future<void> _deleteClient(Client client) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir cliente'),
          content: Text(
            'Deseja realmente excluir "${client.name}"?',
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

    await _repository.delete(client.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cliente excluído com sucesso.'),
      ),
    );

    await _loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Clientes / Projetos',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _ClientsHeader(
                totalClients: _clients.length,
                onAddPressed: () => _openForm(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar por nome ou CNPJ...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _clients.isEmpty
                    ? const _EmptyClientsState()
                    : ListView.separated(
                  itemCount: _clients.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final Client client = _clients[index];

                    return _ClientCard(
                      client: client,
                      onEdit: () => _openForm(client: client),
                      onDelete: () => _deleteClient(client),
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

class _ClientsHeader extends StatelessWidget {
  const _ClientsHeader({
    required this.totalClients,
    required this.onAddPressed,
  });

  final int totalClients;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Clientes / Projetos',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$totalClients cadastrados',
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
            label: const Text('Novo Cliente'),
          ),
        ),
      ],
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  final Client client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    client.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if ((client.phone ?? '').isNotEmpty)
                    Text(
                      'Tel: ${client.phone}',
                      style: textTheme.bodyMedium,
                    ),
                  if ((client.cnpj ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'CNPJ: ${client.cnpj}',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  if ((client.email ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        client.email!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Valor da hora: ${currencyFormat.format(client.hourlyRate)}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}

class _EmptyClientsState extends StatelessWidget {
  const _EmptyClientsState();

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
              Icons.people_outline,
              size: 56,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum cliente cadastrado',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Clique em "Novo Cliente" para começar.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientFormSheet extends StatefulWidget {
  const _ClientFormSheet({this.client});

  final Client? client;

  @override
  State<_ClientFormSheet> createState() => _ClientFormSheetState();
}

class _ClientFormSheetState extends State<_ClientFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClientRepository _repository = ClientRepository();

  late final TextEditingController _nameController;
  late final TextEditingController _cnpjController;
  late final TextEditingController _phoneController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _hourlyRateController;

  bool _isSaving = false;

  bool get _isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _cnpjController = TextEditingController(text: widget.client?.cnpj ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _contactController =
        TextEditingController(text: widget.client?.contact ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _hourlyRateController = TextEditingController(
      text: (widget.client?.hourlyRate ?? 0).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnpjController.dispose();
    _phoneController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _hourlyRateController.dispose();
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

    final double hourlyRate = double.tryParse(
      _hourlyRateController.text.replaceAll(',', '.').trim(),
    ) ??
        0;

    if (_isEditing) {
      await _repository.update(
        id: widget.client!.id,
        name: _nameController.text,
        cnpj: _cnpjController.text,
        phone: _phoneController.text,
        contact: _contactController.text,
        email: _emailController.text,
        hourlyRate: hourlyRate,
      );
    } else {
      await _repository.create(
        name: _nameController.text,
        cnpj: _cnpjController.text,
        phone: _phoneController.text,
        contact: _contactController.text,
        email: _emailController.text,
        hourlyRate: hourlyRate,
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
                          _isEditing ? 'Editar Cliente' : 'Novo Cliente',
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
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome *',
                      hintText: 'Digite o nome',
                    ),
                    validator: (String? value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Informe o nome do cliente.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cnpjController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'CNPJ',
                      hintText: 'Digite o CNPJ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      hintText: 'Digite o telefone',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Contato',
                      hintText: 'Digite o contato',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'Digite o e-mail',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hourlyRateController,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor da hora',
                      hintText: 'Digite o valor da hora',
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