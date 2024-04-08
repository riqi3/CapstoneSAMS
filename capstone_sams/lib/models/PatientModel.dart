class Patient {
  String? patientID;
  String? firstName;
  String? middleInitial;
  String? lastName;
  int? age;
  String? gender;
  String? patientStatus;
  String? birthDate;
  String? department;
  int? yrLevel;
  String? studNumber;
  String? address;
  double? height;
  double? weight;
  String? phone;
  String? email;
  // int? assignedPhysician;

  Patient({
    this.patientID,
    this.firstName,
    this.middleInitial,
    this.lastName,
    this.age,
    this.gender,
    this.patientStatus,
    this.birthDate,
    this.department,
    this.yrLevel,
    this.studNumber,
    this.address,
    this.height,
    this.weight,
    this.phone,
    this.email,
    // this.assignedPhysician,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientID': patientID,
      'firstName': firstName,
      'middleInitial': middleInitial,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'patientStatus': patientStatus,
      'birthDate': birthDate.toString(),
      // 'department': department,
      'department': department,
      'yrLevel': yrLevel,
      'studNumber': studNumber,
      'address': address,
      'height': height,
      'weight': weight,
      // 'registration': registration.toIso8601String(),
      'phone': phone,
      'email': email,
      // 'assignedPhysician': assignedPhysician,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientID: json['patientID'].toString(),
      firstName: json['firstName'],
      middleInitial: json['middleInitial'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      patientStatus: json['patientStatus'],
      birthDate: json['birthDate'],
      department: json['department'],
      yrLevel: json['yrLevel'],
      studNumber: json['studNumber'],
      address: json['address'],
      height: json['height'],
      weight: json['weight'],
      phone: json['phone'],
      email: json['email'],
      // assignedPhysician: json['assignedPhysician'],
    );
  }
}
