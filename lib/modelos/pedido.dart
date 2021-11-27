import 'package:acuarium/modelos/item_carrito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido{
  static const String PAGO_PENDIENTE='Pago pendiente';
  static const String COMPROBANTE_SUBIDO='Comprobante en revisión';
  static const String PAGO_RECHAZADO='Pago rechazado';
  static const String ENTREGADO='Entregado';
  static const String EN_CAMINO='En camino';
  static const String CANCELADO='Cancelado';
  static const int CLAVE_PAGO_PENDIENTE=0;
  static const int CLAVE_PAGO_RECHAZADO=1;
  static const int CLAVE_ENTREGADO=3;
  static const int CLAVE_EN_CAMINO=2;
  static const int CLAVE_CANCELADO=4;
  static const int CLAVE_COMPROBANTE_SUBIDO=5;
   String _id='';
   String _razon='';
   String _idCliente='';
   String _idDireccion='';
   List<dynamic> _idsNegocios=[];
   List<dynamic> _tags=[];
   Timestamp _fecha=Timestamp.now();
   Timestamp _fechaEntregado=Timestamp.now();
   String _fechaEntrega='';
   int _estado=0;
   Map<String,dynamic> _comprobante={};
   int _productos =0;
   double _total=0.0;

   Pedido();
   String get getId => _id;
   String get getRazon => _razon;
   String get getIdCliente => _idCliente;
   List<dynamic> get getIdNegocios => _idsNegocios;
   List<dynamic> get getTags => _tags;
   Timestamp get getFecha => _fecha;
   Timestamp get getFechaEntregado => _fechaEntregado;
   String get getFechaEntrega => _fechaEntrega;
   int get getEstado => _estado;
   Map<String,dynamic> get getComprobante => _comprobante;
   int get getProductos => _productos;
   double get getTotal => _total;
   String get getIdDireccion => _idDireccion;
   
   setRazon(String i)=>_razon=i;
   setId(String i)=>_id=i;
   setIdCliente(String i) => _idCliente=i;
   setIdNegocios(List<dynamic> i) => _idsNegocios=i;
   setTags(List<dynamic> i) => _tags=i;
   setFecha(Timestamp i) => _fecha=i;
   setFechaEntregado(Timestamp i) => _fechaEntregado=i;
   setEstado(int i) => _estado=i;
   setComprobante(Map<String,dynamic> i) => _comprobante=i;
   setProductos(int i)=> _productos=i;
   setTotal(double d)=>_total=d;
   setIdDireccion(String i)=>_idDireccion=i;
   setFechaEntrega(String i)=>_fechaEntrega=i;

    String  getTextoEstado (){
     switch(_estado){
       case CLAVE_CANCELADO:
        return CANCELADO;
      case CLAVE_ENTREGADO:
        return ENTREGADO;
      case CLAVE_PAGO_RECHAZADO:
        return PAGO_RECHAZADO;
      case CLAVE_EN_CAMINO:
        return EN_CAMINO;
      case CLAVE_PAGO_PENDIENTE:
        return PAGO_PENDIENTE;
      case CLAVE_COMPROBANTE_SUBIDO:
        return COMPROBANTE_SUBIDO;
      default:
        return '';
     }
   }

  bool  tieneEstado (String estado){
    int clave=-1;
     if(estado== CANCELADO.toLowerCase()){
        clave=CLAVE_CANCELADO;
     }else if(estado== ENTREGADO.toLowerCase()){
       clave=CLAVE_ENTREGADO;
     }else if(estado== PAGO_RECHAZADO.toLowerCase()){
       clave=CLAVE_PAGO_RECHAZADO;
     }else if(estado== EN_CAMINO.toLowerCase()){
       clave=CLAVE_EN_CAMINO;
     }else if(estado== PAGO_PENDIENTE.toLowerCase()){
       clave=CLAVE_PAGO_PENDIENTE;
     }     else if(estado== COMPROBANTE_SUBIDO.toLowerCase()){
       clave=CLAVE_COMPROBANTE_SUBIDO;
     }
     return _estado==clave;
   }



    static Map<String, dynamic> toMapFromControl(
    String uid,
    List<String> nid,
    List<String> tags,
    int productos,
    double total,
    String idDireccion
    ){
      Timestamp tmp = Timestamp.now();
        return {
                                'idCliente':uid,
                                'idNegocios':nid,
                                'fecha':tmp,
                                'fechaEntrega':'',
                                'fechaEntregado':tmp,
                                'estado':CLAVE_PAGO_PENDIENTE,
                                'comprobante':{
                                  'imgUrl':'',
                                  'imgPath':''
                                },
                                'razon':'',
                                'tags':tags,
                                'productos':productos,
                                'total':total,
                                'idDireccion':idDireccion
                              };
  } 
  Pedido.fromSnapshot(DocumentSnapshot obj){
    this._id=obj.id;
    this._idCliente=obj.get('idCliente');
    this._idsNegocios=obj.get('idNegocios');
    this._fecha=obj.get('fecha');
    this._fechaEntrega=obj.get('fechaEntrega');
    this._fechaEntregado=obj.get('fechaEntregado');
    this._estado=obj.get('estado');
    this._comprobante=obj.get('comprobante');
    this._total=obj.get('total');
    this._productos=obj.get('productos');
    this._idDireccion=obj.get('idDireccion');
    this._tags=obj.get('tags');
    this._razon=obj.get('razon');
  }
   

   
      


}

