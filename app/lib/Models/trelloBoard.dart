class TrelloBoard {
    final String name;
    final String id;

    TrelloBoard({this.name, this.id});

    factory TrelloBoard.fromJson(Map<String, dynamic> json) {
        return TrelloBoard(
            name: json['name'],
            id: json['id'],
        );
    }
}
