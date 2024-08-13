class MyOrderData{
  final String? image;
  final String? name;
  final double? price;
  final int? id;
  final String? detailImage;
  final String? date;
  String? orderPosition;
  List? plantimages;
  int quntity;
  bool initialvalue;

  MyOrderData({this.date, this.orderPosition,this.image, this.name, this.price, this.id,required this.initialvalue,required this.quntity,this.detailImage,this.plantimages});
}