import 'package:drivers_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth fauth = FirebaseAuth.instance;
User? currentFirebaseUser = fauth.currentUser;

UserModel? userModelCurrentInfo;
