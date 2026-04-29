import 'package:flutter/material.dart';

class AlertMessage {
  showAlert(BuildContext context, message, status) {
    Color? warnafill;
    Color warnagaris;
    if (status) {
      warnafill = Colors.green[200];
      warnagaris = Colors.green;
    } else {
      warnafill = Colors.pink[200];
      warnagaris = Colors.red;
    }
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: warnafill,
          border: Border.all(color: warnagaris, width: 3),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.favorite, color: Colors.green),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                message,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => {debugPrint("Undid")},
              child: Text("X"),
            ),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<Map<String, dynamic>?> showAlertDialog(
    BuildContext context) async {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text("Yakin ingin menghapus data?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            {"status": false},
          ),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(
            context,
            {"status": true},
          ),
          child: const Text("Hapus"),
        ),
      ],
    ),
  );
}
}
