// To parse this JSON data, do
//
//     final recipeResultResponse = recipeResultResponseFromJson(jsonString);

import 'dart:convert';

List<RecipeItem> recipeResultResponseFromJson(String str) =>
    List<RecipeItem>.from(json.decode(str).map((x) => RecipeItem.fromJson(x)));

String recipeResultResponseToJson(List<RecipeItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecipeItem {
  int? id;
  String? title;
  String? image;
  String? imageType;
  int? usedIngredientCount;
  int? missedIngredientCount;
  List<SedIngredient>? missedIngredients;
  List<SedIngredient>? usedIngredients;
  List<dynamic>? unusedIngredients;
  int? likes;

  RecipeItem({
    this.id,
    this.title,
    this.image,
    this.imageType,
    this.usedIngredientCount,
    this.missedIngredientCount,
    this.missedIngredients,
    this.usedIngredients,
    this.unusedIngredients,
    this.likes,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) => RecipeItem(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    imageType: json["imageType"],
    usedIngredientCount: json["usedIngredientCount"],
    missedIngredientCount: json["missedIngredientCount"],
    missedIngredients:
        json["missedIngredients"] == null
            ? []
            : List<SedIngredient>.from(
              json["missedIngredients"]!.map((x) => SedIngredient.fromJson(x)),
            ),
    usedIngredients:
        json["usedIngredients"] == null
            ? []
            : List<SedIngredient>.from(
              json["usedIngredients"]!.map((x) => SedIngredient.fromJson(x)),
            ),
    unusedIngredients:
        json["unusedIngredients"] == null
            ? []
            : List<dynamic>.from(json["unusedIngredients"]!.map((x) => x)),
    likes: json["likes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "imageType": imageType,
    "usedIngredientCount": usedIngredientCount,
    "missedIngredientCount": missedIngredientCount,
    "missedIngredients":
        missedIngredients == null
            ? []
            : List<dynamic>.from(missedIngredients!.map((x) => x.toJson())),
    "usedIngredients":
        usedIngredients == null
            ? []
            : List<dynamic>.from(usedIngredients!.map((x) => x.toJson())),
    "unusedIngredients":
        unusedIngredients == null
            ? []
            : List<dynamic>.from(unusedIngredients!.map((x) => x)),
    "likes": likes,
  };
}

class SedIngredient {
  int? id;
  double? amount;
  String? unit;
  String? unitLong;
  String? unitShort;
  String? aisle;
  String? name;
  String? original;
  String? originalName;
  List<String>? meta;
  String? image;
  String? extendedName;

  SedIngredient({
    this.id,
    this.amount,
    this.unit,
    this.unitLong,
    this.unitShort,
    this.aisle,
    this.name,
    this.original,
    this.originalName,
    this.meta,
    this.image,
    this.extendedName,
  });

  factory SedIngredient.fromJson(Map<String, dynamic> json) => SedIngredient(
    id: json["id"],
    amount: json["amount"]?.toDouble(),
    unit: json["unit"],
    unitLong: json["unitLong"],
    unitShort: json["unitShort"],
    aisle: json["aisle"],
    name: json["name"],
    original: json["original"],
    originalName: json["originalName"],
    meta:
        json["meta"] == null
            ? []
            : List<String>.from(json["meta"]!.map((x) => x)),
    image: json["image"],
    extendedName: json["extendedName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "unit": unit,
    "unitLong": unitLong,
    "unitShort": unitShort,
    "aisle": aisle,
    "name": name,
    "original": original,
    "originalName": originalName,
    "meta": meta == null ? [] : List<dynamic>.from(meta!.map((x) => x)),
    "image": image,
    "extendedName": extendedName,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecipeItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
