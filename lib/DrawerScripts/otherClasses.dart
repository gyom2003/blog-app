import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

//alert dialogue pour partir de l'app (car pas de connexion)
class DeleteAlertDialogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Attention", 
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.black54, 
          fontWeight: FontWeight.bold, 
          fontSize: 20
        )
      ),), 
      content: Text("Tu est sur de vouloir quitter l'application ? 😐",
        style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.black54, 
          fontSize: 20, 
        )
      ),
      ),
      actions: <Widget> [
        FlatButton(
          child: Text("Oui ✔", 
          style: TextStyle(
            color: Colors.black45, 
            fontWeight: FontWeight.bold
          ),), 
          onPressed: () {
            Navigator.of(context).pop(true); 
            Future.delayed(const Duration(milliseconds: 1000), () {
              exit(0);
          });
          }
        ),

         FlatButton(
          child: Text("Non ✖", 
          style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w500,  
          ),), 
          onPressed: () {
            Navigator.of(context).pop(false); 
          }
        ),
      ],
      elevation: 25,
      backgroundColor: Color(0xFF5499C7),
      shape: RoundedRectangleBorder(),  //CircleBorder()
    );
  }
}

