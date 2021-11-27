import 'package:acuarium/modelo/fila.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

class DataTableDataSourceP<T extends Fila> extends DataTableSource {
  final BuildContext context;
  final List<T> filas;
  final double imgWidth;

  int _contSeleccionadas = 0;

  DataTableDataSourceP({required this.context, required this.filas,required this.imgWidth});

  List<DataCell> _obtenCeldasDeFila(T fila) {
    List<DataCell> celdas = [];
    celdas.add(
      DataCell(
        CachedNetworkImage(
            imageUrl: fila.celdas[0],
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),   
            height: imgWidth,
            
            width: imgWidth,         
        )));
    for (int i=1;i<fila.celdas.length;i++) {
      celdas.add(DataCell(Text(fila.celdas[i])));
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