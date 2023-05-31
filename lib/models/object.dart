class CustomObject {
  final String type;
  final String state;
  final String degree;
  final String price;
  final String surface;

  CustomObject(
      {required this.degree,
      required this.price,
      required this.type,
      required this.surface,
      required this.state});
}

List<CustomObject> objects = [
  CustomObject(
    type: "Wall",
    state: "Good State",
    surface: "/",
    degree: "/",
    price: "/",
  ),
  CustomObject(
    type: "Wall",
    state: "Broken",
    surface: "10%",
    degree: "7%",
    price: "300-700 Euro",
  ),
];
