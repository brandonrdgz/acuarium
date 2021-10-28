import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditarPezTanque extends StatefulWidget {
  static const String id = 'editarPezTanque';
  const EditarPezTanque({ Key? key }) : super(key: key);

  @override
  _EditarPezTanqueState createState() => _EditarPezTanqueState();
}

class _EditarPezTanqueState extends State<EditarPezTanque> {
      TextEditingController nombreCont = new TextEditingController();
  TextEditingController numeroCont = new TextEditingController();
  TextEditingController cuidadosCont = new TextEditingController();
  TextEditingController imagenCont = new TextEditingController();
  late final PezDeTanque pez ;

  void initState() {
      super.initState();

  }
  init(){
    pez = ModalRoute.of(context)!.settings.arguments as PezDeTanque;
     nombreCont.text=pez.getNombre;
      numeroCont.text=pez.getNumero.toString();
      cuidadosCont.text=pez.getCuidados;
      imagenCont.text=pez.getImagen;

  }

  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(child: 
            Scaffold(
                    resizeToAvoidBottomInset: true,
            appBar: AppBar(
                title: Text('Editando ${nombreCont.text}'),
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
              onPressed: () => {},
              tooltip: 'Guardar',
              child: const Icon(Icons.save),
            ),
            )
            );
  }

    _form(){
    return  
              Form(
                child:
                Container(
                  child: Column(
                  children: [
                _formField('Especie', nombreCont,TextInputType.name,FontAwesomeIcons.fish),
                _formField('Número', numeroCont,TextInputType.number,FontAwesomeIcons.hashtag),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(
                    child: 
                  RoundedIconTextFormField(
                  controller: cuidadosCont,
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
                    imagenCont.text.isNotEmpty?
                    Image(
                    image: AssetImage(imagenCont.text),
                  ):
                  IconButton(
                                    iconSize: MediaQuery.of(context).size.width/2,
                                    onPressed: ()=>{},//()async =>{await _addImage()},
                                    icon: Icon(Icons.add_a_photo,color: Colors.blueAccent,),
                                    ),
                  ],
                );
  }
}