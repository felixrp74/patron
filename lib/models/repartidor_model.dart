//User Model
class RepartidorModel {
  String repartidorCelular;

  RepartidorModel({this.repartidorCelular});

  factory RepartidorModel.fromMap(Map data) {
    return RepartidorModel(
      repartidorCelular: data['repartidorCelular'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() => {
    "repatidorName": repartidorCelular,
  };
}