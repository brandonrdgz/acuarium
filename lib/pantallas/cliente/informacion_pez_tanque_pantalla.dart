import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/pantallas/cliente/editar_pez_tanque_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PezTanque extends StatefulWidget {
  static const String id = 'PezTanque';
  const PezTanque({ Key? key}) : super(key: key);

  @override
  _PezTanqueState createState() => _PezTanqueState();
}

class _PezTanqueState extends State<PezTanque> {
  late final PezDeTanque pez ;
   @override
  void initState() {
      super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    pez = ModalRoute.of(context)!.settings.arguments as PezDeTanque;
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(pez.getNombre),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [       
              Image(
                    image: AssetImage(pez.getImagen),
                  ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                  Divider(thickness: 2.0,),
                  _iconLabel(Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),' Datos'),
                  _label('Especie', '${pez.getNombre}'),
                  _label('Número', '${pez.getNumero}'),
                  Divider(thickness: 2.0,),
                  _iconLabel(Icon(FontAwesomeIcons.leaf, color: Colors.blueAccent),' Cuidados'),                  
                  Row(
                    children: [
                      Expanded(child: 
                          Text("${pez.getCuidados}",
                                style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                textAlign: TextAlign.justify, 
                                )
                      ,),
                    ],
                  )
                            ,

                  ],
                ),
              )


            //_moduleBannerFromStream(),   
            /*Card(
              child: Column(
                children: [
                  Text('Peces'),
                  Flexible(child: _listFromStream()),
                  TextButton(onPressed:()async=>{},                  
                  style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blueAccent
                        ),
                  child: Text("Ver lista", style: 
                  TextStyle( fontWeight: FontWeight.bold, fontSize:18.0 ))
                ),
                ],
              )
            )*/             
            ]
        ),
      ),      
      floatingActionButton: _getFAB(),
    )
    );
  }

    Row _iconLabel(Icon icon, String campo){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        child:icon,
      ),
      Flexible(
        child:
          Text("$campo: ",
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize:20.0 ) 
              )
      ),
    ]
  );                  
}

  Row _label( String campo,  val){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        child:
          Text("$campo: ",
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize:18.0 ) 
              ),
      ),
      Flexible(
        child:
          Text("$val",
                      style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0 ) 
              ),
      ),
    ]
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
                onTap: () { Navigator.pushNamed(context, EditarPezTanque.id,arguments:pez);},
                label: 'Editar',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
                // FAB 2
                SpeedDialChild(
                child: Icon(Icons.delete, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () {
                              Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${pez.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
                },
                label: 'Eliminar',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor:  Colors.blueAccent)
          ],
        );
  }



}