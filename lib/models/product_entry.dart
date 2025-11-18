import 'dart:convert';

ProductEntry productEntryFromJson(String str) =>
    ProductEntry.fromJson(json.decode(str));

String productEntryToJson(ProductEntry data) => json.encode(data.toJson());

class ProductEntry {
  String id;
  int userId;
  String userName;
  String name;
  int price;
  String descriptions;
  DateTime date;
  int itemViews;
  String thumbnail;
  String category;
  bool isFeatured;
  bool isProductTrending;

  ProductEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.name,
    required this.price,
    required this.descriptions,
    required this.date,
    required this.itemViews,
    required this.thumbnail,
    required this.category,
    required this.isFeatured,
    required this.isProductTrending,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
    id: json["id"],
    userId: json["user_id"],
    userName: json["user_name"],
    name: json["name"],
    price: json["price"],
    descriptions: json["descriptions"],
    date: DateTime.parse(json["date"]),
    itemViews: json["item_views"],
    thumbnail: json["thumbnail"],
    category: json["category"],
    isFeatured: json["is_featured"],
    isProductTrending: json["is_product_trending"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user_name": userName,
    "name": name,
    "price": price,
    "descriptions": descriptions,
    "date": date.toIso8601String(),
    "item_views": itemViews,
    "thumbnail": thumbnail,
    "category": category,
    "is_featured": isFeatured,
    "is_product_trending": isProductTrending,
  };
}
