import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final Map<String, dynamic>? location;
  final bool isProfileCompleted;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
    this.createdAt,
    this.location,
    this.isProfileCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'location': location,
      'isProfileCompleted': isProfileCompleted,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      location: map['location'],
      isProfileCompleted: map['isProfileCompleted'] ?? false,
    );
  }

  UserModel copyWith({
    String? uid,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    Map<String, dynamic>? location,
    bool? isProfileCompleted,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
    );
  }
}
