import 'package:app/Models/user.dart';

class Utilisateur extends User {
    List<String> requests;

    Utilisateur(String userId, String firstName, String lastName, String tel, {List<String> requests})
    : requests = requests ?? new List(),
    super(userId, firstName, lastName, tel);

    factory Utilisateur.fromJson(Map<String, dynamic> json) {
        return Utilisateur(
            json['userId'],
            json['firstName'],
            json['lastName'],
            json['tel'],
            requests: json['requests'] != null ? List<String>.from(json['requests']) : new List(),
        );
    }

    Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'tel': tel,
        'requests': requests,
    };
}
