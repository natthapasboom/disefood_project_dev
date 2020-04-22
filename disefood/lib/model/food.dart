class Food{
  static const String InStock = 'Instock';
  static const String OutOfStock = 'OutofStock';

  String foodName = '';
  int  price ;

  Map<String, bool> status = {
    InStock: false,
    OutOfStock: false,
  };




  save(){
    print('add menu finish');
  }

}