import 'package:app/Models/user.dart';

class Utilisateur extends User {
    List<String> requests;

    Utilisateur(String userId, String firstName, String lastName, String tel, {List<String> requests})
    : requests = requests ?? new List();
    super(userId, firstName, lastName, tel);
}
