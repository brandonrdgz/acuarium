import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InformacionPezPantalla extends StatelessWidget {
  static const String id = 'InformacionPezPantalla';
  final List<Fila> filas = [
    Fila(celdas: <String>['\$150', 'Disponible', '1']),
  ];

  final List<String> rutasImagenes = [
    'images/pez.png',
    'images/pez.png',
    'images/pez.png'
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información especie'),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.pencilAlt),
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.trash),
            onPressed: () {}
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              PaginatedDataTable(
                header: Text('Especie 1'),
                rowsPerPage: 1,
                columns: <DataColumn>[
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Número')),
                ],
                source: DataTableDataSource(context: context, filas: filas)
              ),
              Tarjeta(
                color: Colors.white,
                contenido: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(FontAwesomeIcons.stickyNote),
                      title: Text('Descripción'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                      child: SelectableText('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
                    )
                  ],
                )
              ),
              Tarjeta(
                color: Colors.white,
                contenido: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Galería'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: rutasImagenes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                child: Hero(
                                  tag: rutasImagenes[index] + '$index',
                                  child: Image.asset(rutasImagenes[index])
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return ImagenCompletaPantalla(
                                      heroTag: rutasImagenes[index] + '$index',
                                      rutaImagen: rutasImagenes[index],
                                    );
                                  }));
                                },
                              ),
                            );
                          }
                        ),
                      ),
                    )
                  ],
                )
              ),
              Tarjeta(
                color: Colors.white,
                contenido: ListTile(
                  leading: Icon(FontAwesomeIcons.eye, color: Colors.blue),
                  title: Text('Realidad aumentada'),
                  subtitle: Text('Previsualizar'),
                  onTap: () {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ImagenCompletaPantalla extends StatelessWidget{
  final String heroTag;
  final String rutaImagen;

  ImagenCompletaPantalla({required this.rutaImagen, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: heroTag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(rutaImagen),
          ),
        ),
      )
    );
  }
}