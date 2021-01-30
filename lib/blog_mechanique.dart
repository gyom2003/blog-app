
import 'package:flutter/material.dart';
import 'package:blog_flutter_prototype/Home.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blog_flutter_prototype/services/crud_sqlite.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';



class BlogMech extends StatefulWidget {
  //constructeur
  @override
  _BlogMechState createState() => _BlogMechState();
}

class _BlogMechState extends State<BlogMech> {
  bool isLoading = false;
  File selectedimage;   
  final picker = ImagePicker();
  String titreonChanged; 
  String descriptiononChanged; 
  String pseudoonChanged; 
  String description; 
  int numberofQueryScript = 0;


  //crop notif builder
  cropNotification(BuildContext context) {
    return AlertDialog(
       title: Text("Hello", 
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.black54, 
          fontWeight: FontWeight.bold, 
          fontSize: 20
        )
      ),), 
      content: Text("Veux tu modifier l'image ou l'utiliser comme elle est ? 👈",
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
           if (selectedimage != null) {
             Image.file(selectedimage); 
             cropImage(); 
           }
          }
        ),

         FlatButton(
          child: Text("Non ✖ mais merci quand même pour le geste", 
          style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w500,  
          ),), 
          onPressed: () {
            Navigator.of(context).pop(false); 
            getImagewithgallerie(); 
          }
        ),
      ],
      elevation: 25,
      backgroundColor: Color(0xFF5499C7),
      shape: RoundedRectangleBorder(),  //CircleBorder()
    ); 
  }

  //pouvoir utiliser la galerie et croper
  Future<void> getImagewithgallerie() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);  
    setState(() {
       selectedimage = File(image.path);
    });
  }

  Future<void> cropImage() async {
    File selected = await ImageCropper.cropImage(
      sourcePath: selectedimage.path, 
      aspectRatioPresets: Platform.isAndroid
      ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
    : [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
    ], 
     androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      )
    );
    setState(() {
      selectedimage = selected; 
    });

  }

  void clear() {
    setState(() {
      selectedimage = null; 
    });
  }

  void addtoFirebaseStorage() async {
    if (selectedimage != null) {

    setState(() {
      print("une image a été selectionnée"); 
      isLoading = true;
    });

    StorageReference firebaseStorageRef = FirebaseStorage.instance
    .ref()
    .child("appImagesStorage")
    .child("${randomAlphaNumeric(10)}.jpg"); 
    //l'ajouter
    final StorageUploadTask finaltask = firebaseStorageRef.putFile(selectedimage); 
    var imageURL = await (await  finaltask.onComplete).ref.getDownloadURL();
    print("l'url de l'image ayant un nom random: $imageURL"); 
    Navigator.of(context).pop(); 

     Map<String, String> cloudMap = {
      "titre": titreonChanged, 
      "pseudonyme": pseudoonChanged, 
      "description": descriptiononChanged, 
      "numberofQuery": numberofQueryScript.toString(), 
      "imageURL":  imageURL, 
    }; 

    CloudDB.firebaseReference.addCloudData(cloudMap).then((resultat) => {
      Navigator.of(context).pop() 
      //else setState ici ?
    });

       showDialog(
        context: context, 
          builder: (_) => cropNotification(context), 
          barrierDismissible: true, 
          useSafeArea: true, 
      ); 
    } else {
      setState(() {
        print("il n'y a pas d'images selectionnées"); 
        isLoading = false; 
      });
    }
  
  }

  //et TextEditingController 
  TextEditingController pseudocontroller; 
  TextEditingController titlecontroller;
  TextEditingController descriptioncontroller;

  @override
  void initState() {
    pseudocontroller = TextEditingController(); 
    titlecontroller = TextEditingController();
    descriptioncontroller = TextEditingController();
    //les écouter
    pseudocontroller.addListener(() {
      printControllersValue(controller: pseudocontroller); 
    }); 
    titlecontroller.addListener(() {
      printControllersValue(controller: titlecontroller); 
    }); 
    descriptioncontroller.addListener(() {
      printControllersValue(controller: descriptioncontroller); 
    }); 
    super.initState(); 
  }

  void dispose() {
    pseudocontroller.dispose(); 
    titlecontroller.dispose(); 
    descriptioncontroller.dispose();
    super.dispose(); 
  }

  void printControllersValue({@required TextEditingController controller}) {
    if (controller == pseudocontroller) {
      print("valeure du TextEditingController: ${controller.value}, et son text: ${controller.text}"); 
    } 
    if (controller == titlecontroller) {
      print("valeure du TextEditingController: ${controller.value}, et son text: ${controller.text}");
    }
    if (controller == descriptioncontroller) {
      print("valeure du TextEditingController: ${controller.value}, et son text: ${controller.text}");

    }

  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width; 

    return Scaffold(
      resizeToAvoidBottomInset: false,
       appBar: AppBar(
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
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(
              builder: (context) => DrawerPage(), 
            )); 
          },
        ), 
        actions: <Widget> [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: () async {
                 setState(() {
                  numberofQueryScript++; 
                  print(numberofQueryScript.toString()); 
                });
                addtoFirebaseStorage(); 
              },
            )
          ), 
        ],
      ),
      //container qui depend du isLoading bool state
      body:  isLoading ? 
      Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
      : Container(
          child: Column(
            children: <Widget> [
              SizedBox(height: 10),  
               GestureDetector(
                  onTap: () {
                    getImagewithgallerie();  
                
                  },
                  child: selectedimage != null ? 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        height: 150, 
                        width: _width,  
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6), 
                          child: Image.file(selectedimage, fit: BoxFit.cover), 
                        ),
                      ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      height: 150, 
                      width: _width,  
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)), 
                      ), 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          IconButton(
                              icon: Icon(
                                Icons.folder_open, 
                                color: Colors.black45,),
                              onPressed: (){
                                print("image picker"); 
                              },
                            ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              
              SizedBox(height: 20), 
              Divider(color: Colors.grey[500],
              thickness: 1), 
               Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: pseudocontroller,
                  onChanged: (value) async {
                    pseudoonChanged = value.toLowerCase(); 
                  },
                  decoration: InputDecoration(
                    hintText: "Votre pseudo", 
                     hintStyle: TextStyle(
                          color: Colors.black54, 
                          fontWeight: FontWeight.w500, 
                        ), 
                        //bordure
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)), 
                          borderSide: BorderSide(color: Colors.transparent,) // Color(0xFF7FB3D5)
                        ), 
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[200]), 
                           borderRadius: BorderRadius.all(Radius.circular(35))
                        ), 
                        prefixIcon: Icon(Icons.title_rounded), 
                        filled: true, 
                        fillColor: Colors.grey[500],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: titlecontroller,
                  onChanged: (value) async { 
                    titreonChanged = value.toLowerCase();
                  },
                  decoration: InputDecoration(
                    hintText: "Le titre de la note", 
                     hintStyle: TextStyle(
                          color: Colors.black54, 
                          fontWeight: FontWeight.w500, 
                        ), 
                        //bordure
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)), 
                          borderSide: BorderSide(color: Colors.transparent,) // Color(0xFF7FB3D5)
                        ), 
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[200]), 
                           borderRadius: BorderRadius.all(Radius.circular(35))
                        ), 
                        prefixIcon: Icon(Icons.title_rounded), 
                        filled: true, 
                        fillColor: Colors.grey[500],
                  ),
                ),
              ), 
              Padding(  
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: descriptioncontroller,
                  onChanged: (value) async {
                    descriptiononChanged  = value.toLowerCase(); 
                  },
                  decoration: InputDecoration(
                    hintText: "La description de la note", 
                     hintStyle: TextStyle(
                          color: Colors.black54, 
                          fontWeight: FontWeight.w500, 
                        ), 
                        //bordure
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)), 
                          borderSide: BorderSide(color: Colors.transparent,) // Color(0xFF7FB3D5)
                        ), 
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[200]), 
                           borderRadius: BorderRadius.all(Radius.circular(35))
                        ), 
                        prefixIcon: Icon(Icons.title_rounded), 
                        filled: true, 
                        fillColor: Colors.grey[500],
                  ),
                ),
              ), 
              
            ],
          ),
        ),
      
    );
  }
}
