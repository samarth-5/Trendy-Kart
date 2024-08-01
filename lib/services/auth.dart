import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods
{
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  Future deleteUser() async{
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}