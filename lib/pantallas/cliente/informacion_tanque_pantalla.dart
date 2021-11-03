
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/fish_list.dart';
import 'package:acuarium/componentes/module_reader.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/editar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_peces_tanque_pantalla.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TanqueVista extends StatefulWidget {
  static const String id = 'vistaTanque';
  const TanqueVista({ Key? key }) : super(key: key);

  @override
  _TanqueVistaState createState() => _TanqueVistaState();
}

class _TanqueVistaState extends State<TanqueVista> {
  late final Tanque _tanque ;
  
  TextEditingController _moduloCont = new TextEditingController();

      @override
  void initState() {
    
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    _tanque = ModalRoute.of(context)!.settings.arguments as Tanque;
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(_tanque.getNombre),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [       
                CarouselSlider(
                options: CarouselOptions(height: 200.0,autoPlay: true),
                items: _tanque.getGaleriaImgs(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                  IconLabel(icon:Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),text: ' Datos'),
                  TextLabel(label: 'Dimensiones',text: '${_tanque.getAlto}cm ${_tanque.getAncho}cm ${_tanque.getProfundo}cm'),
                  TextLabel(label:'Litros', text:'${_tanque.getLitros}'),
                  TextLabel(label:'Temperatura ideal',text:'${_tanque.getTemperatura}° c'),
                  TextLabel(label:'Fecha Montaje', text:_tanque.getFechaMontaje),                  
                  Divider(thickness: 2.0,),
                  ModuleReader(moduloCont: _moduloCont,readAv: false,),
                  Divider(thickness: 2.0,),
                  FishList(idTanque: _tanque.getId),

                  ],
                ),
              )
              



            ]
        ),
      ),      
      floatingActionButton: _getFAB(),
    )
    );
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
                onTap: () { Navigator.pushNamed(context, TanqueEditar.id,arguments:_tanque); },
                label: 'Editar tanque',
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
                                          contenido: Text('¿Eliminar ${_tanque.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
                 },
                label: 'Eliminar tanque',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
                // FAB 2
                SpeedDialChild(
                child: Icon(FontAwesomeIcons.leaf, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () {
                  Navigator.pushNamed(context, PecesTanque.id,arguments:_tanque); 
                },
                label: 'Administrar peces',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor:  Colors.blueAccent)
          ],
        );
  }

 
}