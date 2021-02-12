class TrelloLabel {
    String id;
    String idBoard;
    String name;
    String color;

    TrelloLabel({
        this.id,
        this.idBoard,
        this.name,
        this.color,
    });

    factory TrelloLabel.fromJson(Map<String, dynamic> json) => TrelloLabel(
        id: json["id"],
        idBoard: json["idBoard"],
        name: json["name"],
        color: json["color"],
    );
}
