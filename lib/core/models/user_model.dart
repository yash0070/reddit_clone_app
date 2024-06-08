/// name : ""
/// profilePic : ""
/// banner : ""
/// uid : ""
/// isAuthenticated : false
/// karma : ""
/// awards : ["A","b"]

class UserModel {
  UserModel({
      String? name, 
      String? profilePic, 
      String? banner, 
      String? uid, 
      bool? isAuthenticated, 
      int? karma,
      List<String>? awards,}){
    _name = name;
    _profilePic = profilePic;
    _banner = banner;
    _uid = uid;
    _isAuthenticated = isAuthenticated;
    _karma = karma;
    _awards = awards;
}

  UserModel.fromJson(dynamic json) {
    _name = json['name'];
    _profilePic = json['profilePic'];
    _banner = json['banner'];
    _uid = json['uid'];
    _isAuthenticated = json['isAuthenticated'];
    _karma = json['karma'];
    _awards = json['awards'] != null ? json['awards'].cast<String>() : [];
  }
  UserModel.fromMap(Map<String,dynamic> map) {
    _name = map['name'];
    _profilePic = map['profilePic'];
    _banner = map['banner'];
    _uid = map['uid'];
    _isAuthenticated = map['isAuthenticated'];
    _karma = map['karma'];
    _awards = map['awards'] != null ? map['awards'].cast<String>() : [];
  }
  String? _name;
  String? _profilePic;
  String? _banner;
  String? _uid;
  bool? _isAuthenticated;
  int? _karma;
  List<String>? _awards;
UserModel copyWith({  String? name,
  String? profilePic,
  String? banner,
  String? uid,
  bool? isAuthenticated,
  int? karma,
  List<String>? awards,
}) => UserModel(  name: name ?? _name,
  profilePic: profilePic ?? _profilePic,
  banner: banner ?? _banner,
  uid: uid ?? _uid,
  isAuthenticated: isAuthenticated ?? _isAuthenticated,
  karma: karma ?? _karma,
  awards: awards ?? _awards,
);
  String? get name => _name;
  String? get profilePic => _profilePic;
  String? get banner => _banner;
  String? get uid => _uid;
  bool? get isAuthenticated => _isAuthenticated;
  int? get karma => _karma;
  List<String>? get awards => _awards;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['profilePic'] = _profilePic;
    map['banner'] = _banner;
    map['uid'] = _uid;
    map['isAuthenticated'] = _isAuthenticated;
    map['karma'] = _karma;
    map['awards'] = _awards;
    return map;
  }

}