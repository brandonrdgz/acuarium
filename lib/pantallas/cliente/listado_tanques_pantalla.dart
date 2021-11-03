import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/agregar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Tanques extends StatefulWidget {
  static const String id = 'ListaTanques';
 Tanques({Key? key}) : super(key: key);

  @override
   TanquesState createState() =>  TanquesState();
}



class  TanquesState extends State <Tanques> {
  TextEditingController _searchController= new TextEditingController();
  List<Tanque> _items=[];
  List<Tanque> _filterItems=[];
  static final String _title ='Tanques';
  bool _isSearching=false;

    @override
  void initState() {
      super.initState();
  }
@override
  void dispose(){
    super.dispose();
    _searchController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.blueAccent,
      ),
            drawer: MenuClienteDrawer(
        nombreEncabezado: Auth.getUserId()!,
        correoEncabezado: Auth.getUserEmail()!,
      ),
      body: Column(children: [
            _searchField(),
            Divider(),
            Flexible(
              child:_isSearching?_listFromFilter():_listFromStream()            
            )
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
                      controller: _searchController,
                      prefixIcon:Icons.search,
                      keyboardType: TextInputType.text,
                      onChanged: (string) {
                          setState(() {
                            _searchController.text.isNotEmpty?_isSearching=true:_isSearching=false;
                            if(_isSearching){
                              _filterItems.clear();
                              _items.forEach((element) {
                                if(element.getNombre.startsWith(_searchController.text)){
                                  _filterItems.add(element);
                                }
                               });
                          }
                        });
                      }
                    ),
                    )
                  ]);               
}
  _listFromFilter(){
        if (_filterItems.length==0) {
          return Text('Sin resultados');
        }else{
          return _listBuilder(_filterItems);
        }
        
  }

  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.listaTanques(uid: Auth.getUserId()!),
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

        _items.clear();
        snapshot.data!.docs.forEach((element) {
          _items.add(Tanque.fromSnapshot(element));
        });
        
        return _listBuilder(_items);
  });

}

  _listBuilder(List<Tanque> items){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return 
                 Tarjeta(contenido: _cardBody(items[position]),color:Colors.white);
              }
              );
}

  _cardBody(Tanque tanque){
   return Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(    
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: tanque.getCardImgs()
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
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaEliminacion(tanque);
                                                        },),
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

  _confirmaEliminacion(Tanque t){
  var res = Firestore.eliminaTanque(uid: Auth.getUserId()!, rid: t.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${t.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){
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