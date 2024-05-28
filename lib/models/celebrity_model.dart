class CelebrityModel {
  String? userID;
  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? bio;
  int? createdAt;
  String? phoneVerificationId;
  int? updatedAt;
  String? status;
  String? profilePicture;
  String? backgroundPicture;
  String? category;
  bool? favorite;
  bool? supportYourStar;

  CelebrityModel({
    this.userID,
    this.name,
    this.email,
    this.phoneNumber,
    this.password,
    this.bio,
    this.category,
    this.createdAt,
    this.phoneVerificationId,
    this.supportYourStar,
    this.favorite,
    this.updatedAt,
    this.status,
    this.profilePicture,
    this.backgroundPicture,
  });

  CelebrityModel.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    name = json['name'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    password = json['Password'];
    category = json['category'];
    bio = json['bio'];
    supportYourStar = json['supportYourStar'];
    createdAt = json['CreatedAt'];
    phoneVerificationId = json['PhoneVerificationId'];
    favorite = json['favorite'];
    updatedAt = json['UpdatedAt'];
    status = json['Status'];
    profilePicture = json['profilePicture'];
    backgroundPicture = json['backgroundPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['name'] = name;
    data['Email'] = email;
    data['PhoneNumber'] = phoneNumber;
    data['bio'] = bio;
    data['supportYourStar'] = supportYourStar;
    data['Password'] = password;
    data['category'] = category;
    data['CreatedAt'] = createdAt;
    data['PhoneVerificationId'] = phoneVerificationId;
    data['favorite'] = favorite;
    data['UpdatedAt'] = updatedAt;
    data['Status'] = status;
    data['profilePicture'] = profilePicture;
    data['backgroundPicture'] = backgroundPicture;

    return data;
  }
}
