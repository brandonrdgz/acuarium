import 'dart:io';

import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/galery_editor.dart';
import 'package:acuarium/componentes/module_reader.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TanqueEditar extends StatefulWidget {
  static const String id = 'EditarTanque';
  TanqueEditar({Key? key}) : super(key: key);

  @override
  _TanqueEditarState createState() => _TanqueEditarState();
}

class _TanqueEditarState extends State<TanqueEditar> {
   
    late  Tanque _tanque ;
    TextEditingController _nombreCont = new TextEditingController();
    TextEditingController _litrosCont = new TextEditingController();
    TextEditingController _altoCont = new TextEditingController();
    TextEditingController _anchoCont = new TextEditingController();
    TextEditingController _profundoCont = new TextEditingController();
    TextEditingController _fechaCont = new TextEditingController();
    TextEditingController _moduloCont = new TextEditingController();
    TextEditingController _tempMaxCont = new TextEditingController();
    TextEditingController _lumMaxCont = new TextEditingController();
    TextEditingController _tempMinCont = new TextEditingController();
    TextEditingController _lumMinCont = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    GaleryEditorController _galeryController = new GaleryEditorController();
    late DateTime _ultFechaSeleccionada;

        @override
  void initState() {
      super.initState();
  }

  init(){
      _tanque = ModalRoute.of(context)!.settings.arguments as Tanque;
      _nombreCont.text=_tanque.getNombre;
      _litrosCont.text=_tanque.getLitros.toString();
      _altoCont.text=_tanque.getAlto.toString();
      _anchoCont.text=_tanque.getAncho.toString();
      _profundoCont.text=_tanque.getProfundo.toString();
      _fechaCont.text=_tanque.getFechaMontaje;
      _tempMaxCont.text=_tanque.getTemperaturaMax.toString();
      _tempMinCont.text=_tanque.getTemperaturaMin.toString();
      _moduloCont.text=_tanque.getIdModulo;
      _lumMaxCont.text=_tanque.getLuminocidadMax.toString();
      _lumMinCont.text=_tanque.getLuminocidadMin.toString();
      _tanque.getGaleria.forEach((element) { 
       _galeryController.addImageFromMap(element);
      });     
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
                Divider(thickness: 1.5,),
                ModuleReader(moduloCont: _moduloCont,
                            readAv: true,
                              tempMax: _tanque.getTemperaturaMax,
                              tempMin: _tanque.getTemperaturaMin,
                              lumMax: _tanque.getLuminocidadMax,
                              lumMin: _tanque.getLuminocidadMin,
                ),
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
                _formField('Nombre', _nombreCont,TextInputType.name,FontAwesomeIcons.leaf),
                _formField('Litros', _litrosCont,TextInputType.number,Icons.water_outlined),
                _formField('Alto', _altoCont,TextInputType.number,FontAwesomeIcons.rulerVertical),
                _formField('Ancho', _anchoCont,TextInputType.number,FontAwesomeIcons.rulerHorizontal),
                _formField('Largo', _profundoCont,TextInputType.number,FontAwesomeIcons.rulerCombined),
                _formField('Temperatura Max',_tempMaxCont,TextInputType.number,FontAwesomeIcons.thermometer),
                _formField('Temperatura Min',_tempMinCont,TextInputType.number,FontAwesomeIcons.thermometer),
                _dateField('Fecha montaje', _fechaCont,TextInputType.text,FontAwesomeIcons.lightbulb),
                _formField('Luminosidad Max', _lumMaxCont,TextInputType.datetime,FontAwesomeIcons.utensils),
                _formField('Luminosidad Min', _lumMinCont,TextInputType.datetime,FontAwesomeIcons.utensils),
                  ],
                ),
                )
    );
                
  }
  _dateField(String nombre,TextEditingController controller,TextInputType type,IconData icon ){
    return RoundedIconTextFormField(
                  controller: controller,
                  validator: (val) => val!.isEmpty ? nombre+' vacio':null,
                  labelText: nombre,
                  prefixIcon: icon,
                  keyboardType: type,
                  readOnly: true,
                  onTap: _seleccionaFecha,
                );
  }

  void _seleccionaFecha() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      initialDate: _ultFechaSeleccionada,
      lastDate: DateTime(DateTime.now().year - 15, 12, 31),
      helpText: 'Selecciona una fecha',
    );

    if (fechaSeleccionada != null) {
      //setState(() {
        _ultFechaSeleccionada = fechaSeleccionada;
        _fechaCont.text = '${fechaSeleccionada.day.toString().padLeft(2, "0")}/'
          '${fechaSeleccionada.month.toString().padLeft(2, "0")}/'
          '${fechaSeleccionada.year.toString()}';
      //});
    }
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

  _deleteImages(int index,GaleryEditorController controller,List<dynamic> imgs){
       if(controller.getDeleted.length>0&&controller.getDeleted.length>index){
    String uid=Auth.getUserId()!;
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Actualizando imagenes'),
                          future: Storage.eliminaImagenTanque(uid: uid, name: controller.getDeleted.elementAt(index).imagePath!), 
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
                          future: Storage.guardaImagenTanque(uid: uid, img: files[index]), 
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
  var datos = Tanque.toMapFromControl(
                                        Auth.getUserId()!, 
                                        _moduloCont.text,
                                        _nombreCont,
                                        _litrosCont,
                                        _altoCont,
                                        _anchoCont,
                                        _profundoCont, 
                                        _tempMaxCont,
                                        _tempMinCont,
                                        _fechaCont, 
                                        _lumMaxCont,
                                        _lumMinCont,
                                        imgs);
  var res = Firestore.actualizaTanque(uid: Auth.getUserId()!, datos: datos,tid: _tanque.getId);
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
  _validaFormulario(){

    if(_formKey.currentState!.validate()){
      double tmax=double.parse(_tempMaxCont.text);
      double tmin=double.parse(_tempMinCont.text);
      double lmax=double.parse(_lumMaxCont.text);
      double lmin=double.parse(_lumMinCont.text);
      if(tmax<tmin){
              Fluttertoast.showToast(
                msg: 'La temperatura minima no puede ser mayor que la maxima',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );

      }else if(lmax<lmin){
                      Fluttertoast.showToast(
                msg: 'La luminosidad minima no puede ser mayor que la maxima',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );

      }else{
      _saveDialog();
      }
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
                    _deleteImages(index, _galeryController, _tanque.getGaleria);
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }

}