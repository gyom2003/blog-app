
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog_flutter_prototype/blog_mechanique.dart'; 
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:blog_flutter_prototype/DrawerScripts/otherClasses.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blog_flutter_prototype/blog_mech_camera.dart';
import 'package:blog_flutter_prototype/ScriptReferences/parametrePage.dart';
import 'package:blog_flutter_prototype/services/crud_sqlite.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:random_string/random_string.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';




class DrawerPage extends StatefulWidget {
  DrawerPage({Key key }) : super(key: key); 
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  //Stream theStream; 
  QuerySnapshot querysnapshot; 
  final dbinstance = Firestore.instance;
  final pannelController = PanelController();

  @override
  void initState() {
    CloudDB.firebaseReference.gettheData().then((resultat) {
      querysnapshot =resultat; 
      setState(() {
        
      });
    }); 
    super.initState(); 
  }
  
    //pour cloud Firestore, 
    Widget blogListCloud() {
      return Container(
        child: Column(
          children: <Widget> [
            querysnapshot != null ?
             ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 25, left: 8, right: 8),
                  itemCount: querysnapshot.documents.length,
                  itemBuilder: (context, index) {
                  return BlogTileHome(
                    imageURL: querysnapshot.documents[index].data['imageURL'],
                    descriptionBlog:  querysnapshot.documents[index].data['description'],
                    numberofQueryBlog: querysnapshot.documents[index].data['numberofQuery'],
                    pseudonymeBlog: querysnapshot.documents[index].data['pseudonyme'],
                    titreBlog:  querysnapshot.documents[index].data['titre'],
                    ); 
                }) : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              ],
            )
          ); 
        }

  

  @override
  Widget build(BuildContext context) {
   return  SimpleHiddenDrawer(
     menu: Menu(), 
     //screen builder
     screenSelectedBuilder: (position, controller) {
      Widget screenCurrentState;
      switch(position) {
        case 0: screenCurrentState = Parameterpage(); break;
        case 1 : screenCurrentState = DeleteAlertDialogue(); break; 
      }
      return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0, 
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              RichText(
                text: TextSpan(
                  children: <TextSpan> [
                    TextSpan(text: "Flutter", 
                    style: TextStyle(
                      fontSize: 22, 
                    )), 
                    TextSpan(text: "Blog", 
                    style: TextStyle(
                      fontSize: 22, 
                      color: Colors.lightBlue, 
                    ))
                  ] 
                )
              )
            ],
          ), 
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.alignLeft),
            onPressed: () {
              controller.toggle(); 
            },
          ),
          actions: <Widget> [], 
        ),
        //button add
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, 
          vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  //navigation add post page
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => BlogMech(), 
                  )); 
                },
              ),
            ],
          ),
        ),
        //sliding up pannel
        body: SlidingUpPanel(
          minHeight: 37,
          maxHeight: MediaQuery.of(context).size.height,
          panelBuilder: (scrollController) => buildthePannel(
            scrollController: scrollController, 
            panelController: pannelController, 
          ),
          body: Container(
            child: querysnapshot != null ? 
            blogListCloud() : 
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ),
        )    
    );
     },
   ); 
    
  }
}

Widget buildthePannel({
  @required ScrollController scrollController,
  @required PanelController panelController, 
}) => DefaultTabController(
  length: 1,
  child: Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(80),
        child: GestureDetector(
          onTap: () => panelController.open(),
          child: AppBar(
          title: appbarIconPage(),  
          centerTitle: true,
          bottom: TabBar(
            //deux pages ? 
            tabs: [
              Tab(child: Text("Page cachée",
              style: GoogleFonts.raleway(color: Colors.white),),), 
            ],
          ),
        ),
      ),
    ),
      body: TabBarView(
      children: [ 
        TheTabPage(
          scrollController: scrollController,  
        ),
        ]
      ),
  ),
); 

Widget appbarIconPage() {
  return Container(
    width: 40,
    height: 8,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5), 
      borderRadius: BorderRadius.circular(8), 
    ),
  ); 
}

