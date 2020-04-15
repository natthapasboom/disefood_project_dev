class Food{
  static const String InStock = 'Instock';
  static const String OutOfStock = 'OutofStock';

  String foodName = '';
  String  price ;

  Map<String, bool> status = {
    InStock: false,
    OutOfStock: false,
  };




  save(){
    print('add menu finish');
  }

}