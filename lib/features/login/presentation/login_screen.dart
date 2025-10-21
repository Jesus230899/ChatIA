// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/routes/app_router.gr.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/core/validators/validators.dart';
import 'package:chatia/features/login/presentation/bloc/login_bloc.dart';
import 'package:chatia/features/widgets/custom_button_widget.dart';
import 'package:chatia/features/widgets/custom_textfield_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size size;
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _passwordCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginBloc bloc = getIt<LoginBloc>();

  @override
  void dispose() {
    _emailCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return _bodyBuilder();
  }

  Widget _bodyBuilder() {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (_, state) {},
        builder: (_, state) {
          log('Entra en el state');
          return Scaffold(body: _body());
        },
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _icon(),
                const SizedBox(height: 40),
                _messages(),
                const SizedBox(height: 20),
                _form(),
                const SizedBox(height: 30),
                CustomButtonWidget(
                  onPressed: () => _validate(context),
                  text: 'Iniciar sesión',
                ),
                const SizedBox(height: 30),
                _register(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(180),
      child: Image.asset(ResourceIcons.chatia, width: 180, height: 180),
    );
  }

  Widget _messages() {
    Align message(String text, double size) => Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
    return Column(
      children: [
        message('Iniciar sesión', 28),
        message("Por favor, inicia sesión para continuar.", 16),
      ],
    );
  }

  Widget _form() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [_emailTF(), const SizedBox(height: 24), _passwordTF()],
      ),
    );
  }

  Widget _emailTF() {
    return CustomTextFieldWidget(
      controller: _emailCtr,
      label: 'Correo electrónico',
      onChanged: (value) {},
      validator: (value) {
        return ValueValidator.email(value);
      },
      keyboardType: TextInputType.emailAddress,
      borderRadius: 20,
      borderColor: AppColors.primary,
    );
  }

  Widget _passwordTF() {
    // final password = bloc.state.password;
    log(bloc.state.showPassword.toString());
    return CustomTextFieldWidget(
      controller: _passwordCtr,
      label: 'Contraseña',
      obscureText: !bloc.state.showPassword,
      suffixIcon: _prefix(
        bloc.state.showPassword ? Icons.visibility_off_sharp : Icons.visibility,
        () => bloc.add(ChangeShowPasswordEvent()),
      ),
      borderRadius: 20,
      borderColor: AppColors.primary,
    );
  }

  Widget _prefix(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(80),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }

  void _validate(BuildContext context) {
    FocusScope.of(context).unfocus();

    bool isValid = true;
    if (_emailCtr.text.isEmpty || _passwordCtr.text.isEmpty) {
      isValid = false;
    }

    setState(() {});

    if (isValid) {
      if (_formKey.currentState!.validate()) {
        // mandar a llamar evento para login
      }
    }
  }

  Widget _register() {
    return RichText(
      text: TextSpan(
        text: '¿No tienes una cuenta? ',
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: 'Regístrate',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AutoRouter.of(context).push(RegisterRoute());
              },
          ),
        ],
      ),
    );
  }
}
