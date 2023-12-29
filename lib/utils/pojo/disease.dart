// To parse this JSON data, do
//
//     final disease = diseaseFromJson(jsonString);

import 'dart:convert';

Disease diseaseFromJson(String str) => Disease.fromJson(json.decode(str));

String diseaseToJson(Disease data) => json.encode(data.toJson());

class Disease {
  String diseaseCode;
  String diseaseName;
  String diseaseType;
  String symptoms;
  List<String> description;
  List<String> measures;
  Suggestions suggestions;

  Disease({
    required this.diseaseCode,
    required this.diseaseName,
    required this.diseaseType,
    required this.symptoms,
    required this.description,
    required this.measures,
    required this.suggestions,
  });

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
    diseaseCode: json["diseaseCode"],
    diseaseName: json["diseaseName"],
    diseaseType: json["diseaseType"],
    symptoms: json["symptoms"],
    description: List<String>.from(json["description"].map((x) => x)),
    measures: List<String>.from(json["measures"].map((x) => x)),
    suggestions: Suggestions.fromJson(json["suggestions"]),
  );

  Map<String, dynamic> toJson() => {
    "diseaseCode": diseaseCode,
    "diseaseName": diseaseName,
    "diseaseType": diseaseType,
    "symptoms": symptoms,
    "description": List<dynamic>.from(description.map((x) => x)),
    "measures": List<dynamic>.from(measures.map((x) => x)),
    "suggestions": suggestions.toJson(),
  };
}

class Suggestions {
  List<Commercial> commercial;
  List<Household> household;

  Suggestions({
    required this.commercial,
    required this.household,
  });

  factory Suggestions.fromJson(Map<String, dynamic> json) => Suggestions(
    commercial: List<Commercial>.from(json["commercial"].map((x) => Commercial.fromJson(x))),
    household: List<Household>.from(json["household"].map((x) => Household.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "commercial": List<dynamic>.from(commercial.map((x) => x.toJson())),
    "household": List<dynamic>.from(household.map((x) => x.toJson())),
  };
}

class Commercial {
  String image;
  String title;
  String link;

  Commercial({
    required this.image,
    required this.title,
    required this.link,
  });

  factory Commercial.fromJson(Map<String, dynamic> json) => Commercial(
    image: json["image"],
    title: json["title"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "link": link,
  };
}

class Household {
  String image;
  String text;

  Household({
    required this.image,
    required this.text,
  });

  factory Household.fromJson(Map<String, dynamic> json) => Household(
    image: json["image"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "text": text,
  };
}
