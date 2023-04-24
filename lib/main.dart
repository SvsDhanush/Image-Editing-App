import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:untitled/utils/ImagePickerFunc.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

import 'package:untitled/EditPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        useMaterial3: true,
        primarySwatch: Colors.blue,

      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const MyHomePage(title: 'Select Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  //File imageFile;
  // final ImagePicker _picker = ImagePicker();
  //XFile? image;

  Future pickImage(ImageSource source) async {
    try{
        XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
      );
      if (pickedFile == null) return;

      //final File imageTemp = File(image!.path);

      //final File? imagefile = File(image!.path);
      //setState(() => this.image = imageTemp);
      //this.image = imageTemp;

      //_cropImage(pickedFile.path);

      File? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1080,
        maxHeight: 1080,

        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.blue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),

        iosUiSettings: const IOSUiSettings(
            title: 'Crop Image',
        ),

      );
      if (croppedImage != null) {
        if (!mounted) return;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => EditPage(image: croppedImage)));
      }


      //MaterialPageRoute(builder: (context) => EditPage(arguments: [image],),
    } on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,
            style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,

        //toolbarHeight: 0,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),


            // const SizedBox(
            //   height: 50, // <-- SEE HERE
            // ),

            // const Text(
            //   "Select an image",
            //   style: TextStyle(
            //     fontSize: 20,
            //     //color: Colors.black.withOpacity(1.0),
            //   ),
            // ),


            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              dashPattern: const [10,5,10,5,10,5],
              color: Colors.grey.withOpacity(0.5),
              child: IconButton(
                  icon: const Icon(Icons.photo_library_outlined),
                  tooltip: 'Open gallery',
                  iconSize: 125,
                  color: Colors.grey.withOpacity(0.7),
                  onPressed: () => pickImage(ImageSource.gallery),
              )
            ),

            // SizedBox(
            //   height: 50, // <-- SEE HERE
            // ),


            DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                dashPattern: const [10,5,10,5,10,5],
                color: Colors.grey.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo_outlined),
                  tooltip: 'Open camera',
                  iconSize: 125,
                  color: Colors.grey.withOpacity(0.7),
                  onPressed: () => pickImage(ImageSource.camera),
                )
            ),

            // const SizedBox(
            //   height: 50, // <-- SEE HERE
            // ),

          // Material(
          //   type: MaterialType.transparency,
          //   child: Ink(
          //     decoration: BoxDecoration(
          //       border: Border.all(width: 4),
          //       color: Colors.white,
          //
          //     ),
          //     child: InkWell(
          //       //borderRadius: BorderRadius.circular(100.0),
          //       onTap: () {},
          //       child: const Padding(
          //         padding: EdgeInsets.all(30.0),
          //         child: Icon(
          //           Icons.photo_library_outlined,
          //           size: 80.0,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

            // IconButton(
            //   icon: Icon(Icons.photo_library_outlined),
            //   tooltip: 'Open gallery',
            //   iconSize: 80,

              // style: IconButton.styleFrom(
              //   focusColor: Mcolors.onSurfaceVariant.withOpacity(0.12),
              //   highlightColor: colors.onSurface.withOpacity(0.12),
              //   side: onPressed == null
              //        ? BorderSide(
              //         color: Theme.of(context)
              //           .colorScheme
              //           .onSurface
              //           .withOpacity(0.12))
              //       : BorderSide(color: colors.outline),
              // )

              // style: IconButton.styleFrom(
              //   foregroundColor: colors.onSecondaryContainer,
              //   backgroundColor: colors.secondaryContainer,
              //   disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
              //   hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
              //   focusColor: colors.onSecondaryContainer.withOpacity(0.12),
              //   highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
              //   onPressed: () => pickImage(ImageSource.gallery),
              // ),
            //   onPressed: () => pickImage(ImageSource.gallery),
            //
            // ),

            // IconButton(
            //   icon: const Icon(Icons.add_a_photo_outlined),
            //   tooltip: 'Open camera',
            //   iconSize: 80,
            //   // style: IconButton.styleFrom(
            //   //   foregroundColor: colors.onSecondaryContainer,
            //   //   backgroundColor: colors.secondaryContainer,
            //   //   disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
            //   //   hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
            //   //   focusColor: colors.onSecondaryContainer.withOpacity(0.12),
            //   //   highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
            //   // ),
            //   onPressed: () => pickImage(ImageSource.camera),
            // ),

          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  // /// Get from gallery
  // _getFromGallery() async {
  //   PickedFile pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  // /// Get from Camera
  // _getFromCamera() async {
  //   XFile pickedFile = await _picker().pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  // _cropImage(filePath) async {
  //   File? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: filePath,
  //     maxWidth: 1080,
  //     maxHeight: 1080,
  //   );
  //   if (croppedImage != null) {
  //     pickedFile = croppedImage;
  //     setState(() {});
  //   }
  // }


}


