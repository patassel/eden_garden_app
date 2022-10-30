

class UserDB {

  late  String fullName;
  late  String phone;
  late  String email;
  late  String password;
  late  String pseudo;

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

  void fromJson(Map<String, dynamic> js) {

    fullName = js['fullName'];
    email = js['email'];
    pseudo = js['pseudo'];
    phone = js['phone'];
    password = js['password'];


  }



}