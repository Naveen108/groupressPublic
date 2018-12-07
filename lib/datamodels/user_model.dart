import 'dart:async';
import 'package:groupres/DataModels/query.dart';
import 'package:groupres/DataModels/user_class.dart';
import 'package:groupres/DataModels/new_user_register_class.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//usermodel for handling logins and regiter , as well the invited requestes
class UserModel extends Model {
  //user's name
  static String username;
  //group name in which user selected by default GR
  static String currentGroup;
  //group's superuser
  static int groupId;
  //superuser of group
  static String superuser;
  //user's Phone
  static String userPhoneNumber;
  //cart_id of user
  static int cartId;

  //Singup function for new user registering
  Future<dynamic> singUp(NewUserRegister newSuperUser) async {
    String userName = newSuperUser.userName;
    String phoneNumber = newSuperUser.phoneNumber;
    String password = newSuperUser.password;
    //Handle Double SingUp Issue
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myQuery =
        "INSERT INTO users(user_name,user_phone,user_pass) VALUES ('$userName','$phoneNumber','$password')";

    try {
      print(myQuery);
      queryUser(myQuery).then((data) {
        if (data == true) {
          print(data);
          prefs.setString('userphone', phoneNumber);
          prefs.setString('username', userName);
          prefs.setString('group', 'GR');
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN UerModel');
      print(e);
      return false;
    }
  }

//Login check function for the user to login
  Future<dynamic> loginCheck(User userData) async {
    String phonenumber = userData.phonenumber;
    String password = userData.password;
    String myQuery = "Select * FROM users WHERE user_phone  ='$phonenumber' ";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      return await queryLogin(myQuery).then((data) {
        print('hey got this in logincheck after queryuser ${data[1]}');
        if (data[2].toString() == password) {
          currentGroup = 'GR';
          userPhoneNumber = userData.phonenumber;
          username = data[1];
          prefs.setString('username', username);
          prefs.setString('group', 'GR');
          print('$currentGroup,$userPhoneNumber,$username');
          print('array');
          print(data);
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e);
      print('I HAVE COUGHT ERROR IN UerModel while logincheck');
      print(e);
      return false;
    }
  }

  //for invite check using groupid user phone number
  Future<dynamic> inviteCheck(
      String phonenumberid, String groupid, String name) async {
    //Query1 for checking userphone is inthe list of the groupusers and with same group as asked
    //a inner join query
    String myQuery = """
    SELECT C.cart_id,M.group_id,M.group_name,C.user_phone
    FROM groups M 
    INNER JOIN groupusers C 
    ON C.user_phone = '$phonenumberid'
    WHERE C.group_id = M.group_id
    AND 
    M.group_name = '$groupid'
    """;
    //check user in guest or in users
    String myQuery2 = """
    SELECT user_phone
    FROM users
    WHERE user_phone = '$phonenumberid' 
    """;
    //if not found there update the name in the guests
    String myQuery3 = """
    UPDATE guests
    SET guest_name = '$name'
    WHERE guest_phone = '$phonenumberid' 
    """;

    try {
      return await queryMenu(myQuery).then((data) {
        print('my data in invite check is --> ${data}');
        if (data.length > 0) {
          //user is invited set the cart_id
          UserModel.cartId = data[0][0];
          UserModel.groupId = data[0][1];
          return queryMenu(myQuery2).then((data) {
            if (data.length != 0) {
              //found user in the list of invited friends and in users no update
              print(' guest found in users $data');
              return true;
            } else {
              return queryUser(myQuery3).then((data) {
                print('after changing guest $data');
                return true;
              });
            }
          });
        }
      });
    } catch (e) {
      print('ERROR IN UerModel while logincheck');
      print(e);
      return false;
    }
  }
}
