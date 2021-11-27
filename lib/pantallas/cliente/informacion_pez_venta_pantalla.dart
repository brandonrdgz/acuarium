import 'package:acuarium/componentes/control_number.dart';
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:acuarium/modelos/item_carrito.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/pantallas/cliente/visor_ar_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InformacionPezVentaPantalla extends StatefulWidget {
  static const String id = 'InformacionPezVentaPantalla';
 @override
  _InformacionPezVentaPantallaState createState() => _InformacionPezVentaPantallaState();
}

class _InformacionPezVentaPantallaState extends State<InformacionPezVentaPantalla> {
  late PezVenta _pez;
  TextEditingController _countCont = TextEditingController();

  

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
              NumberPicker(cont: _countCont, max: _pez.getNumero, min: 1),
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
        floatingActionButton: FloatingActionButton(
        onPressed: () {
                    int n=int.parse(_countCont.text);
                    if(n>0&&n<=_pez.getNumero){
                          Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Agregar ${pez.getNombre} al carrito?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaAdicion(pez,n);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
                    }else{
                          Fluttertoast.showToast(
                                msg: 'Elija una cantidad',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                    }
        },
        tooltip: 'Agregar carrito',
        child: const Icon(FontAwesomeIcons.cartPlus,
      ),)
    );
  }
  
  @override
  Widget build(BuildContext context) {

    _pez = ModalRoute.of(context)!.settings.arguments as PezVenta;
    
    return SafeArea(
      child: _dataFromStream()
    );
  }

  _confirmaAdicion(PezVenta pez,int cantidad){
    var entry = pez.getImagen[0];
    Map<String, dynamic> data= ItemCarrito.toMapFromControl(pez.getNombre,Auth.getUserId()!,pez.getId,pez.getIdNegocio,entry['imgUrl'],pez.getCuidados,cantidad,pez.getPrecio);
  var res = Firestore.agregarCarrito(data: data, uid:Auth.getUserId()! );
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Agregando ${pez.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){    
                                Fluttertoast.showToast(
                                msg: 'Agregado',
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


 
}



  