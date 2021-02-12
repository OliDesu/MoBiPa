class TrelloList {
    final String name;
    final String id;
    final bool closed;
    final int pos;
    final String softLimit;
    final String idBoard;
    final bool subscribed;

    TrelloList(
        {this.name,
            this.id,
            this.closed,
            this.pos,
            this.softLimit,
            this.idBoard,
            this.subscribed});

    factory TrelloList.fromJson(Map<String, dynamic> json) {
        return TrelloList(
            name: json['name'],
            id: json['id'],
            closed: json['closed'],
            pos: json['pos'],
            softLimit: json['softLimit'],
            idBoard: json['idBoard'],
            subscribed: json['subscribed'],
        );
    }
}
