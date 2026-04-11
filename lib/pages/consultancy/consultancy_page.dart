import 'package:flutter/material.dart';
import 'package:task_scheduler/core/constants/app_strings.dart';
import 'package:task_scheduler/db/app_database.dart';
import 'package:task_scheduler/repositories/consultancy_repository.dart';
import 'package:task_scheduler/widgets/app_scaffold.dart';

class ConsultancyPage extends StatefulWidget {
  const ConsultancyPage({super.key});

  @override
  State<ConsultancyPage> createState() => _ConsultancyPageState();
}

class _ConsultancyPageState extends State<ConsultancyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ConsultancyRepository _repository = ConsultancyRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _stateRegistrationController =
  TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _accessPasswordController =
  TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadConsultancy();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cnpjController.dispose();
    _stateRegistrationController.dispose();
    _addressController.dispose();
    _hourlyRateController.dispose();
    _accessPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadConsultancy() async {
    final Consultancy? consultancy = await _repository.getConsultancy();

    if (consultancy != null) {
      _nameController.text = consultancy.name ?? '';
      _emailController.text = consultancy.email ?? '';
      _phoneController.text = consultancy.phone ?? '';
      _cnpjController.text = consultancy.cnpj ?? '';
      _stateRegistrationController.text = consultancy.stateRegistration ?? '';
      _addressController.text = consultancy.address ?? '';
      _hourlyRateController.text = consultancy.hourlyRate.toStringAsFixed(2);
      _accessPasswordController.text =
          consultancy.accessPassword ?? AppStrings.defaultPassword;
    } else {
      _accessPasswordController.text = AppStrings.defaultPassword;
      _hourlyRateController.text = '0.00';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
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

    final double hourlyRate = double.tryParse(
      _hourlyRateController.text.replaceAll(',', '.').trim(),
    ) ??
        0;

    final String password = _accessPasswordController.text.trim().isEmpty
        ? AppStrings.defaultPassword
        : _accessPasswordController.text.trim();

    await _repository.save(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      cnpj: _cnpjController.text,
      stateRegistration: _stateRegistrationController.text,
      address: _addressController.text,
      hourlyRate: hourlyRate,
      accessPassword: password,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Consultoria salva com sucesso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Consultoria',
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Cadastro da Consultoria',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Esta configuração terá apenas um registro e será usada como base do aplicativo.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome da Consultoria',
                            hintText: 'Digite o nome da consultoria',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'Digite o e-mail',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            hintText: 'Digite o telefone',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cnpjController,
                          decoration: const InputDecoration(
                            labelText: 'CNPJ',
                            hintText: 'Digite o CNPJ',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _stateRegistrationController,
                          decoration: const InputDecoration(
                            labelText: 'Inscrição Estadual',
                            hintText: 'Digite a inscrição estadual',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Endereço',
                            hintText: 'Digite o endereço',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hourlyRateController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Valor da Hora',
                            hintText: 'Digite o valor da hora',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _accessPasswordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha de acesso ao app',
                            hintText: 'Digite a senha',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isSaving ? null : _save,
                            child: Text(
                              _isSaving ? 'Salvando...' : 'Salvar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}