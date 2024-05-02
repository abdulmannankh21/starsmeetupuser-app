class AppointmentModel {
  String? serviceDuration;
  String? serviceName;
  String? servicePrice;
  String? celebrityName;
  String? celebrityId;
  String? celebrityImage;
  String? userId;
  String? userName;
  DateTime? creationTimestamp;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? selectedDate;
  String? promoCode;
  String? timeSlotId;
  String? timeSlot;
  double? supportYourStarCharges;
  String? paymentMethod;

  AppointmentModel({
    this.serviceDuration,
    this.serviceName,
    this.servicePrice,
    this.celebrityImage,
    this.timeSlotId,
    this.timeSlot,
    this.celebrityName,
    this.celebrityId,
    this.userId,
    this.userName,
    this.creationTimestamp,
    this.startTime,
    this.endTime,
    this.selectedDate,
    this.promoCode,
    this.supportYourStarCharges,
    this.paymentMethod,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      serviceDuration: json['serviceTitle'],
      serviceName: json['serviceName'],
      servicePrice: json['servicePrice'],
      celebrityName: json['celebrityName'],
      celebrityId: json['celebrityId'],
      celebrityImage: json['celebrityImage'],
      timeSlotId: json['timeSlotId'],
      timeSlot: json['timeSlot'],
      userId: json['userId'],
      userName: json['userName'],
      creationTimestamp: json['creationTimestamp'] != null
          ? DateTime.parse(json['creationTimestamp'])
          : null,
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      selectedDate: json['selectedDate'] != null
          ? DateTime.parse(json['selectedDate'])
          : null,
      promoCode: json['promoCode'],
      supportYourStarCharges: json['supportYourStarCharges']?.toDouble(),
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceTitle': serviceDuration,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'celebrityName': celebrityName,
      'celebrityId': celebrityId,
      'timeSlotId': timeSlotId,
      'timeSlot': timeSlot,
      'celebrityImage': celebrityImage,
      'userId': userId,
      'userName': userName,
      'creationTimestamp': creationTimestamp?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'selectedDate': selectedDate?.toIso8601String(),
      'promoCode': promoCode,
      'supportYourStarCharges': supportYourStarCharges,
      'paymentMethod': paymentMethod,
    };
  }
}
