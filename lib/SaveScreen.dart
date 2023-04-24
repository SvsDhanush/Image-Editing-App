//import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
//import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';


class SaveScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const SaveScreen({super.key, required this.imageBytes});



  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

// class _SaveScreenState extends State<SaveScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Save Screen'),
//       ),
//       body: Center(
//         child: Image.memory(widget.imageBytes),
//       ),
//     );
//   }
// }

// class _SaveScreenState extends State<SaveScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Save Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Image Saved!!'),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Continue Editing'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: const Text('Select another Image'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Implement "Share Image" functionality
//               },
//               child: const Text('Share Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



class _SaveScreenState extends State<SaveScreen> {

  late Uint8List receivedImg;

  @override
  void initState() {
    super.initState();
    receivedImg =  widget.imageBytes;
  }



  void shareImage(Uint8List? receivedImg) async {
    if (receivedImg != null) {
      try {
        // get the temporary directory on the device
        final tempDir = await getTemporaryDirectory();

        // create a temporary file for the image
        final imageFile = await File('${tempDir.path}/myimage.png').create();

        // write the bytes of the image to the file
        await imageFile.writeAsBytes(receivedImg);

        // share the image using share_plus plugin
        final xFile = XFile(imageFile.path);
        await Share.shareXFiles([xFile], text: 'Check out my edited image!!', subject: '');

        // delete the temporary file
        await imageFile.delete();
      } catch (e) {
        print('Error: $e');
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50.0;
    const double buttonPadding = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Screen',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Image.asset(
                'assets/images/fotor_2023-3-12_15_19_11.png',
                width: 150.0,
                height: 150.0,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: buttonHeight,
              //width: double.infinity,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: buttonPadding),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Continue Editing', style: TextStyle(color: Colors.blue),),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: buttonHeight,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: buttonPadding),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    //Navigator.pop(context);
                  },
                  child: const Text('Select another Image', style: TextStyle(color: Colors.blue),),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: buttonHeight,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: buttonPadding),
                child: ElevatedButton(
                  onPressed: () {
                    shareImage(receivedImg);
                  },
                  child: const Text('Share Image', style: TextStyle(color: Colors.blue),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





