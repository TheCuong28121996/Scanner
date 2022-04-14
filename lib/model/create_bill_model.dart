class CreateBillModel {
  List<Nid>? nid;
  List<CreateTime>? createTime;
  List<TitleModel>? title;
  List<BodyModel>? body;

  CreateBillModel({this.nid, this.createTime, this.title, this.body});

  factory CreateBillModel.fromJson(Map<dynamic, dynamic> json) {
    return CreateBillModel(
      nid: (json['nid'] != null)
          ? List<Nid>.from(json['nid'].map((x) => Nid.fromJson(x)))
          : null,
      createTime: (json['created'] != null)
          ? List<CreateTime>.from(
              json['created'].map((x) => CreateTime.fromJson(x)))
          : null,
      title: (json['title'] != null)
          ? List<TitleModel>.from(
              json['title'].map((x) => TitleModel.fromJson(x)))
          : null,
      body: (json['body'] != null)
          ? List<BodyModel>.from(json['body'].map((x) => BodyModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'nid': nid?.map((e) => e.toJson()).toList(),
        'created': createTime?.map((e) => e.toJson()).toList(),
        'title': title?.map((e) => e.toJson()).toList(),
        'body': body?.map((e) => e.toJson()).toList(),
      };
}

class Nid {
  int? value;

  Nid({this.value});

  factory Nid.fromJson(Map<String, dynamic> json) {
    return Nid(
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
      };
}

class CreateTime {
  String? value;
  String? format;

  CreateTime({this.value, this.format});

  factory CreateTime.fromJson(Map<String, dynamic> json) {
    return CreateTime(
      value: json['value'],
      format: json['format'],
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'format': format,
      };
}

class TitleModel {
  String? value;

  TitleModel({this.value});

  factory TitleModel.fromJson(Map<String, dynamic> json) {
    return TitleModel(
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
      };
}

class BodyModel {
  String? value;
  String? processed;

  BodyModel({this.value, this.processed});

  factory BodyModel.fromJson(Map<String, dynamic> json) {
    return BodyModel(
      value: json['value'],
      processed: json['processed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'processed': processed,
      };
}
