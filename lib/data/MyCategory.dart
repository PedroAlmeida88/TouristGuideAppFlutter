class MyCategory {
  final String name;
  final String description;
  final String icon;

  MyCategory(this.name, this.description, this.icon);

  MyCategory.fromJson (Map<String, dynamic> json) :
      name = json['name'],
      description = json['description'],
      icon = json['icon'];

  static Map<String, dynamic> toJson (MyCategory category) => {
      'name' : category.name,
      'description' : category.description,
      'icon' : category.icon,
  };
}

