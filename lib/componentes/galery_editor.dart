import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class GaleryEditor extends StatefulWidget {
  final GaleryEditorController controller;

  GaleryEditor({Key? key, required this.controller}) : super(key: key);

  @override
  _GaleryEditorState createState() => _GaleryEditorState();
}

class _GaleryEditorState extends State<GaleryEditor> {
  CarouselController _buttonCarouselController = CarouselController();
  final Icon _iconoCamara = Icon(Icons.camera_enhance_rounded);
  final ImagePicker _imagePicker = ImagePicker();


  @override
  void initState() {
      super.initState();
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
                                widget.controller.setIndex=index;
                              },

                              ),
                    items: widget.controller.getImages,
                    
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
      if(widget.controller.hasImages){
        setState(() {
          widget.controller.deleteAtCurrentIndex();
        });
      }

  
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
        File file=File(imagenActual.path);
        widget.controller.addImage(file);
      });

    }
  }


}



class GaleryImage extends StatelessWidget {
 final String? imagePath;
  final String? imageUrl;
  final File? file;

  const GaleryImage({ Key? key, this.imagePath,this.imageUrl,this.file}) : super(key: key);

  bool isNew(){
    return file!=null;
  }
  @override
  Widget build(BuildContext context) {
    return imageUrl==null&&file==null?
    Image(image: AssetImage('images/acuarium.png')):
    imageUrl==null?
    Image.file(file!)    
    :
    CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      );
  }

  


}

class GaleryEditorController{
  List<GaleryImage> _images=[GaleryImage()];
  List<GaleryImage> _deleted=[];
  int _currentIndex=0;
  bool _hasImage=false;

  List<GaleryImage> get getImages => _images;
  List<GaleryImage> get getDeleted => _deleted;
  int get getCurrentIndex => _currentIndex=0;
  bool get hasImages => _hasImage;

  set setImages(List<GaleryImage> i) => _images=i;
  set setIndex(int i)=>_currentIndex=i;
  set setHasImages(bool i)=> _hasImage=i;


  void deleteAtCurrentIndex(){
            GaleryImage gi=_images.removeAt(_currentIndex);
            _deleted.add(gi);
            _currentIndex=0;
            if(_images.length==0){
              _hasImage=false;
              _images.add(GaleryImage());
            }
  }

  void addImage(File file){
        if(!_hasImage){
          _images.removeAt(0);
          _hasImage=true;
        }
        _images.add(GaleryImage(file:file));
  }

    void addImageFromMap(Map<String,dynamic> map){
        if(!_hasImage){
          _images.removeAt(0);
          _hasImage=true;
        }
        _images.add(GaleryImage(imagePath: map['imgPath'],imageUrl: map['imgUrl'],));
  }

  List<File> addedFiles(){
    List<File> l=[];
    _images.forEach((element) { 
      if(element.isNew()){
        l.add(element.file!);
      }
    });
    return l;
  }



  





}