import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class GaleryPicker extends StatefulWidget {
  final List<Image> images;
  final List<File> files;
  GaleryPicker({Key? key, required this.images, required this.files}) : super(key: key);

  @override
  _GaleryPickerState createState() => _GaleryPickerState();
}

class _GaleryPickerState extends State<GaleryPicker> {
  CarouselController _buttonCarouselController = CarouselController();
  Image _holder = Image(image: AssetImage('images/acuarium.png'),);
  final Icon _iconoCamara = Icon(Icons.camera_enhance_rounded);
  final ImagePicker _imagePicker = ImagePicker();
  int _currentIndex=0;
  bool _hasImage=false;

  @override
  void initState() {
      super.initState();
      widget.images.add(_holder);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
       Column(
                  children: [
                    CarouselSlider(
                    carouselController: _buttonCarouselController,
                    options: CarouselOptions(
                              height: 200.0,
                              onPageChanged: (index, reason) {
                                _currentIndex=index;
                              },

                              ),
                    items: widget.images,
                    
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: IconButton(
                                    onPressed: ()=>{
                                      _buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear)
                                    },
                                    icon: Icon(Icons.arrow_back,color: Colors.blueAccent,),
                                    ),
                                    ),
                  Flexible(child: IconButton(
                                    onPressed: ()=>{
                                      _muestraModalInferiorSeleccionarImagen() 
                                    },
                                    icon: Icon(Icons.add_a_photo,color: Colors.blueAccent,),
                                    ),
                                    ),
                  Flexible(child: IconButton(
                                    onPressed: ()=>{
                                      _deleteImage()
                                    },
                                    icon: Icon(Icons.delete,color: Colors.blueAccent,),
                                    ),
                                    ),
                  Flexible(child: IconButton(
                                    onPressed: ()=>{_buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear)},
                                    icon: Icon(Icons.arrow_forward,color: Colors.blueAccent,),
                                    ),
                                    ),                            
                ],
              )
                  ],
                )
      );
  }

  void _deleteImage(){
    setState(() {
      widget.images.removeAt(_currentIndex);
      widget.files.removeAt(_currentIndex);
      _currentIndex=0;
      _buttonCarouselController.jumpToPage(0);
      if(widget.images.length==0){
        widget.images.add(_holder);
        _hasImage=false;
      }
    });
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
        if(!_hasImage){
          widget.images.removeAt(0);
          _hasImage=true;
        }
        File file=File(imagenActual.path);
        widget.files.add(file);
        widget.images.add(Image.file(file));
      });
    }
  }


}