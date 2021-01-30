import 'package:flutter/material.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:blog_flutter_prototype/services/crud_sqlite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Parameterpage extends StatefulWidget {
  @override
  _ParameterpageState createState() => _ParameterpageState();
}

class _ParameterpageState extends State<Parameterpage>{
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ParameterBodyBuilder(),
      floatingActionButton: AnimatedIconButton(
        onPressed: () {
          
        },
        size: 25,
        duration: Duration(milliseconds: 300),
        startIcon: Icon(Icons.settings,
        color: Colors.white
        ),

        endIcon: Icon(Icons.add, 
        color: Colors.white
        ),

        startBackgroundColor: Colors.lightBlue,
        endBackgroundColor: Colors.greenAccent,

      )  

      
    );
  }
}

class ParameterBodyBuilder extends StatefulWidget {
  @override
  _ParameterBodyBuilderState createState() => _ParameterBodyBuilderState();
}

class _ParameterBodyBuilderState extends State<ParameterBodyBuilder>  with SingleTickerProviderStateMixin{

  TabController tabController; 
  ScrollController scrollController; 



  @override 
  void initState() {
    super.initState(); 
    tabController = TabController(vsync: this, length: 2); 
    scrollController = ScrollController(keepScrollOffset: true, initialScrollOffset: 0.0); 
  }

  @override 
  void dispose() {
    tabController.dispose(); 
    scrollController.dispose(); 
    super.dispose(); 
  }

 


  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool isScroll) {
        return <Widget> [
          SliverAppBar(
            title: Text('Settings AppBar'),
            pinned: false,
            floating: true,
            forceElevated: isScroll,
            bottom: TabBar(
              tabs: <Widget> [
                Tab(
                  text: "Data",
                  icon: Icon(Icons.perm_data_setting),
                ), 
                Tab(
                  text: "Autres à revoire",
                ), 
              ],
              controller: tabController,
            ),
          ), 
        ];
      },
      //navvigation des tabs
      body: TabBarView(
        children: <Widget> [
          TapBarData(),
          TappBarAutres(), 
        ],
        controller: tabController,
      ),
    ); 
  }
}

//pages des tabBar 
class TapBarData extends StatefulWidget {
  @override
  _TapBarDataState createState() => _TapBarDataState();
}

class _TapBarDataState extends State<TapBarData> {
  final firestoreCRUDreference = CloudDB;
  Stream theStream; 
  QuerySnapshot futuresnapshot; 


  @override 
  void initState() {
    CloudDB.firebaseReference.gettheData().then((resultat) {
      theStream = resultat; 
    }); 
    
    super.initState(); 
  }


   //bottom notif quand ok
  void _imageUploadWithSuccess() {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.thumb_up_alt),
                title: Text("tout les fichiers sont upload avec succès"), 
                onTap: () {
                  print("ListTile sans fonctionnalitées"); 
                },
              ),
            ), 
          ],
        ); 
      }
    ); 
  }



  @override
  Widget build(BuildContext context) {
    return Container(
          child: theStream != null ? StreamBuilder(
        stream: theStream,
        builder: (context, snapshot) { 
            return Column(
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      //index ? 
                      Text(
                        snapshot.data.documents.data['titre'],
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(), 
                        ),
                      ), 
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(
                        snapshot.data.documents.data['pseudonyme'],
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(), 
                        ),
                      ), 
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(
                        snapshot.data.documents.data['description'], 
                         style: GoogleFonts.montserrat(
                          textStyle: TextStyle(), 
                        ),
                      ),
                    ],
                  ),
                ), 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(
                        snapshot.data.documents.data['numberofQuery'], 
                         style: GoogleFonts.montserrat(
                          textStyle: TextStyle(), 
                        ),
                      ),
                    ],
                  ),
                ), 
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.update), 
                    onPressed: () {  
                      print("a revoire pour updtate");
                    },
                  )
                ),
              ],
            ); 
        }, 
      ) 
      : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
    ); 
  }
}


class TappBarAutres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}