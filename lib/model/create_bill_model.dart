class CreateBillModel {
  List<Nid>? nid;

  CreateBillModel(
      {this.nid});

  factory CreateBillModel.fromJson(Map<String, dynamic> json) {
    return CreateBillModel(
      nid: (json['nid'] != null)
          ? List<Nid>.from(
          json['nid'].map((x) => Nid.fromJson(x)))
          : null,
    );
  }
}

class Nid {
  int? value;

  Nid({this.value});

  factory Nid.fromJson(Map<String, dynamic> json) {
    return Nid(
      value: json['value'],
    );
  }
}