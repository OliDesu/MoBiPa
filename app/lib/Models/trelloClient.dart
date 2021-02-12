import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:app/Models/trelloLabel.dart';
import 'package:app/Models/trelloBoard.dart';
import 'package:app/Models/trelloCard.dart';
import 'package:app/Models/trelloList.dart';

class TrelloClient {
    String key;
    String token;
    HttpClient client;
    static const HOST = "https://api.trello.com";

    /// Client API [key] and [token] required to access the API
    TrelloClient(String key, String token) {
        this.key = key;
        this.token = token;
    }

    /// Override the http [get] method, needs a trello [uri] and [args]
    /// Example uri:'1/members/me/boards', args: {"fields": "name"}
    Future<http.Response> _get(String uri, Map<String, String> args) async {
        if (uri[0] != "/") {
            uri = "/$uri";
        }
        return http.get(_createTrelloUri(uri, args));
    }

    Future<http.Response> _post(String uri, Map<String, String> args) async {
        if (uri[0] != "/") {
            uri = "/$uri";
        }
        return http.post(_createTrelloUri(uri, args));
    }

    Future<http.Response> _put(String uri, Map<String, String> args) async {
        if (uri[0] != "/") {
            uri = "/$uri";
        }
        return http.put(_createTrelloUri(uri, args));
    }

    Future<http.Response> _delete(String uri, Map<String, String> args) async {
        if (uri[0] != "/") {
            uri = "/$uri";
        }
        return http.delete(_createTrelloUri(uri, args));
    }

    /// Format the [uri] to reach the Trello host api and give it the [args]
    Uri _createTrelloUri(String uri, Map<String, String> args) {
        StringBuffer buf = new StringBuffer();
        void addToBuf(argKey, argValue) {
            buf.write("&");
            buf.write(argKey);
            buf.write("=");
            buf.write(argValue);
        }

        args.forEach(addToBuf);
        return Uri.parse("$HOST$uri?key=$key&token=$token${buf.toString()}");
    }

    /// Get all the boards of a Trello client
    Future<List<TrelloBoard>> getBoards() async {
        http.Response res =
        await this._get('1/members/me/boards', {"fields": "name"});
        print("getBoards : " + res.body.toString());
        if (res.statusCode == 200) {
            return (jsonDecode(res.body) as List)
                .map((f) => TrelloBoard.fromJson(f))
                .toList();
        } else {
            throw Exception('Failed to load boards');
        }
    }

    /// Get all the lists into a given board [b]
    Future<List<TrelloList>> getLists(TrelloBoard b) async {
        http.Response res = await this._get(
            '1/boards/${b.id}/lists', {'lists': 'open', 'list_fields': 'name'});
        print("getLists : " + res.body.toString());
        if (res.statusCode == 200) {
            return (jsonDecode(res.body) as List)
                .map((f) => TrelloList.fromJson(f))
                .toList();
        } else {
            throw Exception('Failed to load lists');
        }
    }

    /// Get all the cards into a given list [l]
    Future<List<TrelloCard>> getCards(TrelloList l) async {
        http.Response res = await this._get('1/lists/${l.id}/cards', {'fields': 'name,id,idList,closed,desc,labels'});
        print("getCards : " + res.body.toString());
        if (res.statusCode == 200) {
            return (jsonDecode(res.body) as List)
                .map((f) => TrelloCard.fromJson(f))
                .toList();
        } else {
            throw Exception('Failed to load cards');
        }
    }

    /// Get all the labels of a given board [b]
    Future<List<TrelloLabel>> getLabels(TrelloBoard b) async {
        http.Response res = await this._get('1/boards/${b.id}/labels', {'': ''});
        print("getLabels : " + res.body.toString());
        if (res.statusCode == 200) {
            return (jsonDecode(res.body) as List)
                .map((f) => TrelloLabel.fromJson(f))
                .toList();
        } else {
            throw Exception('Failed to load labels');
        }
    }

    /// Add a card into a given [list], with a [title] and a [description]
    /// Puts the card on top of the list with the red label to mark it open
    Future<TrelloCard> addCard(TrelloList list, String title, String description,
        TrelloLabel label) async {
        http.Response res = await this._post('1/cards', {
            'idList': list.id,
            'name': title,
            'desc': description,
            'pos': 'top',
            'idLabels': label.id
        });
        print("addCard : " + res.body.toString());
        if (res.statusCode == 200) {
            return TrelloCard.fromJson(jsonDecode(res.body));
        } else {
            throw Exception('Failed to add card');
        }
    }

    /// Delete a card from from its Id
    Future<bool> deleteCard(String id) async {
        http.Response res = await this._delete('1/cards/$id', {});
        print("deleteCard : " + res.body.toString());
        if (res.statusCode == 200) {
            return true;
        } else {
            return null;
        }
    }

    /// Get a card from its Id
    Future<TrelloCard> getCardFromID(String id) async {
        http.Response res = await this
            ._get('1/cards/$id', {'fields': 'name,id,idList,closed,desc,labels'});
        print("getCardFromID : " + res.body.toString());
        if (res.statusCode == 200) {
            return TrelloCard.fromJson(jsonDecode(res.body));
        } else {
            return null;
        }
    }

    /// Add a [TrelloLabel] to a [TrelloCard]
    Future<bool> addLabelToCard(String cardId,String labelId) async {
        http.Response res = await this._post('1/cards/$cardId/idLabels', {
            'value': labelId,
        });
        if (res.statusCode == 200) {
            return true;
        } else {
            return false;
        }
    }

    /// Removes a [TrelloLabel] from a [TrelloCard]
    Future<bool> removeLabelFromCard(String cardId,String labelId) async {
        http.Response res = await this._delete('1/cards/$cardId/idLabels/$labelId', {});
        if (res.statusCode == 200) {
            return true;
        } else {
            return false;
        }
    }
}
