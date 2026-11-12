/// Model data untuk merepresentasikan profil mahasiswa.
class Student {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Membuat salinan objek Student dengan nilai yang diperbarui.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'nim': nim,
    'programStudi': programStudi,
    'email': email,
  };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    name: json['name'] ?? '',
    nim: json['nim'] ?? '',
    programStudi: json['programStudi'] ?? '',
    email: json['email'] ?? '',
  );
}
