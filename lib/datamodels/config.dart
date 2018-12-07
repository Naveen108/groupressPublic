import 'package:postgres/postgres.dart';

//postregs connection function called in splash
//and sets the connection in the query dart file
class Config {
  static PostgreSQLConnection connection;
  static connectToDb() async {
    PostgreSQLConnection connectionDB = new PostgreSQLConnection(
        "localhost", 5432, "group-res-app",
        username: "naveen", password: "", useSSL: false);
    try {
      await connectionDB.open().then((data) {
        print('connection data =  $data');
        print(connectionDB);
        connection = connectionDB;
        print('Hope i am connected');
        print(connection);
      });
    } catch (e) {
      print(e);
    }
  }
}
