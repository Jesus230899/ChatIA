import 'package:chatia/features/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class StudybotAlert {
  static Future<bool?> showExitAlert({required BuildContext context}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas cerrar sesión?'),
              const SizedBox(height: 20),
              Text(
                'Los chats serán eliminados del dispositivo por que solo se guardan localmente y persisten mientras la sesión esté activa.',
              ),
            ],
          ),
          actions: [
            CustomButtonWidget(
              text: 'Aceptar',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 20),
            CustomButtonWidget(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );
  }
}
