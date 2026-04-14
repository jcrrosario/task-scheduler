import 'package:flutter/material.dart';
import 'package:task_scheduler/core/constants/app_colors.dart';
import 'package:task_scheduler/core/constants/app_strings.dart';
import 'package:task_scheduler/pages/tasks/tasks_page.dart';
import 'package:task_scheduler/services/auth_service.dart';
import 'package:task_scheduler/services/biometric_auth_service.dart';
import 'package:task_scheduler/widgets/app_primary_button.dart';
import 'package:task_scheduler/widgets/app_text_field.dart';

/// Tela de Login do sistema.
/// Responsável por autenticar o usuário e redirecionar para a aplicação.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Chave do formulário.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Serviços.
  final AuthService _authService = AuthService();
  final BiometricAuthService _biometricAuthService = BiometricAuthService();

  /// Controllers.
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  /// Controle de UI.
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  bool _hasTriedAutoBiometric = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(
      text: AppStrings.defaultUsername,
    );
    _passwordController = TextEditingController();

    _initializeBiometricState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initializeBiometricState() async {
    final bool isBiometricAvailable =
    await _biometricAuthService.isBiometricAvailable();
    final bool isBiometricEnabled = isBiometricAvailable
        ? await _biometricAuthService.isBiometricEnabled()
        : false;

    if (!mounted) {
      return;
    }

    setState(() {
      _isBiometricAvailable = isBiometricAvailable;
      _isBiometricEnabled = isBiometricEnabled;
    });

    if (_isBiometricAvailable &&
        _isBiometricEnabled &&
        !_hasTriedAutoBiometric) {
      _hasTriedAutoBiometric = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loginWithBiometrics(
          silentOnCancel: true,
        );
      });
    }
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String password = _passwordController.text.trim().isEmpty
        ? AppStrings.defaultPassword
        : _passwordController.text.trim();

    final bool authenticated = await _authService.validateLogin(
      username: _usernameController.text.trim(),
      password: password,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (!authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha inválidos.'),
        ),
      );
      return;
    }

    await _offerBiometricActivation();

    if (!mounted) {
      return;
    }

    _goToTasksPage();
  }

  Future<void> _offerBiometricActivation() async {
    if (!_isBiometricAvailable) {
      return;
    }

    if (_isBiometricEnabled) {
      return;
    }

    final bool? shouldEnable = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ativar biometria'),
          content: const Text(
            'Deseja ativar a biometria para entrar no app mais rapidamente nas próximas vezes?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Agora não'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ativar'),
            ),
          ],
        );
      },
    );

    if (shouldEnable != true || !mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bool didAuthenticate = await _biometricAuthService.authenticate(
      reason: 'Confirme sua biometria para ativar o acesso rápido.',
    );

    if (!mounted) {
      return;
    }

    if (didAuthenticate) {
      await _biometricAuthService.enableBiometric();

      if (!mounted) {
        return;
      }

      setState(() {
        _isBiometricEnabled = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometria ativada com sucesso.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A biometria não foi ativada.'),
      ),
    );
  }

  Future<void> _loginWithBiometrics({
    bool silentOnCancel = false,
  }) async {
    if (_isLoading) {
      return;
    }

    if (!_isBiometricAvailable || !_isBiometricEnabled) {
      if (!silentOnCancel && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometria não disponível neste dispositivo.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bool didAuthenticate = await _biometricAuthService.authenticate(
      reason: 'Use sua biometria para acessar o Task Scheduler.',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (!didAuthenticate) {
      if (!silentOnCancel) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticação biométrica não concluída.'),
          ),
        );
      }
      return;
    }

    _goToTasksPage();
  }

  void _goToTasksPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const TasksPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.loginBackgroundTop,
              AppColors.loginBackgroundBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  AppColors.primaryLight,
                                  AppColors.primaryDark,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppStrings.appName,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.appSubtitle,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.loginTitle,
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _usernameController,
                            hintText: AppStrings.defaultUsername,
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.passwordTitle,
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _passwordController,
                            hintText: AppStrings.passwordHint,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            validator: (String? value) {
                              return null;
                            },
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
                          const SizedBox(height: 24),
                          AppPrimaryButton(
                            label: _isLoading
                                ? 'Entrando...'
                                : AppStrings.loginButton,
                            icon: Icons.lock_outline_rounded,
                            onPressed: _isLoading ? null : _submit,
                          ),
                          if (_isBiometricAvailable && _isBiometricEnabled) ...<Widget>[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : () => _loginWithBiometrics(),
                                icon: const Icon(Icons.fingerprint),
                                label: const Text('Entrar com biometria'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            '© 2026 Serenyo Tecnologia Ltda.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
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
      ),
    );
  }
}