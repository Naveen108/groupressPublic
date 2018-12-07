import 'dart:async';
import 'package:postgres/postgres.dart';
import './config.dart';
//this dart contains all the DB query functions

PostgreSQLConnection connection =
    Config.connection; //Config the connection from Backend DB

//each function returns specific data requried when called

Future<dynamic> queryUser(myQuery) async {
  //function used for quering the logins , new registering etc.
  try {
    return await connection.query(myQuery).then((data) {
      print("data in queryU check= $data");
      print(data.length);
      if (data.length != 0 && data != null) {
        return data[0][0];
      } else {
        return true;
      }
    });
  } catch (e) {
    print('I HAVE COUGHT ERROR IN QUERY USER');
    print(e);
    return false;
  }
}

Future<dynamic> queryLogin(myQuery) async {
  //function used for quering the logins , new registering etc.
  try {
    return await connection.query(myQuery).then((data) {
      print("data in queryU check= $data");
      print(data.length);
      if (data.length != 0 && data != null) {
        return data[0];
      } else {
        return true;
      }
    });
  } catch (e) {
    print('I HAVE COUGHT ERROR IN QUERY USER');
    print(e);
    return false;
  }
}

Future<dynamic> queryMenu(myQuery) async {
  //function used for quering Menuitems form DB etc.
  try {
    return await connection.query(myQuery).then((data) {
      print('data in reacived from queryM --->> $data');
      //print(data);
      return data;
    });
  } catch (e) {
    print('I HAVE COUGHT ERROR IN QUERING queryM Items');
    print(e);
    return false;
  }
}

Future<dynamic> queryG(myQuery) async {
  //function used for quering groupitems form DB etc.
  try {
    return await connection.query(myQuery).then((data) {
      print("data in queryG check= $data");
      print(data.length);
      if (data.length != 0 && data != null) {
        print('i have queryG in if data ${data[0][3]}');
        return data[0][7];
      } else {
        print('queryG retruning data true');
        return true;
      }
    });
  } catch (e) {
    print('I HAVE COUGHT ERROR IN QUERY G');
    print(e);
    return false;
  }
}
