import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TanqueNuevo extends StatefulWidget {
  static const String id = 'nuevoTanque';
  TanqueNuevo({Key? key}) : super(key: key);

  @override
  _TanqueNuevoState createState() => _TanqueNuevoState();
}

class _TanqueNuevoState extends State<TanqueNuevo> {
  List<Image> images=[Image(
                            image: AssetImage('acuarium.png'),
                            )];
  TextEditingController nombreCont = new TextEditingController();
  TextEditingController litrosCont = new TextEditingController();
  TextEditingController altoCont = new TextEditingController();
  TextEditingController anchoCont = new TextEditingController();
  TextEditingController profundoCont = new TextEditingController();
  TextEditingController fechaCont = new TextEditingController();
  TextEditingController moduloCont = new TextEditingController();
  TextEditingController tempCont = new TextEditingController();

        @override
  void initState() {
      super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
            Scaffold(
                    resizeToAvoidBottomInset: true,
            appBar: AppBar(
                title: Text('Nuevo Tanque'),
                backgroundColor: Colors.blueAccent,
            ),
            body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:  Column(
              children: <Widget>[
                _galeryPicker(),
                Divider(thickness: 1.5,),
                _form(),
                Divider(thickness: 1.5,),
                _module()
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
                _formField('Nombre', nombreCont,TextInputType.name,FontAwesomeIcons.leaf),
                _formField('Litros', litrosCont,TextInputType.number,Icons.water_outlined),
                _formField('Alto', altoCont,TextInputType.number,FontAwesomeIcons.rulerVertical),
                _formField('Ancho', anchoCont,TextInputType.number,FontAwesomeIcons.rulerHorizontal),
                _formField('Largo', profundoCont,TextInputType.number,FontAwesomeIcons.rulerCombined),
                _formField('Temperatura ideal',tempCont,TextInputType.number,FontAwesomeIcons.thermometer),
                _formField('Fecha Montaje', fechaCont,TextInputType.text,FontAwesomeIcons.calendar),
                  ],
                ),
                )
    );
                
  }
  _module(){
    return 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      
                      children: [
                      Expanded(                                                    
                            child:                        
                              Text(moduloCont.text.isEmpty?"Moludo no conectado":'Modulo conectado',
                                    style: TextStyle( fontWeight: FontWeight.bold, fontSize:20.0 ) 
                            )
                             )
                    ],),

                        IconButton(
                                    tooltip: 'Conectar Modulo',
                                    onPressed: ()async=>{await _qr()},
                                    icon: Icon(Icons.qr_code_scanner,color: Colors.blueAccent),
                                    iconSize: MediaQuery.of(context).size.width/2,),
                  ]

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
    return  Column(
                  children: [
                    CarouselSlider(
                      //carouselController: buttonCarouselController,
                    options: CarouselOptions(height: 200.0),
                    items: images,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: IconButton(
                                    onPressed: ()=>{},//buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear)},
                                    icon: Icon(Icons.arrow_back,color: Colors.blueAccent,),
                                    ),
                                    ),
                  Flexible(child: IconButton(
                                    onPressed: ()=>{},//()async =>{await _addImage()},
                                    icon: Icon(Icons.add_a_photo,color: Colors.blueAccent,),
                                    ),
                                    ),
                  Flexible(child: IconButton(
                                    onPressed: ()=>{},//()async =>{await _addImage()},
                                    icon: Icon(Icons.delete,color: Colors.blueAccent,),
                                    ),
                                    ),
                  Flexible(child: IconButton(
                                    onPressed: ()=>{},//()=>{buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear)},
                                    icon: Icon(Icons.arrow_forward,color: Colors.blueAccent,),
                                    ),
                                    ),                            
                ],
              )
                  ],
                );
  }
  _qr() {}
}