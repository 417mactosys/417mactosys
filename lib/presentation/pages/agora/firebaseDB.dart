
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreClass{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final liveCollection = 'liveuser';

  static void createLiveUser({name, id, time,image}) async {
    final snapShot = await _db.collection(liveCollection).doc(name).get();
    if (snapShot.exists) {
      /*await _db.collection(liveCollection).doc(name).updateData({
        'name': name,
        'channel': id,
        'time':time,
        'image': image
      });
    } else {
      await _db.collection(liveCollection).doc(name).setData({
        'name': name,
        'channel': id,
        'time':time,
        'image': image
      });
    }*/
    }

    /* static void deleteUser({username}) async{
    await _db.collection(liveCollection).doc(username).delete();
  }*/
  }
}