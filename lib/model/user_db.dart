

class UserDB {

  late  String fullName;
  late  String phone;
  late  String email;
  late  String password;
  late  String pseudo;

  late String id;

  UserDB({required this.id, required this.fullName, this.phone = "phone",  this.pseudo = "pseudo", this.email = "email", this.password = "password"});


  void setID(String newID){
    id = newID;
  }

  void setName(String newFullName){
    fullName = newFullName;
  }

  void setPhone(String newPhone){
    phone = newPhone;
  }

  void setPseudo(String newPs){
    pseudo = newPs;
  }

  void setEmail(String newEmail){
    email = newEmail;
  }

  void setPassword(String newPassword){
    password = newPassword;
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