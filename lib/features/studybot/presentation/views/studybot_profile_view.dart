import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/routes/app_router.gr.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/core/validators/validators.dart';
import 'package:chatia/features/studybot/presentation/alerts/studybot_alert.dart';
import 'package:chatia/features/studybot/presentation/bloc/study_form_bloc/study_form_bloc.dart';
import 'package:chatia/features/widgets/custom_button_widget.dart';
import 'package:chatia/features/widgets/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudybotProfileView extends StatefulWidget {
  final StudyFormBloc bloc;
  const StudybotProfileView({super.key, required this.bloc});

  @override
  State<StudybotProfileView> createState() => _StudybotProfileViewState();
}

class _StudybotProfileViewState extends State<StudybotProfileView> {
  final TextEditingController _fullNameCtr = TextEditingController();
  final TextEditingController _emailCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudyFormBloc, StudyFormState>(
      listener: (context, state) {
        state.userDataResult.fold(() {}, (either) {
          either.fold((l) {}, (r) {
            setState(() {
              final data = state.userData.fold(() => null, (r) => r);
              if (data == null) return;
              _fullNameCtr.text = data.fullName ?? '';
              _emailCtr.text = data.email;
            });
          });
        });
        state.saveUserDataResult.fold(() {}, (either) {
          either.fold((l) {}, (r) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cambios guardados correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          });
        });
        state.logOutResult.fold(() {}, (either) {
          either.fold((l) {}, (r) {
            AutoRouter.of(context).replaceAll([LoginRoute()]);
          });
        });
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Text(
                  'Mi perfil',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  'Aquí puedes ver y editar tu información personal.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 30),
                _form(),
                SizedBox(height: 80),
                _actions(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _form() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [_fullNameTF(), const SizedBox(height: 24), _emailTF()],
      ),
    );
  }

  Widget _fullNameTF() {
    return CustomTextFieldWidget(
      controller: _fullNameCtr,
      label: 'Nombre completo',
      onChanged: (value) {
        widget.bloc.add(ChangeFullNameEvent(value: value));
      },
      validator: (value) {
        return ValueValidator.fullName(value);
      },
      keyboardType: TextInputType.emailAddress,
      borderRadius: 20,
      borderColor: AppColors.primary,
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
      enabled: false,
      keyboardType: TextInputType.emailAddress,
      borderRadius: 20,
      borderColor: AppColors.primary,
    );
  }

  Widget _actions() {
    return Column(
      children: [
        CustomButtonWidget(
          onPressed: () => widget.bloc.add(SaveChangesUserDataEvent()),
          text: 'Guardar cambios',
        ),
        SizedBox(height: 40),
        CustomButtonWidget(
          onPressed: () async {
            final result = await StudybotAlert.showExitAlert(context: context);
            if (result == true) {
              widget.bloc.add(LogOutEvent());
            }
          },
          text: 'Cerrar sesión',
        ),
      ],
    );
  }
}
