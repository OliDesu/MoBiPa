import 'package:app/Models/user.dart';

class Driver extends User {
    List<String> requests;

    Driver(String userId, String firstName, String lastName, String tel, {List<String> requests})
        : requests = requests ?? new List(),
            super(userId, firstName, lastName, tel);

    factory Driver.fromJson(Map<String, dynamic> json) {
        return Driver(
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
