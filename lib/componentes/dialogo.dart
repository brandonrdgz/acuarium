import 'dart:ffi';

import 'package:flutter/material.dart';

typedef Funcion = dynamic Function(dynamic valor);

class Dialogo{
  static void dialogo(
    BuildContext context,
    {
      Widget? titulo,
      required Widget contenido,
      required List<Widget> acciones
    }
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
          ),
          title: titulo,
          content: contenido,
          actions: acciones,
        );
      }
    );
  }

  static Future<T?> dialogoProgreso<T>(
    BuildContext context,
    {
      Widget? titulo,
      required Widget contenido,
      required Future<dynamic> future,
      required Funcion alTerminar,
      required Funcion enError
    }
  ) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: titulo,
          content: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
              Expanded(child: contenido)
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
          ),
        );
      }
    );

    dynamic respuesta;

    await future.then(
      (value) {
        Navigator.pop(context);
        alTerminar.call(value);
        respuesta = value;
      }
    )
    .catchError(
      (e) {
        Navigator.pop(context);
        enError.call(e);
        respuesta = e;
      }
    );

    return respuesta;
  }
}