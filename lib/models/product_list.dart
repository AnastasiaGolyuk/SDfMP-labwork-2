class ProductList{
  final int id;
  final String listJson;

  ProductList({required this.id, required this.listJson});

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    id: json["id"],
    listJson: json["listJson"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listJson": listJson,
  };
}