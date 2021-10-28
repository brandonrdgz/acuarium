import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InformacionPedidoClientePantalla extends StatelessWidget {
static const String id = 'InformacionPedidoClientePantalla';
final List<Fila> filas = [
    Fila(celdas: <String>['Especie 1', '1', '\$150']),
    Fila(celdas: <String>['Especie 2', '1', '\$200']),
    Fila(celdas: <String>['Especie 3', '1', '\$150']),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información pedido'),
      ),
      body: ListView(
        children: [
          PaginatedDataTable(
            header: Text('Pedido: 0'),
            rowsPerPage: 3,
            columns: [
              DataColumn(label: Text('Especie')),
              DataColumn(label: Text('Número')),
              DataColumn(label: Text('Subtotal')),
            ],
            source: DataTableDataSource(context: context, filas: filas),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$500',
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ),
          Tarjeta(
            color: Colors.white,
            contenido: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.blue),
                  title: Text('Dirección'),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calle #00 52000, colonia Prueba, Metepec, México')
                )
              ],
            )
          ),
          Tarjeta(
            color: Colors.white,
            contenido: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.yellow.shade800
                  ),
                  title: Text('Estado'),
                  subtitle: Text('Por confirmar'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Comprobante de pago'),
                        subtitle: Text('No ha seleccionado ningún comprobante'),
                      ),
                      Row(
                        children: <Widget>[
                          TextButton(
                            child: Text('Ver'),
                            onPressed: null
                          ),
                          TextButton(
                            child: Text('Seleccionar'),
                            onPressed: () {}
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(FontAwesomeIcons.save, color: Colors.blue),
                      tooltip: 'Guardar comprobante',
                      onPressed: () {
                      },
                    )
                  ],
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}