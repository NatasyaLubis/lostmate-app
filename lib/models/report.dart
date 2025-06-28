class Report {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final DateTime date;
  final String category;
  final String phone;
  final String userName;
  final String email;
  final bool isFound; 

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.date,
    required this.category,
    required this.phone,
    required this.userName,
    required this.email,
    this.isFound = false,
  });

  // Method copyWith untuk update sebagian atribut
  Report copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? imageUrl,
    DateTime? date,
    String? category,
    String? phone,
    String? userName,
    String? email,
    bool? isFound,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      isFound: isFound ?? this.isFound,
    );
  }

  // Serialize objek ke JSON map
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'imageUrl': imageUrl,
    'date': date.toIso8601String(),
    'category': category,
    'phone': phone,
    'userName': userName,
    'email': email,
    'isFound': isFound,
  };

  // Deserialize JSON map ke objek Report
  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    imageUrl: json['imageUrl'],
    date: DateTime.parse(json['date']),
    category: json['category'],
    phone: json['phone'],
    userName: json['userName'],
    email: json['email'],
    isFound: json['isFound'] ?? false,
  );
}
