import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/pantallas/cliente/agregar_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DireccionesLista extends StatefulWidget {
  static const String id = 'Direcciones';
  const DireccionesLista({ Key? key }) : super(key: key);

  @override
  _DireccionesListaState createState() => _DireccionesListaState();
}

class _DireccionesListaState extends State<DireccionesLista> with TickerProviderStateMixin {
  static const String _uid='UE6kbvXbLpFWCVBSzsF2';
  List<Direccion> items=[];
  //final CouldFireStoreService _db= CouldFireStoreService();
  late TextEditingController searchControler;
  bool isSearching =false;

  
  @override
  void initState() {
      super.initState();
      searchControler= new TextEditingController();
        for(var i=0;i<4;i++){
        Direccion t= new Direccion();
        t.setId='$i';
        t.setIdCliente='$i';
        t.setNombre='Direccion$i';
        t.setCalle='Calle$i';
        t.setNumero='$i';
        t.setCodigoPostal='524$i';
        t.setMunicipio='Aguascalientes';
        t.setEstado='Aguascalientes';
        t.setLat=19.263118916452402;
        t.setLng=-99.63582289076116;
        items.add(t);
      }
  }
@override
  void dispose(){
    super.dispose();
    searchControler.dispose();

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
                      controller: searchControler,
                      prefixIcon:Icons.search,
                      keyboardType: TextInputType.text,
                      onChanged: (string) {
                          setState(() {
                            searchControler.text.isNotEmpty?isSearching=true:isSearching=false;
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
                return Tarjeta(color:Colors.white,
                  contenido:Column(
                  children:<Widget> [
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${items[position].getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('${items[position].getCalle}, ${items[position].getMunicipio} ${items[position].getEstado}',
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
                          onTap: () =>_see(context,items[position]),
                        )
                        ),
                        IconButton(
                          onPressed: ()=> {
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
                          onPressed: () =>_edit(context, items[position]), 
                          icon: Icon(Icons.edit, color: Colors.blueAccent)),

                    ],)
                  ],
                ));
              }
              );
}

   _see(BuildContext context, Direccion dir) async{
   Navigator.pushNamed(context, DireccionVista.id,arguments:dir); 
  }

  _edit(BuildContext context, Direccion dir) async{
   Navigator.pushNamed(context, EditarDireccion.id,arguments:dir); 
  }

  _new(BuildContext context) async{
   Navigator.pushNamed(context, NuevaDireccion.id,); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('Direcciónes'),
          backgroundColor: Colors.blueAccent,
      ),
            drawer: MenuClienteDrawer(
        nombreEncabezado: 'Cliente',
        correoEncabezado: 'cliente@cliente.com',
      ),
      body: Column(children: [
            _searchField(),
            Divider(),
            Flexible(child: _listBuilder()/*_listFromStream()*/)
            ],
          ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _new(context),
        tooltip: 'Nuevo',
        child: const Icon(Icons.add),
      ),
    );
  }
}