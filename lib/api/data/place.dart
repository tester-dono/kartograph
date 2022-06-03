/// класс места на картах и в списке
class Place {

  /// id места на сервере
  int id;

  /// широта места
  double lat;

  /// долгота места
  double lng;

  /// название места
  String name;

  /// urls картинок места
  List<String> urls;

  String placeType;

  String description;

  /// полный конструктор места
  Place({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
    required this.urls,
    required this.placeType,
    required this.description,
  });
}
