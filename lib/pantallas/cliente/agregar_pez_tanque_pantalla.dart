import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NuevoPezTanque extends StatefulWidget {
  static const String id = 'nuevoPezTanque';
  const NuevoPezTanque({ Key? key }) : super(key: key);

  @override
  _NuevoPezTanqueState createState() => _NuevoPezTanqueState();
}

class _NuevoPezTanqueState extends State<NuevoPezTanque> {
      TextEditingController nombreCont = new TextEditingController();
  TextEditingController litrosCont = new TextEditingController();
  TextEditingController altoCont = new TextEditingController();
  TextEditingController anchoCont = new TextEditingController();
  TextEditingController profundoCont = new TextEditingController();
  TextEditingController fechaCont = new TextEditingController();
  TextEditingController moduloCont = new TextEditingController();
  TextEditingController cuidadosCont = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => {},
              tooltip: 'Nuevo',
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
                _formField('Número', litrosCont,TextInputType.number,FontAwesomeIcons.hashtag),
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
                    false?
                    Image(
                    image: AssetImage(''),
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