class BlogTileHome extends StatelessWidget {
  //ajout image url 
  final String titreBlog, pseudonymeBlog, descriptionBlog, numberofQueryBlog, imageURL;
  BlogTileHome({
    @required this.titreBlog, 
    @required this.pseudonymeBlog, 
    @required this.descriptionBlog, 
    @required this.numberofQueryBlog, 
    @required this.imageURL,
  }); 
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(bottom: 20),
      margin: EdgeInsets.only(bottom: 15),
      height: 150,
      child: Stack(
        children: <Widget> [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BlurHash(
                hash: randomAlphaNumeric(5),
                image: imageURL, 
                imageFit: BoxFit.cover,
                duration: Duration(seconds: 2), 
                curve: Curves.bounceIn,
                ),
            )), 
          Container(
            height: 150,
            decoration: BoxDecoration( borderRadius: BorderRadius.circular(13)),
          ), 
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Text(titreBlog, 
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.white30, 
                    fontWeight: FontWeight.w500
                  )
                ),),
                SizedBox(height: 5),  

                Text(pseudonymeBlog, 
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    fontSize: 16,
                     color: Colors.white30, 
                    fontWeight: FontWeight.w400
                  )
                ),),

                SizedBox(height: 5), 

                Text(descriptionBlog, 
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                     color: Colors.white30, 
                    fontWeight: FontWeight.w400
                  )
                ),),

                 SizedBox(height: 5),

              ]
            ),
          )
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SimpleHiddenDrawerController controller; 

  @override 
    void didChangeDependencies() {
     //def controller, 
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

 //importer deux fonctions

  @override
  Widget build(BuildContext context) { 
    Widget mechInstance = BlogCam(); 
    return Material(
          child: Stack(
            children: <Widget> [
            Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff3498DB), 
                  Color(0xff5DADE2), 
                ]
              )
            ),
            
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget >[
                  
                SizedBox(width: 10), 

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                    Container(
                    padding: const EdgeInsets.only(top: 15),
                    height: 40,
                    width: 40,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage("assets/images/fish.jpg"), 
                          fit: BoxFit.cover, 
                        )
                      ),
                    ),
                    //TODO: utiliser provider
                      Text("titre à remplacer", 
                      style: TextStyle(fontSize: 17, color: Colors.white)),
                      SizedBox(height: 3),  
                      Text("description à remplacer", 
                      style: TextStyle(fontSize: 15, color: Colors.grey[400]),), 
                        ],
                      ),
                    ],
                  ),
                ),
              ),

                            Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.only(top: 150),), 
                                SizedBox(width: 10), 
                                Row(
                                  children: <Widget> [
                                    IconButton(
                                        onPressed: () {
                                          //SimpleHiddenDrawerController.of(context).close();
                                          controller.close(); 
                                        },
                                        icon: Icon(Icons.arrow_back_ios),
                                      ),
                                    Text("naviguer page Home", 
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.w600, 
                                        fontSize: 15
                                      )
                                    )),
                                  ],
                                ), 
                                Padding(
                                  padding: const EdgeInsets.only(top: 20), ), 
                                 SizedBox(width: 10), 
                                Row(
                                  children: <Widget> [
                                    IconButton(
                                        onPressed: () {
                                         //controller.setSelectedMenuPosition(0); 
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => Parameterpage(), 
                                          )); 
                                        },
                                        icon: Icon(Icons.settings),
                                      ), 

                                    Text("naviguer page des Paramètres", 
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.w600, 
                                        fontSize: 15
                                      )
                                    )),
                                  ],
                                ),

                                //image croper
                                 Padding(
                                  padding: const EdgeInsets.only(top: 20),),
                                 SizedBox(width: 10), 
                                  Row(
                                  children: <Widget> [ 
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => BlogCam(), 
                                          )); 
                                        },
                                        icon: Icon(Icons.add_a_photo)
                                      ), 
                                    Text("prendre une image à partir de la gallerie", 
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.w600, 
                                        fontSize: 13.5
                                      )
                                    )),
                                  ],
                                ),
                                 Padding(
                                  padding: const EdgeInsets.only(top: 20),),
                                 SizedBox(width: 10), 
                                  Row(
                                  children: <Widget> [ 
                                      IconButton(
                                        onPressed: () {
                                        },
                                        icon: Icon(Icons.switch_left)
                                      ), 
                                    Text("App en mode walpaper", 
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.w600, 
                                        fontSize: 15
                                      )
                                    )),
                                  ],
                                ),
                                 Padding(
                                  padding: const EdgeInsets.only(top: 20),),
                                SizedBox(width: 10, height: 165), //280
                                Divider(color: Colors.grey[500],height: 50, thickness: 1, endIndent: 20,),  
                                Row(
                                  children: <Widget> [
                                     IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => DeleteAlertDialogue(), 
                                          )); 
                                          //controller.setSelectedMenuPosition(1); 
                                        },
                                        icon: Icon(Icons.delete),
                                      ), 
                                    Text("quitter l'App", 
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.w600, 
                                        fontSize: 15
                                      )
                                    )),
                                  ],
                                ), 
                                //profile header
                                
                              ],
                            ),
              ),
      
        ],
      ),
    );
  }
}





