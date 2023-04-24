import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:on_image_matrix/on_image_matrix.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'SaveScreen.dart';
import 'main.dart';




class EditPage extends StatefulWidget {
  // final XFile editImg;
  // EditPage({required this.editImg});

  final File image;
  const EditPage({
    Key? key,
    required this.image,
  }) : super(key: key);



  // final List arguments;
  // EditPage({required this.arguments});
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late File _imageFile;
  late File imageFile;
  late File noChangeImageFile;

  @override
  void initState() {
    super.initState();
    _imageFile =  File(widget.image.path);
  }

  int _selectedIndex = 0;
  bool satShow = true;
  bool conShow = false;

  bool bandw = false;
  double sat = 1;
  double con = 1;

  late Uint8List pngBytes;


  void _updateImage(File editedImage) {
    setState(() {
      _imageFile = editedImage;
    });
  }

  GlobalKey widgetKey = GlobalKey();


  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if(_selectedIndex == 1){
      setState(() {
        satShow = false;
        conShow = true;
      });
    }
    if(_selectedIndex == 0) {
      setState(() {
        satShow = true;
        conShow = false;
      });
    }
    if(_selectedIndex == 2){
      setState(() async {
        satShow = false;
        conShow = false;
        if(bandw == true){
          bandw = false;
        }else{
          bandw = true;
        }


          // Write the function needed to be called ***

      });
      // File editedGrayImage = await convertImageToGrayscale(_imageFile);
      //
      // setState(() {
      //   _imageFile = editedGrayImage;
      // });
      // _updateImage(editedGrayImage);
    }
  }

  // Future saveImage() async {
  //   renameImage();
  //   await GallerySaver.saveImage(_imageFile.path);
  // }
  //
  // void renameImage() {
  //   String ogPath = _imageFile.path;
  //   List<String> ogPathList = ogPath.split('/');
  //   String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
  //   DateTime today = DateTime.now();
  //   String dateSlug =
  //       "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
  //   _imageFile = _imageFile.renameSync(
  //       "${ogPath.split('/image')[0]}/PhotoEditor_$dateSlug.$ogExt");
  //   debugPrint(_imageFile.path);
  // }


  String getDateTimeForFileName() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    String formattedTime = DateFormat('HHmmss').format(now);
    return '${formattedDate}_$formattedTime';
  }


  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  // void pushNextPage() {
  //   Navigator.push(
  //     context as BuildContext,
  //     MaterialPageRoute(
  //       builder: (context) => SaveScreen(imageBytes: pngBytes),
  //     ),
  //   );
  // }


  Future<void> saveWidgetAsImage(GlobalKey widgetKey, String fileName) async {
    try {
      RenderRepaintBoundary boundary =
      widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData!.buffer.asUint8List();
      await ImageGallerySaver.saveImage(pngBytes, name: fileName);

      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => SaveScreen(imageBytes: pngBytes)));

    } catch (e) {
      print(e);
    }
  }


  // void _showSaveDialog() async {
  //   return showDialog<void>(
  //     context: this.context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog( // <-- SEE HERE
  //         title: const Text('Save Image'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Continue Editing'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Save Image'),
  //             onPressed: () async {
  //
  //               showToast("Saving image to Gallery...");
  //               await saveWidgetAsImage(widgetKey, getDateTimeForFileName());
  //
  //               // final imageBytes = await _imageFile.readAsBytes();
  //               // final result = await ImageGallerySaver.saveImage(imageBytes);
  //
  //               //saveImage();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showExitEditDialog() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Select image??'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Unsaved changes will be lost!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue editing'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select another image'),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------
