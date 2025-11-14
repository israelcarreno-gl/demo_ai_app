import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/core/services/storage_service.dart';

class UploadDocument {
  UploadDocument(this._storageService);

  final StorageService _storageService;

  Future<Either<Failure, String>> call({
    required File file,
    required String userId,
    required String fileName,
  }) async {
    return _storageService.uploadDocument(
      file: file,
      userId: userId,
      fileName: fileName,
    );
  }
}
