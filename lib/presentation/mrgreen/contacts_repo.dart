import 'dart:async';
import './contacts_friends.dart';
import '../../domain/entities/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'dart:convert';
import '../../infrastructure/api/api_service.dart';
import '../../infrastructure/core/pref_manager.dart';
import 'package:http/http.dart';

StreamController<ContactRepo> contacts_controller = StreamController();

class ContactRepo {
  List<Friend> list = List();
  double progress;

  void addItem(item) {
    list.add(item);
  }
}

final repo = ContactRepo();

Future<List<Friend>> getC() async {
  print("PHONES 1");
  final regU = List<Friend>();
  final unReg = List<Friend>();
  await initC();
  if (!allowed) return regU;

  var d = await FlutterContacts.getContacts(withProperties: true);

  String phones = '';

  for (var i = 0; i < d.length; i++) {
    final e = d[i];
    if (e.phones.length > 0) {
      phones += "'" +
          e.phones.first.number
              .replaceAll('+91', '')
              .replaceAll(' ', '')
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '') +
          "', ";
    }
  }
  phones = phones.substring(0, phones.length - 2);

  final apiUsers = await getUsers(phones);

  print(phones);
  final List<String> pushed = List();
  if(apiUsers.length == 0){
    d.forEach((c) {
      final id = c.id;
      if (c.phones.length > 0) {
        if (!pushed.contains(id)) {
          pushed.add(id);
          unReg.add(Friend(c, null));
        }
      } else {
        if (!pushed.contains(id)) {
          pushed.add(id);
          unReg.add(Friend(c, null));
        }
      }
    });
  }

  apiUsers.forEach((s) {
    d.forEach((c) {
      final id = c.id;
      if (c.phones.length > 0) {
        if (s.phone ==
            c.phones.first.number
                .replaceAll('+91', '')
                .replaceAll(' ', '')
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '') &&
            s.phone.isNotEmpty) {
          print('registered');
          //if (!pushed.contains(id)) {
          pushed.add(id);
          regU.add(Friend(c, s));
          //}
        } else {
          if (!pushed.contains(id)) {
            pushed.add(id);
            unReg.add(Friend(c, null));
          }
        }
      } else {
        if (!pushed.contains(id)) {
          pushed.add(id);
          unReg.add(Friend(c, null));
        }
      }
    });
  });

  regU.addAll(unReg);

  return regU;
}

bool allowed = false;
initC() async {
  allowed = await Permission.contacts.isGranted;
  if (!allowed) {
    requestContact();
  } else {
    //getC();
  }
}

requestContact() async {
  allowed = (await Permission.contacts.request()) == PermissionStatus.granted;
  if (allowed) {
    getC();
  }
}

Future<List<User>> getUsers(String phone) async {
  print("contact");
  print(Prefs.ID);
  final uri =
      Uri.parse('https://wilotv.live:3443/api/is_user?id=${Prefs.ID}');
  //uri.replace(queryParameters: {'phone': phone});
  final res = await post(uri, body: {'phone': phone});
  print(res.body);
  print("contact12");
  final List<dynamic> list = jsonDecode(res.body)['user'];
  final List<User> result = List();
  for (var i = 0; i < list.length; i++) {
    final u = list[i];
    final uu = (await HeyPApiService.create().getUserInfo(User.fromJson(u).id))
        .body
        .user;
    result.add(uu);
  }
  print('RESULT');
  print(result.toString());
  //if (u == null) return null;
  return result;
}