//   Future<File> convertImageToGrayscale(File grayImageFile) async {
//     final grayDecode = img.decodeImage(await grayImageFile.readAsBytes());
//     final grayscaleImage = img.grayscale(grayDecode!);
//     final finalGrayImage = await imageFile.writeAsBytes(img.encodePng(grayscaleImage));
//     return finalGrayImage;
//   }
//----------------------------------------------------------------------------------------------------------------------------------------------------



  // Future<File> applyFilter(File imageFile, List<List<double>> filter) async {
  //   // Load the modifyingImg from the file
  //   ui.Image modifyingImg = await decodeImageFromList(await imageFile.readAsBytes());
  //
  //   // Convert the modifyingImg to an RGBA matrix
  //   List<int> rgba = List<int>.filled(modifyingImg.width * modifyingImg.height * 4, 0, growable: true);
  //   int i = 0;
  //   for (int y = 0; y < modifyingImg.height; y++) {
  //     for (int x = 0; x < modifyingImg.width; x++) {
  //       int color = modifyingImg.getPixel(x, y);
  //       rgba[i++] = (color >> 16) & 0xff;
  //       rgba[i++] = (color >> 8) & 0xff;
  //       rgba[i++] = color & 0xff;
  //       rgba[i++] = (color >> 24) & 0xff;
  //     }
  //   }
  //
  //   // Perform the filter on the RGBA matrix
  //   List<int> filteredRgba = List<int>.filled(rgba.length, 0, growable: true);
  //   for (int y = 0; y < modifyingImg.height; y++) {
  //     for (int x = 0; x < modifyingImg.width; x++) {
  //       int filteredR = 0, filteredG = 0, filteredB = 0, filteredA = 0;
  //       for (int i = 0; i < filter.length; i++) {
  //         for (int j = 0; j < filter[0].length; j++) {
  //           int xPos = x + j - (filter[0].length - 1) ~/ 2;
  //           int yPos = y + i - (filter.length - 1) ~/ 2;
  //           if (xPos >= 0 && xPos < modifyingImg.width && yPos >= 0 && yPos < modifyingImg.height) {
  //             int index = 4 * (yPos * modifyingImg.width + xPos);
  //             filteredR += (rgba[index] * filter[i][j]) as int;
  //             filteredG += (rgba[index + 1] * filter[i][j]) as int;
  //             filteredB += (rgba[index + 2] * filter[i][j]) as int;
  //             filteredA += (rgba[index + 3] * filter[i][j]) as int;
  //           }
  //         }
  //       }
  //       filteredR = filteredR.clamp(0, 255);
  //       filteredG = filteredG.clamp(0, 255);
  //       filteredB = filteredB.clamp(0, 255);
  //       filteredA = filteredA.clamp(0, 255);
  //       int index = 4 * (y * modifyingImg.width + x);
  //       filteredRgba[index] = filteredR;
  //       filteredRgba[index + 1] = filteredG;
  //       filteredRgba[index + 2] = filteredB;
  //       filteredRgba[index + 3] = filteredA;
  //     }
  //   }
  //
  //   // Convert the filtered RGBA matrix back to an modifyingImg
  //   ui.Image filteredImage = ui.Image(


//----------------------------------------------------------------------------------------------------------------------------------------------------


  // Future<File> applyFilter(File imageFileFilter, List<List<double>> filter) async {
  //   // Load the modifyImg from the file
  //   ui.Codec codec = await ui.instantiateImageCodec(await imageFileFilter.readAsBytes());
  //   ui.FrameInfo frame = await codec.getNextFrame();
  //   ui.Image modifyImg = frame.modifyImg;
  //
  //   // Convert the image to an RGBA matrix
  //   List<int> rgba = List<int>(image.width * image.height * 4);
  //   int i = 0;
  //   for (int y = 0; y < modifyImg.height; y++) {
  //     for (int x = 0; x < modifyImg.width; x++) {
  //       int color = modifyImg.getPixel(x, y);
  //       rgba[i++] = (color >> 16) & 0xff;
  //       rgba[i++] = (color >> 8) & 0xff;
  //       rgba[i++] = color & 0xff;
  //       rgba[i++] = (color >> 24) & 0xff;
  //     }
  //   }
  //
  //
  //   // Perform the filter on the RGBA matrix
  //   int width = modifyImg.width;
  //   int height = modifyImg.height;
  //   List<int> filteredRgba = List<int>.filled(rgba.length, 0, growable: true);
  //   for (int y = 0; y < height; y++) {
  //     for (int x = 0; x < width; x++) {
  //       int filteredR = 0, filteredG = 0, filteredB = 0, filteredA = 0;
  //       for (int i = 0; i < filter.length; i++) {
  //         for (int j = 0; j < filter[0].length; j++) {
  //           int xPos = x + j - (filter[0].length - 1) ~/ 2;
  //           int yPos = y + i - (filter.length - 1) ~/ 2;
  //           if (xPos >= 0 && xPos < width && yPos >= 0 && yPos < height) {
  //             int index = 4 * (yPos * width + xPos);
  //             filteredR += (rgba[index] * filter[i][j]) as int;
  //             filteredG += (rgba[index + 1] * filter[i][j]) as int;
  //             filteredB += (rgba[index + 2] * filter[i][j]) as int;
  //             filteredA += (rgba[index + 3] * filter[i][j]) as int;
  //           }
  //         }
  //       }
  //       filteredR = filteredR.clamp(0, 255);
  //       filteredG = filteredG.clamp(0, 255);
  //       filteredB = filteredB.clamp(0, 255);
  //       filteredA = filteredA.clamp(0, 255);
  //       int index = 4 * (y * width + x);
  //       filteredRgba[index] = filteredR;
  //       filteredRgba[index + 1] = filteredG;
  //       filteredRgba[index + 2] = filteredB;
  //       filteredRgba[index + 3] = filteredA;
  //     }
  //   }
  //
  //   // Convert the filtered RGBA matrix back to an modifyImg
  //   ui.Codec codec = await ui.instantiateImageCodec(filteredRgba, targetWidth: width, targetHeight: height);
  //   ui.FrameInfo frame = await codec.getNextFrame();
  //   ByteData byteData = await frame.modifyImg.toByteData(format: ui.ImageByteFormat.rgba8888);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();
  //   File filteredImageFile = File('filtered_image.png')..writeAsBytesSync(pngBytes);
  //
  //   return filteredImageFile;
  //
  // }