class ItemPedido{
  String _id='';
  String _idPez='';
  String _idNegocio='';  
  int    _cantidad=0;
  double _precio=0.0;
  String _imgUrl='';
  String _nombre='';
  String _descripcion='';

  ItemPedido();

  String get getId => _id;
  String get getIdPez => _idPez;
  String get getIdNegocio =>_idNegocio;
  int get getCantidad => _cantidad;
  double get getPrecio => _precio;
  String get getImgUrl => _imgUrl;
   String get getNombre => _nombre;
   String get getDescripcion => _descripcion;

  set setId(String i)=>_id=i;
  set setNombre(String i)=>_nombre=i;
  set setIdPez(String i)=>_idPez=i;
  set setIdNegocio(String  n)=>_idNegocio=n;
  set setCantidad(int n)=>_cantidad=n;
  set setPrecio(double c)=>_precio=c;
  set setImgUrl(String m)=>_imgUrl=m;
  set setDescripcion(String m)=>_descripcion=m;
  
  static Map<String, dynamic> toMapFromControl(
    String nombre,
    String uid,
    String fid,
    String nid,
    String imgUrl,
    String descripcion,
    int cantidad,
    double precio,){
        return {
                                'nombre':nombre,
                                'idPez':fid,
                                'descripcion':descripcion,
                                'idNegocio':nid,
                                'cantidad':cantidad,
                                'precio':precio,
                                'imgUrl':imgUrl
                              };
  } 

    ItemPedido.fromSnapshot(DocumentSnapshot obj){
    this._id=obj.id;
    this._nombre=obj.get('nombre');
    this._idPez=obj.get('idPez');
    this._idNegocio=obj.get('idNegocio');
    this._cantidad=obj.get('cantidad');
    this._precio=obj.get('precio');
    this._imgUrl=obj.get('imgUrl');
    this._descripcion=obj.get('descripcion');
  }

  static Map<String, dynamic> MapfromItemCarrito(ItemCarrito item){
                return {
                                'nombre':item.getNombre,
                                'idPez':item.getIdPez,
                                'descripcion':item.getDescripcion,
                                'idNegocio':item.getIdNegocio,
                                'cantidad':item.getCantidad,
                                'precio':item.getPrecio,
                                'imgUrl':item.getImgUrl
                              };
  }


}