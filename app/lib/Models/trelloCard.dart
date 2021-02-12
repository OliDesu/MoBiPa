import 'package:app/Models/trelloLabel.dart';

class TrelloCard {
    final String name;
    final String id;
    final bool closed;
    final String desc;
    final String idList;
    final TrelloLabel labels;

    TrelloCard(
        {this.name, this.id, this.closed, this.desc, this.idList, this.labels});

    factory TrelloCard.fromJson(Map<String, dynamic> json) {
        return TrelloCard(
            labels: TrelloLabel.fromJson(json["labels"][0]),
            name: json['name'],
            id: json['id'],
            closed: json['closed'],
            desc: json['desc'],
            idList: json['idList'],
        );
    }
}
