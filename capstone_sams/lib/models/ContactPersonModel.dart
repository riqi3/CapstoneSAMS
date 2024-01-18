class ContactPerson {
   String? contactId;
   String? fullName;
   String? phone;
   String? address;
   String? patient;

  ContactPerson({
     this.contactId,
     this.fullName,
     this.phone,
     this.address,
     this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'contactId': contactId,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'patient': patient,
    };
  }

  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
      contactId: json['contactId'].toString(),
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      patient: json['patient'].toString(),
    );
  }
}
