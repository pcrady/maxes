import 'package:flutter/widgets.dart';
import 'package:maxes/secrets.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Storage extends CognitoStorage {
  SharedPreferences _prefs;
  Storage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    try {
      item = json.decode(_prefs.getString(key));
    } catch (e) {
      return null;
    }
    return item;
  }

  @override
  Future setItem(String key, value) async {
    _prefs.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    if (item != null) {
      _prefs.remove(key);
      return item;
    }
    return null;
  }

  @override
  Future<void> clear() async {
    _prefs.clear();
  }
}

class Auth with ChangeNotifier {
  String _email;
  String _identityPoolName;
  String _userPoolName;
  String _clientId;
  CognitoUserPool _cognitoUserPool;
  CognitoUser _cognitoUser;
  CognitoCredentials _credentials;
  Storage _customStore;
  SharedPreferences _prefs;
  CognitoUserSession _session;

  Auth() {
    _userPoolName = kSecrets['cognitoUserPool'];
    _identityPoolName = kSecrets['cognitoIdentityPool'];
    _clientId = kSecrets['cognitoClientId'];
  }

  Future<void> init({String email}) async {
    try {
      _email = email;
      _prefs = await SharedPreferences.getInstance();
      _customStore = Storage(_prefs);
      _cognitoUserPool =
          CognitoUserPool(_userPoolName, _clientId, storage: _customStore);
      _cognitoUser = await _cognitoUserPool.getCurrentUser();

      if (_cognitoUser == null && _email != null) {
        _cognitoUser =
            CognitoUser(_email, _cognitoUserPool, storage: _customStore);
      }

      if (_cognitoUser != null) {
        _session = await _cognitoUser.getSession();
      }
    } catch (e) {
      if (e.message != 'Local storage is missing an ID Token, Please authenticate') {
        throw e;
      }
    }
  }

  Future<void> registerUser(String password) async {
    try {
      final userAttributes = [
        AttributeArg(
          name: 'email',
          value: _email,
        ),
      ];
      await _cognitoUserPool.signUp(_email, password,
          userAttributes: userAttributes);
    } catch (e) {
      throw e;
    }
  }

  Future<void> confirmUser(String confirmationCode) async {
    try {
      await _cognitoUser.confirmRegistration(confirmationCode);
    } catch (e) {
      throw e;
    }
  }

  Future<void> resendConfirmationCode() async {
    try {
      await _cognitoUser.resendConfirmationCode();
    } catch (e) {
      throw e;
    }
  }

  Future<void> authenticateUser(String password) async {
    final authDetails =
        AuthenticationDetails(username: _email, password: password);
    try {
      await _cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      throw e;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await init();
      await _cognitoUser.changePassword(oldPassword, newPassword);
    } catch (e) {
      throw e;
    }
  }

  // sendForgotPasswordCode and confirmForgotPasswordCode go together
  Future<void> sendForgotPasswordCode() async {
    try {
      await _cognitoUser.forgotPassword();
    } catch (e) {
      throw e;
    }
  }

  Future<void> confirmForgotPasswordCode(String code, String password) async {
    try {
      await _cognitoUser.confirmPassword(code, password);
    } catch (e) {
      throw e;
    }
  }

  // will return credentials if can get them or null if there is no cognitoUser
  // or the session isn't valid or there is an error
  Future<CognitoCredentials> getCognitoCredentials() async {
    CognitoCredentials credentials;

    try {
      // Retrieve the cognitoUser from storage if it exists
      await init();

      // check if we got a cognitoUser and a session
      if (_cognitoUser == null || _session == null) {
        return null;
      }

      // we don't want to create new credentials if old ones exist in the class
      // if the old ones are expired they will renew themselves see cognito_credentials.dart
      // in the amazon_cognito_identity_dart package
      _credentials = _credentials != null ? _credentials : CognitoCredentials(_identityPoolName, _cognitoUserPool);

      // these credentials will either return what they have or if things are
      // expired they will get new tokens
      await _credentials.getAwsCredentials(_session.getIdToken().getJwtToken());
      credentials = _credentials;
      notifyListeners();
    } catch (e) {
      throw e;
    }
    return credentials;
  }

  Future<void> signOut() async {
    try {
      await _cognitoUser.signOut();
      // delete the credentials from memory
      _credentials = null;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
