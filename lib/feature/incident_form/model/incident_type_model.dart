class IncidentTypeModel {
  String id;
  String name;

  IncidentTypeModel({required this.id, required this.name});

  factory IncidentTypeModel.fromJson(Map<String, dynamic> json) =>
      IncidentTypeModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  static List<IncidentTypeModel> listFromJson(Object data) {
    if ((data as List).isEmpty) {
      return [];
    } else {
      return (data).map((e) => IncidentTypeModel.fromJson(e)).toList();
    }
  }
}
