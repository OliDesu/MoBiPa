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

    void initRepo (){
        
    }
}
