class PromoCodeModel {
  String? promoCodeId;
  String? code;
  int? usersUsedTimes;
  int? useLimit;
  int? createdAt;

  PromoCodeModel({
    this.createdAt,
    this.code,
    this.promoCodeId,
    this.useLimit,
    this.usersUsedTimes,
  });

  PromoCodeModel.fromJson(Map<String, dynamic> json) {
    promoCodeId = json['promoCodeId'];
    code = json['code'];
    usersUsedTimes = json['usersUsedTimes'];
    useLimit = json['useLimit'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promoCodeId'] = promoCodeId;
    data['code'] = code;
    data['usersUsedTimes'] = usersUsedTimes;
    data['useLimit'] = useLimit;
    data['createdAt'] = createdAt;

    return data;
  }
}
