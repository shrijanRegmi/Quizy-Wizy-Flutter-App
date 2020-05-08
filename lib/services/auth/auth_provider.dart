import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;

// login user
  Future loginUser(final _email, final _password) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      FirebaseUser _user = _result.user;
      _userFromFirebase(_user);
      return _user.uid;
    } catch (e) {
      return "$e myError";
    }
  }

// signup user
  Future signUpUser(final _name, final _email, final _password) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      FirebaseUser _user = _result.user;
      await DatabaseProvider(uid: _user.uid).sendUserInfo(_name, _email);
      await DatabaseProvider(uid: _user.uid).sendUserStats(0, 0, 0);
      _userFromFirebase(_user);
      return _user.uid;
    } catch (e) {
      return "$e myError";
    }
  }

// signOut user
  Future signOut() async {
    await _auth.signOut();
  }

// get user from firebase
  UserDetail _userFromFirebase(FirebaseUser _user) {
    return _user != null ? UserDetail(uid: _user.uid) : null;
  }

// stream of user
  Stream<UserDetail> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }
}
