class usermodel {
  String? uid;
  String? email;
  String? name;

  usermodel({this.email, this.name, this.uid});

  factory usermodel.fromMap(map) {
    return usermodel(uid: map('uid'), email: map('email'), name: map('name'));
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
