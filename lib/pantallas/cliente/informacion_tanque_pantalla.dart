
import 'package:acuarium/componentes/dialogo.dart';
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
  late final Tanque tanque ;
  //final CouldFireStoreService _db= CouldFireStoreService();

      @override
  void initState() {
    
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    tanque = ModalRoute.of(context)!.settings.arguments as Tanque;
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(tanque.getNombre),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [       
                CarouselSlider(
                options: CarouselOptions(height: 200.0,autoPlay: true),
                items: tanque.getGaleriaImgs(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                  _iconLabel(Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),' Datos'),
                  _label('Dimensiones', '${tanque.getAlto}cm ${tanque.getAncho}cm ${tanque.getProfundo}cm'),
                  _label('Litros', tanque.getLitros),
                  _label('Temperatura ideal','${tanque.getTemperatura}° c'),
                  _label('Fecha Montaje', tanque.getFechaMontaje),                  
                  Divider(thickness: 2.0,),
                  _iconLabel(Icon(FontAwesomeIcons.microchip, color: Colors.blueAccent),' Modulo'),
                  _label('Temperatura','20°c' ),                
                  _label('Ultima Lectura', '23/10/2021 02:20p.m.'),
                  _label('Alimentando cada','5 horas' ),
                  _label('Ultima comida', '23/10/2021 02:20p.m.'),
                  _label('Estado', 'Funcionando'),
                  Divider(thickness: 2.0,),
                  _iconLabel(Icon(FontAwesomeIcons.fish, color: Colors.blueAccent),' Peces'),
                  _label('Total de peces','20' ),
                  _label('Especies', '5'),

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
                onTap: () { Navigator.pushNamed(context, TanqueEditar.id,arguments:tanque); },
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
                                          contenido: Text('¿Eliminar ${tanque.getNombre}?'),
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
                  Navigator.pushNamed(context, PecesTanque.id,arguments:tanque); 
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

  /*_moduleBannerFromStream(){
  return  StreamBuilder(
  stream: _db.getModuleRef(widget.tanque.getIdModulo).snapshots(),
  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Card(child:Column(
            children: [
              Text('Datos del modulo'),
              Divider(),
              Text('Ocurrio un error'),
            ],
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(child:Column(
            children: [
              Text('Datos del modulo'),
              Divider(),
              Text('Cargando datos'),
            ],
          ));
        }

        if (snapshot.data!.exists) {
          return Card(child:Column(
            children: [
              Text('Datos del modulo'),
              Divider(),
              Text('Sin datos'),
            ],
          ));
        }
        return  Card(
          child: Column(
            children: [
              Text('Datos del modulo'),
              Divider(),
              _label('Temperatura', '${snapshot.data!.get('temp')}°C'),
              _label('TSS', '${snapshot.data!.get('tss')}mg/l'),  
            ],
          ),
        );
  });

}*/

 /* _listFromStream(){
  return  StreamBuilder(
  stream: _db.getPecesdeTanque(widget.tanque.getidCliente,widget.tanque.getId).snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Ocurrio un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Cargando datos');
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text('Sin datos');
        }

        List<Pez> items = [];
        snapshot.data!.docs.forEach((element) {
          items.add(Pez.fromSnapshot(element));
        });
        return _listBuilder(items);
  });

}*/

/*  _listBuilder( List<Pez> items){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return Column(
                  children:<Widget> [
                    Divider(height: 7.0,),
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${items[position].getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('${items[position].getNumero}',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 17.0,
                              child: Text('${position+1}',
                          style:TextStyle(color: Colors.white,fontSize: 21.0)),
                          )
                          ],),
                        )
                        ),
                    ],)
                  ],
                );
              }
              );
}
*/
 
  _edit(BuildContext context, Tanque tanque) async{
   //await Navigator.push(context, MaterialPageRoute(builder: (context) => DireccionNE(direccion:dir),));
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
}