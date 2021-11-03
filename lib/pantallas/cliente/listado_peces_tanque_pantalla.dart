import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/agregar_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_tanque_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PecesTanque extends StatefulWidget {
  static const String id = 'PecesTanque';
  PecesTanque({Key? key}) : super(key: key);

  @override
  _PecesTanqueState createState() => _PecesTanqueState();
}

class _PecesTanqueState extends State<PecesTanque> {
  late final Tanque tanque ;
TextEditingController searchController= new TextEditingController();
  List<PezDeTanque> items=[];

    @override
  void initState() {
      super.initState();
  }


@override
  void dispose(){
    super.dispose();
    searchController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    tanque = ModalRoute.of(context)!.settings.arguments as Tanque;
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('${tanque.getNombre}:Peces'),
          backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
            _searchField(),
            Divider(),
            Flexible(child: _listBuilder())
            ],
          ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _new(context),
        tooltip: 'Nuevo',
        child: const Icon(Icons.add),
      ),
    ));
  }

  _searchField(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: 
                    RoundedIconTextFormField(
                      validator: (val) => val!.isEmpty ?' vacio':null,
                      labelText: 'Búsqueda',
                      controller: searchController,
                      prefixIcon:Icons.search,
                      keyboardType: TextInputType.text,
                      onChanged: (string) {
                          setState(() {
                            //searchController.text.isNotEmpty?isSearching=true:isSearching=false;
                          });
                        },
                    ),
                    )
                  ]);               
}


  /*_listFromStream(){
  return  StreamBuilder(
  stream: isSearching?_db.getFiltraDirecciones(_uid,searchControler.text).snapshots():_db.getDirecciones(_uid).snapshots(),
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

        items.clear();
        snapshot.data!.docs.forEach((element) {
          items.add(Direccion.fromSnapshot(element));
        });
        return _listBuilder();
  });

}*/

  _listBuilder(){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return Tarjeta(
                  color: Colors.white,
                  contenido: 
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(    
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image(
                              image: AssetImage(items[position].getImagen),
                            )
                          )
                          ]
                    ),
                      Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${items[position].getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('Número: ${items[position].getNumero}',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          
                        onTap: () =>_see(context,items[position]),
                        ),
                        ),
                      IconButton(
                          onPressed: ()=>{
                                        Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${items[position].getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ])
                                            },
                          icon: Icon(Icons.delete, color: Colors.blueGrey)),
                        IconButton(
                          onPressed: () =>{_edit(context, items[position])}, 
                          icon: Icon(Icons.edit, color: Colors.blueAccent)),

                        ]
                        ),

                    ],
                  ),
                );
              }
              );
}

  _new(BuildContext context) {
    Navigator.pushNamed(context, NuevoPezTanque.id);
  }

  _see(BuildContext context, PezDeTanque item) {
     Navigator.pushNamed(context, PezTanque.id,arguments:item);
  }

  _edit(BuildContext context, PezDeTanque item) {
     Navigator.pushNamed(context, EditarPezTanque.id,arguments:item);
  }
}