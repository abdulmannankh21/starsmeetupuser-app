class UserModel {
  String? userID;
  String? name;
  String? email;
  String? bio;
  String? phoneNumber;
  String? password;
  int? createdAt;
  int? updatedAt;
  String? status;
  String? profilePicture;
  String? backgroundPicture;

  UserModel({
    this.userID,
    this.name,
    this.email,
    this.phoneNumber,
    this.password,
    this.bio,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.profilePicture,
    this.backgroundPicture,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    name = json['name'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    bio = json['bio'];
    password = json['Password'];
    createdAt = json['CreatedAt'];
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
    data['Password'] = password;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    data['Status'] = status;
    data['bio'] = bio;
    data['profilePicture'] = profilePicture;
    data['backgroundPicture'] = backgroundPicture;

    return data;
  }
}
