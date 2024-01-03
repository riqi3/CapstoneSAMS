class Patient {
  final String patientId;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final int age;
  final String gender;
  final DateTime birthDate;
  // final String department;
  final String course;
  final int yrLevel;
  final String studNumber;
  final String address;
  final double height;
  final double weight;
  // final DateTime registration;
  final String phone;
  final String email;
  final int assignedPhysician;

  Patient({
    required this.patientId,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.birthDate,
    // required this.department,
    required this.course,
    required this.yrLevel,
    required this.studNumber,
    required this.address,
    required this.height,
    required this.weight,
    // required this.registration,
    required this.phone,
    required this.email,
    required this.assignedPhysician,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'firstName': firstName,
      'middleInitial': middleInitial,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      // 'department': department,
      'course': course,
      'yrLevel': yrLevel,
      'studNumber': studNumber,
      'address': address,
      'height': height,
      'weight': weight,
      // 'registration': registration.toIso8601String(),
      'phone': phone,
      'email': email,
      'assignedPhysician': assignedPhysician,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patientID'].toString(),
      firstName: json['firstName'],
      middleInitial: json['middleInitial'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
      // department: json['department'],
      course: json['course'],
      yrLevel: json['yrLevel'],
      studNumber: json['studNumber'],
      address: json['address'],
      height: json['height'],
      weight: json['weight'],
      // registration: DateTime.parse(json['registration']),
      phone: json['phone'],
      email: json['email'],
      assignedPhysician: json['assignedPhysician'],
    );
  }
}
