import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserUploadItem(
      Map<String, dynamic> userInfoMap, String id, String itemId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Items")
        .doc(itemId)
        .set(userInfoMap);
  }

  Future addAdminItem(Map<String, dynamic> userInfoMap, String id) async {
    return FirebaseFirestore.instance
        .collection("request")
        .doc(id)
        .set(userInfoMap);
  }


  Future<Stream<QuerySnapshot>> getAdminApproval() async {
    return FirebaseFirestore.instance
        .collection("request")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }


  Future updateAdminRequest(String id) async {
    return FirebaseFirestore.instance
        .collection("request")
        .doc(id)
        .update({"Status": "Approved"});
  }


  Future updateUserRequest(String userId, String itemId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Items")
        .doc(itemId)
        .update({"Status": "Approved"});
  }


  Future updateUserPoints(String userId, int points) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"Points": points});
  }
}
