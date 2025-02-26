import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pincode_input_fields/pincode_input_fields.dart';
import '../../constants/constant.dart';
import '../../controller/make_request.dart';
import '../../core/pincode_field.dart';
import '../../core/showsnackbar.dart';
import '../../providers/theme_provider.dart';

class DecodeMessage extends ConsumerStatefulWidget {
  const DecodeMessage({super.key, required this.selectedImage});
  final File selectedImage;

  @override
  _DecodeMessageState createState() => _DecodeMessageState();
}

class _DecodeMessageState extends ConsumerState<DecodeMessage> {
  late PincodeInputFieldsController pincodeController;
  String? downloadLink;
  int _selectedIndex = 0;
  String? revealedMessage;

  @override
  void initState() {
    super.initState();
    pincodeController = PincodeInputFieldsController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      revealedMessage = null;
    });
  }

  // function to show the alert dialog
  Future<void> showAlertDialogSeeDownload(
      BuildContext context, String link) async {
    print('download link $link');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: GetColor.backgroundColor(context),
              title: Text('Successfully Decoded'),
              content: Text('Do you want to download or see the file?'),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GetColor.textColor(context),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await launch(link);
                    },
                    child: Text('See & Download',
                        style: TextStyle(
                            color: GetColor.backgroundColor(context)))),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final backgroundColor = GetColor.backgroundColor(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor:
            ref.read(themeProvider.notifier).getTheme == ThemeMode.dark
                ? backgroundColor
                : blackColor,
        title: Text('Decode ${_selectedIndex == 0 ? 'Message' : 'File'} ',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.file(widget.selectedImage),
                  ),
                  SizedBox(height: 20),
                  Text('PIN (optional) if any',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(height: height / 45),
                  buildPincode(height, width, context, pincodeController),
                  SizedBox(height: height / 40),
                  SizedBox(height: MediaQuery.of(context).size.height / 15),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: GetColor.textColor(context)),
                      onPressed: () async {
                        context.loaderOverlay.show();

                        try {
                          if (_selectedIndex == 0) {
                            print('Decoding message');
                            revealedMessage = await MakeRequest().decodeMessage(
                                pin: pincodeController.text,
                                image: widget.selectedImage);

                            setState(() {});
                          } else {
                            downloadLink = await MakeRequest().decodeFile(
                                pin: pincodeController.text,
                                image: widget.selectedImage);
                            context.loaderOverlay.hide();

                            await showAlertDialogSeeDownload(
                                context, downloadLink!);
                          }
                        } catch (e) {
                          show_snackbar(context, e.toString());
                        } finally {
                          if (!mounted) return;
                          context.loaderOverlay.hide();
                        }

                        pincodeController.clear();

                        setState(() {});
                      },
                      child: Text(
                          'Decode ${_selectedIndex == 0 ? 'Message' : 'File'}',
                          style: TextStyle(
                              color: GetColor.backgroundColor(context)))),
                  SizedBox(height: height / 40),
                  revealedMessage != null
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          height: height / 6,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: GetColor.textColor(context), width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              SelectableText(
                                revealedMessage!,
                                style: TextStyle(
                                    color: GetColor.textColor(context)),
                              ),
                              Positioned(
                                right: 0,
                                bottom: -10,
                                child: IconButton(
                                  icon: Icon(Icons.copy,
                                      color: GetColor.textColor(context)),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: revealedMessage!));

                                    show_snackbar(
                                        context, 'Copied to clipboard');
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        curveSize: height / 10,
        curve: Curves.easeInOut,
        height: height / 12,
        backgroundColor: const Color.fromARGB(255, 31, 31, 31),
        items: [
          TabItem(icon: Icons.message, title: 'Message', isIconBlend: true),
          TabItem(icon: Icons.file_copy, title: 'File', isIconBlend: true),
        ],
        initialActiveIndex: 0,
        onTap: (val) {
          _onItemTapped(val);
        },
      ),
    );
  }
}
