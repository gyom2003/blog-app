
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blog_flutter_prototype/services/crud_sqlite.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';



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

class TheTabPage extends StatefulWidget {
  TheTabPage({
    Key key, 
    @required this.scrollController,  
  });
  final ScrollController scrollController;


  @override
  _TheTabPageState createState() => _TheTabPageState();
}

class _TheTabPageState extends State<TheTabPage> {
  Stream stream;
  QuerySnapshot futuresnapshot; 

  @override 
  void initState() {
    CloudDB.firebaseReference.gettheData().then((resultat) {
      //récupère les données doc en forme de stream
      stream = resultat; 
    });
    super.initState(); 

  }

  @override
  Widget build(BuildContext context) {
    final theheighReference = MediaQuery.of(context).size.height;
    return Container(
      //vérifier présence de données dans doc
      child: stream != null ? StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
        return ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.all(15), 
        children: <Widget> [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18), 
              child: DefaultTextStyle(
                style: GoogleFonts.raleway(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    SizedBox(height: 40), 
                    Text("Bonjour",  //this
                    style: TextStyle(
                      fontSize: 30, 
                      )
                    ),
                    SizedBox(height: 5), 
                    Text("regarde dans cette page les données que tu as stockés", 
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600
                      ) 
                    ), 
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget> [
                        Text("Mes données", 
                        style: TextStyle(
                          fontSize: 21, 
                          fontWeight: FontWeight.w500, 
                        )),
                        OutlinedButton(
                          child: Icon(Icons.more_horiz), 
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white, 
                            shape: CircleBorder(), 
                            side: BorderSide(width: 1, color: Colors.white)
                          ), 
                        )
                      ],
                    ), 

                    SizedBox(height: 30),
                    //main liste
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //for (var listModel in listModels)  
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), 
                          child: Stack(
                            alignment: Alignment.center, //AlignmentDirectional.center, 
                            children: <Widget> [
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black45, 
                                  BlendMode.darken, 
                                ),
                                child: Image.network(
                                  snapshot.data.documents.data['imageURL'],  
                                  height: theheighReference * 0.40,
                                ),
                              ),
                              Column(
                                children: <Widget> [
                                  //ajout des textes
                                   Text(
                                    snapshot.data.documents.data['titre'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(snapshot.data.documents.data['pseudonyme'],),
                                  SizedBox(height: 40),
                                  Text(
                                    snapshot.data.documents.data['description'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Text(""),
                                ],
                              )
                            ],
                          )
                        )


                      ],
                    ),

                  ],
                ),
              )
            )

        ],
      );
      } 
      ) : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator()
      )
    );
  }
}


