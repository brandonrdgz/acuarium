import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/agregar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Tanques extends StatefulWidget {
  static const String id = 'ListaTanques';
 Tanques({Key? key}) : super(key: key);

  @override
   TanquesState createState() =>  TanquesState();
}



class  TanquesState extends State <Tanques> {
  TextEditingController searchController= new TextEditingController();
  List<Tanque> items=[];

    @override
  void initState() {
      super.initState();
      for(var i=0;i<4;i++){
        Tanque t= new Tanque();
        t.setId='$i';
        t.setIdCliente='$i';
        t.setIdModulo='$i';
        t.setAlto=5;
        t.setAncho=5;
        t.setProfundo=5;
        t.setLitros=125;
        t.setNombre='Tanque$i';
        t.setFechaMontaje='23/10/2021';
        t.setTemperatura=20;
        t.setGaleria=['images/asset1.jpg'];
        items.add(t);
      }
  }
@override
  void dispose(){
    super.dispose();
    searchController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('Tanques'),
          backgroundColor: Colors.blueAccent,
      ),
            drawer: MenuClienteDrawer(
        nombreEncabezado: 'Cliente',
        correoEncabezado: 'cliente@cliente.com',
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
                            //searchControler.text.isNotEmpty?isSearching=true:isSearching=false;
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
                return 
                 Tarjeta(contenido: _CardBody(items[position]),color:Colors.white);
               
              }
              );
}

 _CardBody(Tanque tanque){
   return Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(    
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image(
                              image: AssetImage(tanque.getGaleria[0]),
                            )
                          )
                          ]
                    ),
                      Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${tanque.getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('Litros: ${tanque.getLitros}l',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          
                        onTap: () =>_see(context,tanque),
                        )
                        ),
                        IconButton(
                          onPressed: ()=>{
                                        Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${tanque.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ])
                                            },
                          icon: Icon(Icons.delete, color: Colors.blueGrey)),
                        IconButton(
                          onPressed: () =>{_edit(context, tanque)}, 
                          icon: Icon(Icons.edit, color: Colors.blueAccent)),

                        ]
                        ),

                    ],
                  );


 }

  _new(BuildContext context) {
    Navigator.pushNamed(context, TanqueNuevo.id);
  }

  _see(BuildContext context, Tanque item) {
    Navigator.pushNamed(context, TanqueVista.id,arguments:item);
  }

  _edit(BuildContext context, Tanque item) {
    Navigator.pushNamed(context, TanqueEditar.id,arguments:item);
  }
}