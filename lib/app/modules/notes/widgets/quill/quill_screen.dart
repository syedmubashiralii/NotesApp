import 'dart:convert' show jsonDecode, jsonEncode;

// import 'package:example/screens/quill/samples/quill_default_sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'
    show FlutterQuillEmbeds, QuillSharedExtensionsConfigurations;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quill_html_converter/quill_html_converter.dart';
import 'package:quill_pdf_converter/quill_pdf_converter.dart';
import 'package:share_plus/share_plus.dart' show Share;

import 'my_quill_editor.dart';
import 'my_quill_toolbar.dart';

@immutable
class QuillScreenArgs {
  const QuillScreenArgs({required this.document});

  final Document document;
}

class QuillScreen extends StatefulWidget {
  const QuillScreen({
    required this.args,
    super.key,
  });

  final QuillScreenArgs args;

  static const routeName = '/quill';

  @override
  State<QuillScreen> createState() => _QuillScreenState();
}

class _QuillScreenState extends State<QuillScreen> {
  final _controller = QuillController.basic();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();
  var _isReadOnly = false;

  @override
  void initState() {
    super.initState();
    _controller.document = widget.args.document;
    testData();
  }

  decrupt(String dt) {
    // Document document =  Document.fromJson(quillDefaultSample);
    List<dynamic> dt1 = jsonDecode(dt);
    Document document = Document.fromJson(dt1);
    _controller.document = document;
    setState(() {});

    print("document: $document");
  }

  testData() {
    // Document document = Document.fromJson(quillDefaultSample);
    // String dt = jsonEncode(document.toDelta().toJson());
    // print("dt: $dt");
    //
    // decrupt(dt);
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quill'),
        actions: [
          MenuAnchor(
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                    return;
                  }
                  controller.open();
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  final html = _controller.document.toDelta();
                  _controller.document =
                      Document.fromDelta(html);
                },
                child: const Text('Load with HTML'),
              ),
              MenuItemButton(
                onPressed: () async {
                  final pdfDocument = pw.Document();
                  final pdfWidgets =
                      await _controller.document.toDelta().toPdf();
                  pdfDocument.addPage(
                    pw.MultiPage(
                      maxPages: 200,
                      pageFormat: PdfPageFormat.a4,
                      build: (context) {
                        return pdfWidgets;
                      },
                    ),
                  );
                  await Printing.layoutPdf(
                      onLayout: (format) async => pdfDocument.save());
                },
                child: const Text('Print as PDF'),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Share',
            onPressed: () {
              final plainText = _controller.document.toPlainText(
                FlutterQuillEmbeds.defaultEditorBuilders(),
              );
              if (plainText.trim().isEmpty) {
                Get.snackbar(
                  "Notes App",
                  "We can't share empty document, please enter some text first",
                );
                return;
              }
              Share.share(plainText);
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            tooltip: 'Print to log',
            onPressed: () {
              print(
                jsonEncode(_controller.document.toDelta().toJson()),
              );
              Get.snackbar(
                "Notes App",
                'The quill delta json has been printed to the log.',
              );
            },
            icon: const Icon(Icons.print),
          ),
          // const HomeScreenButton(),
        ],
      ),
      body: Column(
        children: [
          if (!_isReadOnly)
            MyQuillToolbar(
              // myContext: appNavigationKey.currentState!.context!,
              controller: _controller,
              focusNode: _editorFocusNode,
            ),
          Builder(
            builder: (context) {
              return Expanded(
                child: MyQuillEditor(
                  configurations: QuillEditorConfigurations(
                    sharedConfigurations: _sharedConfigurations,
                    controller: _controller,
                    // readOnly: _isReadOnly,
                  ),
                  scrollController: _editorScrollController,
                  focusNode: _editorFocusNode,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_isReadOnly ? Icons.lock : Icons.edit),
        onPressed: () => setState(() => _isReadOnly = !_isReadOnly),
      ),
    );
  }

  QuillSharedConfigurations get _sharedConfigurations {
    return const QuillSharedConfigurations(
      // locale: Locale('en'),
      extraConfigurations: {
        QuillSharedExtensionsConfigurations.key:
            QuillSharedExtensionsConfigurations(
          assetsPrefix: 'assets', // Defaults to assets
        ),
      },
    );
  }
}