//------------------------------------------------------------------------------------------------------------------------------------

  // Future<File> applyMatrixFilter(File imageFile, List<double> customMatrix) async {
  //   final image = await decodeImageFromList(await imageFile.readAsBytes());
  //   final modifiedImage = OnImageMatrix.custom(image, customMatrix);
  //   final byteData = await modifiedImage.toByteData(format: ImageByteFormat.rawRgba);
  //   return await imageFile.writeAsBytes(byteData.buffer.asUint8List());
  // }


  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];
  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  final bandwFilter = const <double>[
    0.000, 1.000, 0.000, 0.000, 0.000,
    0.000, 1.000, 0.000, 0.000, 0.000,
    0.000, 1.000, 0.000, 0.000, 0.000,
    0.000, 1.000, 0.000, 1.000, 0.00
  ];

//---------------------------------------------------------
    

  Widget buildImage() {
    if(!bandw){
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(calculateSaturationMatrix(sat)),
          child: Image.file(
            _imageFile,
          ),
          // height: 400,
          // width: 250,),
        ),
      );
    }
    else{
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(calculateSaturationMatrix(sat)),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(bandwFilter),
            child: Image.file(
              _imageFile,
            ),
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    //final File imageTemp;

    //_imageFile = File(widget.image.path);
    noChangeImageFile = _imageFile;
    Color myColor = Color(0xFF757375);


    return Scaffold(
      appBar: AppBar(

        //title: const Text('Editing Page'),
          title: const Text('Edit Image',
            style: const TextStyle(color: Colors.white),),

          leading: IconButton(
            onPressed: _showExitEditDialog,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
               setState(() {
                 //_updateImage(noChangeImageFile);
                 _imageFile = noChangeImageFile;
                 sat = 1;
                 con = 1;
                 bandw = false;
                 _onItemTapped(0);
               });
               },
              icon: const Icon(Icons.undo_outlined, color: Colors.white)
            ),

            IconButton(
                onPressed: () async{
                    await saveWidgetAsImage(widgetKey, getDateTimeForFileName());
                },
    //() {

    // final String duplicateFilePath = (await getApplicationDocumentsDirectory()).path;
    // final fileName = basename(imageFile.path);
    // final String fileExtension = extension(imageFile.path);
    // final File localImage = await imageFile.copy('$duplicateFilePath/$fileName/$fileExtension');
    //

    // setState(() {
    //   imageFile = localImage;
    // });

    //_showSaveDialog;
    //},
                icon: const Icon(Icons.save, color: Colors.white)
              ),
          ],
      backgroundColor: Colors.blue,
    ),



    body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

    RepaintBoundary(
    key: widgetKey,
    child: SizedBox(
    // height: MediaQuery.of(context).size.width,
    // width: MediaQuery.of(context).size.width,
    child: buildImage(),
    // child: AspectRatio(
    //   aspectRatio: 1,
    //   child: buildImage(),
    //   //_imageFile = buildImage();
    // ),
    ),

    )

    ],


    )
    ),


    persistentFooterButtons: [
    Visibility(
    visible: satShow,
    child: Row(
    children: [
    Expanded(
    child: CupertinoSlider(
    //label: 'sat : ${sat.toStringAsFixed(2)}',
    activeColor: CupertinoColors.inactiveGray.withOpacity(0.3),
                    //trackColor: Colors.grey,
                    //thumbColor: CupertinoColors.systemGrey,
                    thumbColor: myColor,
                    onChanged: (double value) {
                      setState(() {
                        sat = value;
                      });
                    },
                    value: sat,
                    min: 0,
                    max: 2,
                  ),
                ),
                const SizedBox(width: 10),
                Text(sat.toStringAsFixed(2)),
              ],
            ),
          ),

          Visibility(
            visible: conShow,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoSlider(
                    //label: 'con : ${con.toStringAsFixed(2)}',
                    activeColor: CupertinoColors.inactiveGray.withOpacity(0.3),
                    //inactiveColor: Colors.grey,
                    thumbColor: myColor,
                    onChanged: (double value) {
                      setState(() {
                        con = value;
                      });
                    },
                    value: con,
                    min: 0,
                    max: 2,
                  ),
                ),
                const SizedBox(width: 10),
                Text(con.toStringAsFixed(2)),
              ],
            ),
          ),
        ],



        bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[

                  BottomNavigationBarItem(
                    icon: Icon(Icons.brush),
                    label: "Saturation",
                  ),
                  BottomNavigationBarItem(
                  icon: Icon(Icons.color_lens),
                  label: "Contrast",
                  ),

                  BottomNavigationBarItem(
                      icon: Icon(Icons.filter_b_and_w),
                      label: "Black and White",
                  ),
                ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            )




    );
  }
  // _cropImage(filePath) async {
  //   File? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: filePath,
  //     maxWidth: 1080,
  //     maxHeight: 1080,
  //   );
  //   if (croppedImage != null) {
  //     imageFile = croppedImage;
  //     setState(() {});
  //   }
  // }

}