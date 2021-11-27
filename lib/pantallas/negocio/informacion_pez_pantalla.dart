import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/pantallas/cliente/visor_ar_pantalla.dart';
import 'package:acuarium/pantallas/negocio/editar_pez_pantalla.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class InformacionPezPantalla extends StatefulWidget {
  static const String id = 'InformacionPezPantalla';
  const InformacionPezPantalla({ Key? key }) : super(key: key);

  @override
  _InformacionPezPantallaState createState() => _InformacionPezPantallaState();
}

class _InformacionPezPantallaState extends State<InformacionPezPantalla> {
  late PezVenta _pez;

  var Auth;

_dataFromStream(){
    return StreamBuilder(
      stream: Firestore.datosPezVenta(did: _pez.getId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return _errorView('Error','Error al cargar los datos');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingView('Cargando','Cargando Datos');
        }

        if (!snapshot.data!.exists){
          return _errorView('Sin datos','No se encontraron los datos');
        }

        if (snapshot.data!.data()!.length==0) {
          return _errorView('Sin datos','No se encontraron los datos');
        }

        _pez=PezVenta.fromSnapshot(snapshot.data!);
        return _dataDisplay(_pez);
  });
  }

  _loadingView(String titulo,String msgError){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: 
        InfoView(type: InfoView.LOADING_VIEW, context: context,)
            )
            );
  }
  _errorView(String titulo,String msgError){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child:InfoView(type: InfoView.ERROR_VIEW, context: context,msg: msgError,)
            )
            );
  }

  _dataDisplay(PezVenta pez){
    final List<Fila> filas = [
    Fila(celdas: <String>['\$${pez.getPrecio}', pez.getDisponible?'Disponible':'No disponible', '${pez.getNumero}']),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Información especie: ${pez.getNombre}'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              PaginatedDataTable(
                header: Text('${pez.getNombre}'),
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
                      child: SelectableText('${pez.getCuidados}'),
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
                        child:
                          CarouselSlider(
                            options: CarouselOptions(autoPlay: true),
                            items: pez.getGaleriaImgs(),
                  ),  ),
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
                  onTap: () =>{
                    Navigator.pushNamed(context, VisorAr.id,arguments:pez.getModelo) 
                  },
                ),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    _pez = ModalRoute.of(context)!.settings.arguments as PezVenta;
    
    return SafeArea(
      child: _dataFromStream()
    );
  }

  _confirmaEliminacion(PezVenta pez){
  var res = Firestore.eliminaPezVenta(did: pez.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${pez.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){                                
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                msg: 'Datos Borrados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                          }, );
  }

  _confirmaCambio(PezVenta pez){
  var res = Firestore.actualizaEstadoPezVenta(pid: pez.getId,newState: !pez.getDisponible);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Actualizando ${pez.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){      
                                Fluttertoast.showToast(
                                msg: 'Datos actualizados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                          }, );
  }



  Widget _getFAB() {
        return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Colors.blueAccent,
          visible: true,
          curve: Curves.bounceIn,
          children: [
                // FAB 1
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () { Navigator.pushNamed(context, EditarPezPantalla.id,arguments:_pez); },
                label: 'Editar Pez',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
              SpeedDialChild(
                child: Icon(Icons.delete, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () { 
                                        Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${_pez.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaEliminacion(_pez);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
                 },
                label: 'Eliminar pez',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
              SpeedDialChild(
                child: Icon(_pez.getDisponible?FontAwesomeIcons.ban:FontAwesomeIcons.check, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () { 
                                        Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text(_pez.getDisponible?
                                                    '¿Poner no disponible ${_pez.getNombre}?':
                                                    '¿Poner disponible ${_pez.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaCambio(_pez);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
                 },
                label: _pez.getDisponible?'Hacer no disponible':'Hacer disponible',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),

          ],
        );
  }

 
}


