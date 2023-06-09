import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {

  static Future<void> initDynamicLink(BuildContext context)async {
    FirebaseDynamicLinks.instance.onLink;


    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    try{
      final Uri? deepLink = data?.link;
      var isStory = deepLink?.pathSegments.contains('storyData');
      if(isStory ?? false){ // TODO :Modify Accordingly
        String? id = deepLink?.queryParameters['id']; // TODO :Modify Accordingly

        // TODO : Navigate to your pages accordingly here

      }
    }catch(e){
      print('No deepLink found');
    }
  }


}
