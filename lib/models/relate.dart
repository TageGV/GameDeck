class Relate {
  int? yourRelate;

  Relate({this.yourRelate});

  Relate.fromJson(Map<String, dynamic> json) {
    yourRelate = json['your_relate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['your_relate'] = yourRelate;
    return data;
  }
}
