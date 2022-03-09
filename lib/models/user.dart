class User {
  String modulo = '';
  String firstName = '';
  String lastName = '';
  String document = '';
  String imageId = '';
  String imageFullPath = '';
  int userType = 0;
  String fullName = '';
  String id = '';
  String userName = '';
  String email = '';

  User({
    required this.modulo,
    required this.firstName,
    required this.lastName,
    required this.document,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.fullName,
    required this.id,
    required this.userName,
    required this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
    modulo = json['modulo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    document = json['document'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    fullName = json['fullName'];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modulo'] = this.modulo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['document'] = this.document;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    return data;
  }
}
