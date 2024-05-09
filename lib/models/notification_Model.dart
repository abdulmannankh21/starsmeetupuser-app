class NotificationModel {
  String? serviceName;
  String? celebrityName;
  String? userId;
  String? userName;
  DateTime? creationTimestamp;

  String? status;
  NotificationModel(
      {this.serviceName,
      this.celebrityName,
      this.userId,
      this.userName,
      this.creationTimestamp,
      this.status});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      serviceName: json['serviceName'],
      celebrityName: json['celebrityName'],
      userId: json['userId'],
      userName: json['userName'],
      creationTimestamp: json['creationTimestamp'] != null
          ? DateTime.parse(json['creationTimestamp'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'celebrityName': celebrityName,
      'userId': userId,
      'userName': userName,
      'creationTimestamp': creationTimestamp?.toIso8601String(),
      "status": status
    };
  }
}
