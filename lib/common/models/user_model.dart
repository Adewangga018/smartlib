class User {
  String id; // Tambahkan ini
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;

  User({
    required this.id, // Tambahkan ini
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  // Tambahkan factory constructor untuk membuat objek User dari dokumen Firestore
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  // Tambahkan method toFirestore untuk mengubah objek User menjadi Map<String, dynamic>
  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}