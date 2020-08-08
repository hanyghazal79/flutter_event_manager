



class User {
  int _id;
  String _name;
  String _email;
  String _password;
  var _imageUrl;

  User(this._id, this._name, this._email, this._password, this._imageUrl);
  //
  int getId() => _id;
  String getName() => _name;
  String getEmail() => _email;
  String getPassword() => _password;

  dynamic getImageUrl() => _imageUrl;
  //
  void setName(String name){
    this._name = name;
  }
  void setEmail(String email){
    this._email = email;
  }
  void setPassword(String password){
    this._password = password;
  }
  void setImageUrl(Uri imageUrl){
    this._imageUrl = imageUrl;
  }

}