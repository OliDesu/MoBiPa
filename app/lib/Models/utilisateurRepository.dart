import 'package:app/Models/request.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/trelloList.dart';
import 'package:app/Models/trelloCard.dart';
import 'package:app/Models/trelloBoard.dart';
import 'package:app/Models/trelloLabel.dart';
import 'package:app/Models/trelloClient.dart';
import 'package:app/main.dart';


class UtilisateurRepository {
    TrelloClient trelloClient;
    Future<List<TrelloBoard>> boardList;
    Future<List<TrelloList>> trelloList;
    TrelloBoard board;
    Utilisateur user;
    List<Request> userRequests;
    List<String> userCardsId;
    List<TrelloList> lists;
    TrelloLabel redLabel;


    void initRepo (Utilisateur connectedUtilisateur){
        user = connectedUtilisateur;
        trelloClient = new TrelloClient('e052d2e3f76188d11732bd6bd3029a1a', '97381e6593bee1846d96f3362d208681c73107c83898f5edacb00778dc263575');
        userCardsId = user.requests ?? new List();

        boardList = trelloClient.getBoards();
        boardList.then((boards) {
            board = boards.singleWhere((b) {
                return b.name == 'MobiPA';
            });
            trelloList = trelloClient.getLists(board);
            trelloList.then((value) async {
                lists = value;
                userRequests = new List();
                if (userCardsId.isNotEmpty) {
                    for (String cardId in userCardsId) {
                        TrelloCard c = await trelloClient.getCardFromID(cardId);
                        if (c != null) {
                            Request newRequest = Request.fromCard(c);
                            newRequest.etat = lists.singleWhere((l) {
                                return l.id == c.idList;
                            }, orElse: () => TrelloList(name: 'Autre'));
                            newRequest.utilisateur = connectedUtilisateur;
                            userRequests.add(newRequest);
                        } else {
                            print('Card does not exist');
                        }
                    }
                    if (userRequests != null && userRequests.isNotEmpty) {
                        userRequests.sort((a, b) => a.date.compareTo(b.date));
                        userRequests = userRequests.reversed.toList();
                    }
                }
            });
            trelloClient.getLabels(board).then((labels) {
                redLabel = labels.singleWhere((l) {
                    return l.color == 'red';
                });
            });
        });
    }

    Future<bool> addRequest(Request req) async {
        bool success = await req.postOnTrello(trelloClient, redLabel);
        if (success) {
            userRequests.add(req);
            userCardsId.add(req.card.id);
            if (userRequests != null && userRequests.isNotEmpty) {
                userRequests.sort((a, b) => a.date.compareTo(b.date));
                userRequests = userRequests.reversed.toList();
            }
            user.requests = userCardsId;
            FirebaseFirestore.instance.collection('utilisateur').doc(user.userId).set(user.toJson());
        }
        return success;
    }

    Future<bool> deleteRequest(Request req) async {
        bool success = await req.delOnTrello(trelloClient);
        if (success) {
            userRequests.remove(req);
            userCardsId.remove(req.card.id);
            if (userRequests != null && userRequests.isNotEmpty) {
                userRequests.sort((a, b) => a.date.compareTo(b.date));
                userRequests = userRequests.reversed.toList();
            }
            FirebaseFirestore.instance.collection('utilisateur').doc(user.userId).set(user.toJson());
        }
        return success;
    }
}
