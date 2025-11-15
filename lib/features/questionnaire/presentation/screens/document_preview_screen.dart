import 'dart:io';

import 'package:demoai/core/di/injection_container.dart';
import 'package:demoai/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class DocumentPreviewScreen extends StatefulWidget {
  const DocumentPreviewScreen({
    required this.documentPath,
    required this.documentType,
    required this.documentName,
    super.key,
  });

  final String documentPath;
  final String? documentType;
  final String? documentName;

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  bool _loading = true;
  String? _localFilePath;
  String? _publicUrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _preparePreview();
  }

  Future<void> _preparePreview() async {
    setState(() => _loading = true);
    final storage = getIt<StorageService>();
    try {
      final docType = widget.documentType ?? '';
      final isPdf =
          docType.toLowerCase().contains('pdf') ||
          widget.documentPath.toLowerCase().endsWith('.pdf');
      if (isPdf) {
        // Download from storage and write to tmp file
        // Download via our StorageService
        final resp = await storage.downloadDocument(
          filePath: widget.documentPath,
        );
        resp.fold(
          (f) {
            setState(() {
              _error = f.message;
              _loading = false;
            });
          },
          (bytes) async {
            final tempDir = await getTemporaryDirectory();
            final tmpFileName = widget.documentName ?? 'preview';
            final tmpFile = File('${tempDir.path}/$tmpFileName.pdf');
            await tmpFile.writeAsBytes(bytes, flush: true);
            setState(() {
              _localFilePath = tmpFile.path;
              _loading = false;
            });
          },
        );
      } else {
        // Image or other — get public URL
        final url = storage.getPublicUrl(widget.documentPath);
        setState(() {
          _publicUrl = url;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load document: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(widget.documentName ?? 'Preview'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : _localFilePath != null
            ? PDFView(filePath: _localFilePath)
            : _publicUrl != null
            ? Center(
                child: InteractiveViewer(
                  child: Image.network(
                    _publicUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            : const Center(
                child: Text(
                  'No preview available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
