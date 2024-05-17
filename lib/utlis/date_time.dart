import 'package:intl/intl.dart';

class MyDateTime{
  static DateTime dateFormat({required String time}){
   var dt=DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return DateTime(dt.year ,dt.month,dt.day);
  }
  static String dateTime(String time){
    String t='';
    var dt=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    t=DateFormat('jm').format(dt).toString();
    return t;
  }


  static String dateAndTime({required String time}) {
    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final t = DateTime(today.year, today.month, today.day);
    final y = DateTime(yesterday.year, yesterday.month, yesterday.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    String dat = '';
    if (d == t) {
      dat = 'today';
    } else if (d == y) {
      dat = 'yesterday';
    } else {
      dat = DateFormat('y-M-d').add_yMMMd().format(dt).toString();
    }
    return dat;
  }
}