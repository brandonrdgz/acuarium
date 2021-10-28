import 'package:acuarium/modelo/fila.dart';
import 'package:flutter/material.dart';

class DataTableDataSource<T extends Fila> extends DataTableSource {
  final BuildContext context;
  final List<T> filas;

  int _contSeleccionadas = 0;

  DataTableDataSource({required this.context, required this.filas});

  List<DataCell> _obtenCeldasDeFila(T fila) {
    List<DataCell> celdas = [];

    for (String celda in fila.celdas) {
      celdas.add(DataCell(Text(celda)));
    }

    return celdas;
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= filas.length) return null;

    return DataRow.byIndex(
      index: index,
      onSelectChanged: null,
      cells: _obtenCeldasDeFila(filas[index]),
    );
  }

  @override
  int get rowCount => filas.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _contSeleccionadas;
}