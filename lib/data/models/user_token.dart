class UserToken {
  String uid;
  List<String> tokens;

  UserToken({
    required this.uid,
    required this.tokens,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) {
    return UserToken(
      uid: json['uid'],
      tokens: json['tokens'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'tokens': tokens,
    };
  }
}
