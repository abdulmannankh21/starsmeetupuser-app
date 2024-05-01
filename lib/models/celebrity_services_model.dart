class CelebrityServicesModel {
  String id;
  String title;
  String durationMinutes;
  String price;
  int timestamp;

  CelebrityServicesModel({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.price,
    required this.durationMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'price': price,
      'timestamp': timestamp,
    };
  }

  factory CelebrityServicesModel.fromMap(String id, Map<String, dynamic> map) {
    return CelebrityServicesModel(
      id: map['id'],
      title: map['title'],
      durationMinutes: map['durationMinutes'],
      price: map['price'],
      timestamp: map['timestamp'],
    );
  }
}
