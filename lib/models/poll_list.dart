class PollList {
  final int number;
  final String title;
  final String firstname;
  final String lastname;

  PollList({
    required this.number,
    required this.title,
    required this.firstname,
    required this.lastname,
  });

  factory PollList.fromJson(Map<String, dynamic> json) {
    return PollList(
      number: json['number'],
      title: json['title'],
      firstname: json['firstName'],
      lastname: json['lastName'],
    );
  }

  PollList.fromJson2(Map<String, dynamic> json)
      : number = json['number'],
        title = json['title'],
        firstname = json['firstName'],
        lastname = json['lastName'];

  @override
  String toString() {
    return '$title$firstname $lastname';
  }
}
