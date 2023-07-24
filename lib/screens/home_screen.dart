import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/models/images_model.dart';
import '../models/quots_model.dart';
import '../services/api.dart';
import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Api api = Api();

  RandomeQuots? quotsFromApi;
  RandomeImage? imageFromApi;
  bool isLoaded = false;

  void getData() async {
    quotsFromApi = await api.getRandomQuot();
    imageFromApi = await api.getRandomImage();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytes;

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    // if (boundary.debugNeedsPaint) {
    if (kDebugMode) {
      print("Waiting for boundary to be painted.");
    }
    await Future.delayed(const Duration(milliseconds: 20));
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    if (kDebugMode) {
      print(pngBytes);
    }
    if (mounted) {
      _onShareXFileFromAssets(context, byteData);
    }
    //  }
  }

  void _onShareXFileFromAssets(BuildContext context, ByteData? data) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data!.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'screen_shot.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? RepaintBoundary(
              key: globalKey,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.8,
                        fit: BoxFit.cover,
                        image: NetworkImage(imageFromApi!.url),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.2),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          // color: Colors.white.withOpacity(0.0),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoaded = false;
                                        });
                                        getData();
                                      },
                                      icon: const Icon(
                                        Icons.refresh,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  textAlign: TextAlign.center,
                                  quotsFromApi!.content,
                                  style: GoogleFonts.poppins(
                                    height: 1.8,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  color: Colors.purpleAccent,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    quotsFromApi!.author,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.pacifico(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.purpleAccent,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _capturePng,
        backgroundColor: Colors.purpleAccent,
        label: const Text(
          'Take screenshot',
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(
          Icons.share_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
