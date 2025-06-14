// user_model.dart
class User {
  String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;
  String? photoUrl; // TAMBAHAN: Field untuk URL foto profil

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.photoUrl, // TAMBAHAN: Inisialisasi di constructor
  });

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      photoUrl: data['photoUrl'], // TAMBAHAN: Ambil dari Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl, // TAMBAHAN: Simpan ke Firestore
    };
  }

  // TAMBAHAN: Method copyWith untuk memudahkan update sebagian field
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}