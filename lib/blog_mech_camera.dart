import 'package:flutter/material.dart';
import 'package:blog_flutter_prototype/Home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:blog_flutter_prototype/services/crud_sqlite.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class BlogCam extends StatefulWidget {

  @override
  _BlogCamState createState() => _BlogCamState();
}

class _BlogCamState extends State<BlogCam> {
  bool isLoading = false;
  File selectedimage; 
  final picker = ImagePicker();
  String titreonChanged; 
  String descriptiononChanged;
  String pseudoonChanged; 
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
            getImagewithcamera(); 
          }
        ),
      ],
      elevation: 25,
      backgroundColor: Color(0xFF5499C7),
      shape: RoundedRectangleBorder(),  //CircleBorder()
    ); 
  } 
   

   //supprimer ou updtate
  questionNotification(BuildContext context) {
    Map<String, String> cloudMapLocal = {
      "titre": titreonChanged, 
      "pseudonyme": pseudoonChanged, 
      "description": descriptiononChanged, 
      "numberofQuery": numberofQueryScript.toString(), 
      "imageURL":  "jenepeuxpasaccederaulien", 
    };
    return AlertDialog(
        title: Text("Titre AlertDialog"), 
        content: SingleChildScrollView(
          child: ListBody(
            reverse: false,
            mainAxis: Axis.vertical, 
            children: <Widget> [
              Text("Veut tu update ou supprimer les données ?")
            ],
            
          )
        ),
        actions: <Widget> [
          TextButton(
            child: Text("supprimer"), 
            onPressed: () {
              CloudDB.firebaseReference.deleteData();
            }
          ),
           TextButton(
            child: Text("updtate"), 
            onPressed: () {
              CloudDB.firebaseReference.updtateData(cloudMapLocal); 
            }
          ), 

        ],

      ); 
    }


  //pouvoir utiliser la galerie et croper
  Future getImagewithcamera() async {
    PickedFile image = await picker.getImage(source: ImageSource.camera); 
    setState(() {
      if (image != null) {
        selectedimage = File(image.path);
      } else {
        print("aucune image n'a encore été selectionnée"); 
      }
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
      selectedimage  = selected ??  selectedimage;
    }); 

  }

  void clear() {
    setState(() {
      selectedimage = null; 
    });
  }

  void showsupporudtate() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (_) => questionNotification(context)
    );
  }


  void addtoFirebaseStorageImaGall() async { 
    if (selectedimage != null) { 

    setState(() {
      isLoading = true; 
    });
    //TODO: linear progress indicator
    StorageReference firebaseStorageRef = FirebaseStorage.instance
    .ref()
    .child("appImagesStorage")
    .child("${randomAlphaNumeric(10)}.jpg"); 
    final StorageUploadTask finaltask = firebaseStorageRef.putFile(selectedimage); 
    var imageURL;
    if (finaltask.isComplete) {
      try {
        imageURL = firebaseStorageRef.getDownloadURL(); 
      } catch(imageURLerror) {
        print("il y a une erreure concernant imageURL: $imageURLerror"); 
      }
    }
     print("l'url de l'image ayant un nom random: $imageURL");
     Map<String, String> cloudMap = {
      "titre": titreonChanged, 
      "pseudonyme": pseudoonChanged, 
      "description": descriptiononChanged, 
      "numberofQuery": numberofQueryScript.toString(), 
      "imageURL":  imageURL, 
    }; 

    // CloudDB.firebaseReference.addCloudData(cloudMap).then((resultat) => {
    //   Navigator.of(context).pop() 
    // });  

    await CloudDB.firebaseReference.addCloudData(cloudMap);
  
    showDialog(
      context: context, 
        builder: (_) => cropNotification(context), 
        useSafeArea: true, 
        barrierDismissible: true,

    ); 
    } else {
        setState(() {
           isLoading = false; 
           print("il n'y a pas d'images selectionnées");
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
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: () {
                 setState(() {
                  numberofQueryScript++; 
                  print(numberofQueryScript.toString()); 
                }); 
                //appeler methode pour Firbase Storage et Cloud Firestore
                addtoFirebaseStorageImaGall(); 
              },
            )
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.question_answer_outlined),
              onPressed: () {
                setState(() {
                  showsupporudtate();
                });
              },
            ),
          ) 
        ],
      ),
      //container upload image et textfields
      body: isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
      : Container(
          child: Column(
            children: <Widget> [
              SizedBox(height: 10),  
               GestureDetector(
                  onTap: () {
                    getImagewithcamera(); 
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
                          child: Image.file(selectedimage, fit: BoxFit.cover)
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
                                Icons.add_a_photo, 
                                color: Colors.black45,),
                              onPressed: (){
                                print("image picker avec la caméra"); 
                                getImagewithcamera(); 

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
                     descriptiononChanged = value.toLowerCase();  
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