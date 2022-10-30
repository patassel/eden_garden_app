

class UserDB {

  late final String fullName;
  late final String phone;
  late final String email;
  late final String password;
  late final String pseudo;


  //
  // late final ImageProvider image;

  UserDB({required this.fullName, this.phone = "phone",  this.pseudo = "pseudo", this.email = "email", this.password = "password"});


  void setTitle(String _fullName){
    fullName = _fullName;
  }

  Map<String, dynamic> returnJson()  {

    final ret = <String, dynamic>{
      "fullName": fullName,
      "phone": phone,
      "pseudo": pseudo,
      "email": email,
      "password": password,
    };
    return ret;
  }



}