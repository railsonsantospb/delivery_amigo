import 'package:dbcrypt/dbcrypt.dart';

main() {
  var plainPassword = "P@55w0rd";
  var hashedPassword = new DBCrypt().hashpw(plainPassword, new DBCrypt().gensalt());
  print(hashedPassword);
}