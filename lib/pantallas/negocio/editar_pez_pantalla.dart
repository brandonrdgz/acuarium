import 'dart:io';

import 'package:acuarium/componentes/control_modelo.dart';
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/galery_editor.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditarPezPantalla extends StatefulWidget {
  static const String id = 'EditarPezPantalla';

  @override
  State<EditarPezPantalla> createState() => _EditarPezPantallaState();
}

class _EditarPezPantallaState extends State<EditarPezPantalla> {
  TextEditingController _nombreCont = new TextEditingController();
  TextEditingController _numeroCont = new TextEditingController();
  TextEditingController _precioCont = new TextEditingController();
  TextEditingController _cuidadosCont = new TextEditingController();
  TextEditingController _modeloCont = new TextEditingController();
  bool _disponible=false;
  bool _hasload=false;
  GaleryEditorController _galeryController = new GaleryEditorController();
  final _formKey = GlobalKey<FormState>();
  late PezVenta _pez;

    init(){
      if(!_hasload){
      _pez = ModalRoute.of(context)!.settings.arguments as PezVenta;
      _nombreCont.text=_pez.getNombre;
      _numeroCont.text=_pez.getNumero.toString();
      _precioCont.text=_pez.getPrecio.toString();
      _cuidadosCont.text=_pez.getCuidados;
      _modeloCont.text=_pez.getModelo;
      _disponible=_pez.getDisponible;
      _pez.getImagen.forEach((element) { 
       _galeryController.addImageFromMap(element);
      }); 
      _hasload=true;
      }    
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(child: 
            Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                title: Text("Editando ${_nombreCont.text}"),
                backgroundColor: Colors.blueAccent,
            ),
            body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:  Column(
              children: <Widget>[
                GaleryEditor(controller: _galeryController,),
                Divider(thickness: 1.5,),
                _form(),                
               ]
        )
      ),
      
              floatingActionButton: FloatingActionButton(
              onPressed: () => { _validaFormulario()},
              tooltip: 'Guardar',
              child: const Icon(Icons.save),
            ),
            )
            );
  }

  _form(){
    return  
              Form(
                key:_formKey,
                child:
                Container(
                  child: Column(
                  children: [
                _formField('Nombre', _nombreCont,TextInputType.name,FontAwesomeIcons.fish),
                _formField('Numero', _numeroCont,TextInputType.number,FontAwesomeIcons.hashtag),
                _formField('Precio', _precioCont,TextInputType.number,FontAwesomeIcons.dollarSign),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(
                    child: 
                  RoundedIconTextFormField(
                  controller: _cuidadosCont,
                  validator: (val) => val!.isEmpty ? ' vacio':null,
                  labelText: 'Descripción',
                  prefixIcon: FontAwesomeIcons.leaf,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                ),
                ),

                ]),
                ModeloPicker(modelCont: _modeloCont),
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_disponible?'Disponible':'No disponible'),
                          Switch(
                            value: _disponible,
                            onChanged: (bool value) {
                              setState(() {
                                _disponible = value;
                              });
                            },
                          ),
                        ],
                      )],
                ),
                )
    );
                
  }
  _formField(String nombre,TextEditingController controller,TextInputType type,IconData icon ){
    return RoundedIconTextFormField(
                  controller: controller,
                  validator: (val) => val!.isEmpty ? nombre+' vacio':null,
                  labelText: nombre,
                  prefixIcon: icon,
                  keyboardType: type
                );
  }
  _validaFormulario(){
      if(_formKey.currentState!.validate()){
        _saveDialog();
      }else{
        Fluttertoast.showToast(
                  msg: 'Datos no validos',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
      }
    }
    _saveDialog(){
      Dialogo.dialogo(
        context,                                     
        titulo:Text('Atención'),
        contenido: Text('¿Guardar ${_nombreCont.text}?'),
        acciones: [
        IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                  onPressed: ()async{
                    Navigator.pop(context);
                    final int index=0;
                     _deleteImages(index, _galeryController, _pez.getImagen);
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }

   _deleteImages(int index,GaleryEditorController controller,List<dynamic> imgs){
       if(controller.getDeleted.length>0&&controller.getDeleted.length>index){
    String uid=Auth.getUserId()!;
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Actualizando imagenes'),
                          future: Storage.eliminaImagenPezVenta(uid: uid, name: controller.getDeleted.elementAt(index).imagePath!), 
                          alTerminar: (resultado) async {
                                Fluttertoast.showToast(
                                msg: 'Datos guardados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            GaleryImage gi=controller.getDeleted.elementAt(index);
                            var item=imgs.firstWhere((element) => element['imgPath']==gi.imagePath);
                            imgs.remove(item);
                            int i=index+1;
                             _deleteImages(i,controller,imgs);
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
                          },
                          );  
  }else{
    int i=0;
       _loadImages(controller.addedFiles(),i,imgs);
    }
  }
  _loadImages(List<File> files, int index,List<dynamic> imgs){
    if(files.length>=0 && files.length>index){
    String uid=Auth.getUserId()!;
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando imagenes'),
                          future: Storage.guardaImagenPezVenta(uid: uid, img: files[index]), 
                          alTerminar: (resultado) async {
                                Fluttertoast.showToast(
                                msg: 'Datos guardados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            TaskSnapshot ts =resultado as TaskSnapshot;
                            String imageUrl = await ts.ref.getDownloadURL();
                            String imagePath= ts.ref.name; 
                            imgs.add({
                              'imgUrl':imageUrl,
                              'imgPath':imagePath
                            });
                            int paso=index+1;
                            _loadImages(files, paso,imgs);
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
                          },
                          );  
  }else{
       _update(imgs);
    }

  }
  _update(List<dynamic> imgs) async {
  var datos = PezVenta.toMapFromControl(
                                        Auth.getUserId()!, 
                                        _nombreCont,
                                        _precioCont,
                                        _numeroCont,
                                        _modeloCont,
                                        _cuidadosCont, 
                                        _disponible,
                                        imgs);
  var res = Firestore.actualizaPezVenta(datos: datos,pid: _pez.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando ${_nombreCont.text}'),
                          future: res, 
                          alTerminar: (resultado){
                                Fluttertoast.showToast(
                                msg: 'Datos guardados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                             Navigator.pop(context);
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
                          },
                          );
    
}

}