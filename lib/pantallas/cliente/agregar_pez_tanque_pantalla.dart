import 'dart:io';

import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class NuevoPezTanque extends StatefulWidget {
  static const String id = 'nuevoPezTanque';
  const NuevoPezTanque({ Key? key }) : super(key: key);

  @override
  _NuevoPezTanqueState createState() => _NuevoPezTanqueState();
}

class _NuevoPezTanqueState extends State<NuevoPezTanque> {
  TextEditingController _nombreCont = new TextEditingController();
  TextEditingController _numeroCont = new TextEditingController();
  TextEditingController _cuidadosCont = new TextEditingController();
  final Icon _iconoCamara = Icon(Icons.camera_enhance_rounded);
  final ImagePicker _imagePicker = ImagePicker();
  bool _hasImage=false;
  File? _file;
  String _tanqueId="";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _tanqueId = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(child: 
            Scaffold(
                    resizeToAvoidBottomInset: true,
            appBar: AppBar(
                title: Text('Nuevo Pez'),
                backgroundColor: Colors.blueAccent,
            ),
            body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:  Column(
              children: <Widget>[
                _galeryPicker(),
                Divider(thickness: 1.5,),
                _form(),
               ]
                )
              ),
      
              floatingActionButton: FloatingActionButton(
              onPressed: () => {_validaFormulario()},
              tooltip: 'Nuevo',
              child: const Icon(Icons.save),
            ),
            )
            );
  }

  _form(){
    return  
              Form(
                key: _formKey,
                child:
                Container(
                  child: Column(
                  children: [
                _formField('Especie', _nombreCont,TextInputType.name,FontAwesomeIcons.fish),
                _formField('Número', _numeroCont,TextInputType.number,FontAwesomeIcons.hashtag),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(
                    child: 
                  RoundedIconTextFormField(
                  controller: _cuidadosCont,
                  validator: (val) => val!.isEmpty ? ' vacio':null,
                  labelText: 'Cuidados',
                  prefixIcon: FontAwesomeIcons.leaf,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                ),
                ),

                ]),
                  ],
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
  _galeryPicker(){
    return  
              Column(
                  children: [
                    _hasImage?
                    GestureDetector(
                    onTap: () {
                        _muestraModalInferiorSeleccionarImagen();
                    },
                    child:
                     Image.file(_file!,height: MediaQuery.of(context).size.width/2,)
                     ):
                  IconButton(
                    icon: Icon(FontAwesomeIcons.camera,color: Colors.blue,),
                    iconSize: MediaQuery.of(context).size.width/2,
                    onPressed: ()=>{_muestraModalInferiorSeleccionarImagen()},//()async =>{await _addImage()}                                icon: Icon(Icons.add_a_photo,color: Colors.blueAccent,),
                   ),
                  ],
                );
  }

  void _muestraModalInferiorSeleccionarImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0)
        )
      ),
      builder: (context) {
        return Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Imagen')
              ],
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    _iconoCamara,
                    Text('Cámara')
                  ],
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                _escogerImagen(ImageSource.camera);
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.photoVideo),
                    Text('Galería')
                  ],
                )
              ),
              onTap: () async {
                Navigator.pop(context);
                _escogerImagen(ImageSource.gallery);
              },
            )
          ],
        );
      }
    );
  }

  void _escogerImagen(ImageSource source) async {
    XFile? imagenActual = await _imagePicker.pickImage(source: source);

    if (imagenActual != null) {
      setState(() {
       _file=File(imagenActual.path);
       _hasImage=true;
      });
    }
  }

  _validaFormulario(){
    if(_formKey.currentState!.validate()&&_hasImage){
      _saveDialog();
    }else{
      Fluttertoast.showToast(
                msg: _hasImage?'Datos no validos':'Agregue una imagen',
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
                    _loadImage();
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }

    _loadImage(){
    String uid=Auth.getUserId()!;
      var index;
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando imagenes'),
                          future: Storage.guardaImagenPezTanque(uid: uid, img: _file!), 
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
                            var imgs = {
                              'imgUrl':imageUrl,
                              'imgPath':imagePath
                            };
                            _saveNew(imgs);
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
  _saveNew(Map<String, String> imgs) async {
  var datos = PezDeTanque.toMapFromControl(
                                        Auth.getUserId()!,     
                                        _tanqueId, 
                                        _nombreCont,
                                        _numeroCont,
                                        _cuidadosCont,
                                        imgs);
  var res = Firestore.registroPezdeTanque(uid: Auth.getUserId()!,tid:_tanqueId, datos: datos);
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