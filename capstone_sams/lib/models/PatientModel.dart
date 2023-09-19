class Patient {
  final String patientId;
  final String firstName;
  String? middleName;
  final String lastName;
  final int age;
  final String gender;
  final DateTime birthDate;
  final DateTime registration;
  String? phone;
  String? email;

  Patient(
      {required this.patientId,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.age,
      required this.gender,
      required this.birthDate,
      required this.registration,
      this.phone,
      this.email});

   

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'registration': registration.toIso8601String(),
      'phone': phone,
      'email': email,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patientID'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
      registration: DateTime.parse(json['registration']),
      phone: json['phone'],
      email: json['email'],
    );
  }
}
