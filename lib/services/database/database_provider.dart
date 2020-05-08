import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizy_wizy/models/firebase_model/questions.dart';
import 'package:quizy_wizy/models/firebase_model/stats.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';

class DatabaseProvider {
  final uid;
  DatabaseProvider({this.uid});

  final _ref = Firestore.instance;
  final _appName = "QuizyWizy";

/////////////////////////////////////////////////////////////send to firebase

// send user info
  Future sendUserInfo(final _userName, final _email) async {
    await _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .setData({"uid": uid, "userName": _userName, "userEmail": _email});
  }

// send user stats
  Future sendUserStats(final _level, final _points, final _rank) async {
    await _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .collection("UserStats")
        .document("UserStats")
        .setData({"level": _level, "points": _points, "rank": _rank});
  }

// update user stats
  Future updateUserStats(final _level, final _points, final _rank) async {
    await _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .collection("UserStats")
        .document("UserStats")
        .updateData({"level": _level, "points": _points, "rank": _rank});
    await _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .updateData({"points": _points});
  }

// send question
  Future sendQuestion(
    final _mode,
    final _question,
    final _optionA,
    final _optionB,
    final _optionC,
    final _optionD,
    final _correctAns,
  ) async {
    if (_mode == "Quick") {
      return _ref
          .collection(_appName)
          .document("Questions")
          .collection("Questions")
          .add({
        "question": _question,
        "optionA": _optionA,
        "optionB": _optionB,
        "optionC": _optionC,
        "optionD": _optionD,
        "correctAns": _correctAns,
        "date": DateTime.now().toString(),
      });
    } else {
      return _ref
          .collection(_appName)
          .document("General")
          .collection("General")
          .add({
        "question": _question,
        "optionA": _optionA,
        "optionB": _optionB,
        "optionC": _optionC,
        "optionD": _optionD,
        "correctAns": _correctAns,
        "date": DateTime.now().toString(),
      });
    }
  }

// delete question
  Future deleteQuestion(final docId, final _mode) async {
    if (_mode == "Nursing") {
      await _ref
          .collection(_appName)
          .document("Questions")
          .collection("Questions")
          .document(docId)
          .delete();
    } else {
      await _ref
          .collection(_appName)
          .document("General")
          .collection("General")
          .document(docId)
          .delete();
    }
  }

///////////////////////////////////////////////////////////////////get from firebase

// get userDetails from firebase
  UserDetail _userDetailFromFirebase(DocumentSnapshot doc) {
    return UserDetail(
      uid: doc.data["uid"] ?? "",
      userName: doc.data["userName"] ?? "",
      userEmail: doc.data["userEmail"] ?? "",
    );
  }

// get userStats from firebase
  UserStat _userStatFromFirebase(DocumentSnapshot doc) {
    return UserStat(
      doc.data["level"] ?? 0,
      doc.data["points"] ?? 0,
      doc.data["rank"] ?? 0,
    );
  }

// get questions from firebase
  List<Questions> _questionsFromFirebase(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Questions(
        doc.documentID,
        doc.data["question"],
        doc.data["optionA"],
        doc.data["optionB"],
        doc.data["optionC"],
        doc.data["optionD"],
        doc.data["correctAns"],
      );
    }).toList();
  }

// get general questions from firebase
  List<GeneralQuestions> _generalQuestionFromFirebase(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GeneralQuestions(
        doc.documentID,
        doc.data["question"],
        doc.data["optionA"],
        doc.data["optionB"],
        doc.data["optionC"],
        doc.data["optionD"],
        doc.data["correctAns"],
      );
    }).toList();
  }

// get list of user from firebase
  List<UserDetail> _usersListFromFirebase(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDetail(
        uid: doc.data["uid"] ?? "",
        userName: doc.data["userName"] ?? "",
        userEmail: doc.data["userEmail"] ?? "",
      );
    }).toList();
  }

//////////////////////////////////////////////////////////////////streams

// stream of userDetail
  Stream<UserDetail> get userDetail {
    return _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .snapshots()
        .map(_userDetailFromFirebase);
  }

// stream of userStats
  Stream<UserStat> get userStat {
    return _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .collection("UserStats")
        .document("UserStats")
        .snapshots()
        .map(_userStatFromFirebase);
  }

// stream of questions
  Stream<List<Questions>> get questions {
    return _ref
        .collection(_appName)
        .document("Questions")
        .collection("Questions")
        .orderBy("date", descending: true)
        .snapshots()
        .map(_questionsFromFirebase);
  }

// stream of general questions
  Stream<List<GeneralQuestions>> get generalQuestion {
    return _ref
        .collection(_appName)
        .document("General")
        .collection("General")
        .orderBy("date", descending: true)
        .snapshots()
        .map(_generalQuestionFromFirebase);
  }

// stream of list of users
  Stream<List<UserDetail>> get usersList {
    return _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .orderBy("points", descending: true)
        .limit(50)
        .snapshots()
        .map(_usersListFromFirebase);
  }
}
