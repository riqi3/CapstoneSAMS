class Patient {
  String name;
  String id;
  String age;
  String sex;
  DateTime? birthdate;
  DateTime? datereg;

  Patient({
    required this.name,
    this.id = '',
    this.age = '',
    this.sex = '',
    this.birthdate,
    this.datereg,
  });
}
