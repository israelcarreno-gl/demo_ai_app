import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  StorageService(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  static const String _bucketName = 'questionnaire-documents';

  /// Upload a file to Supabase Storage
  /// Returns the storage path if successful
  Future<Either<Failure, String>> uploadDocument({
    required File file,
    required String userId,
    required String fileName,
  }) async {
    try {
      final filePath = '$userId/$fileName';

      // Use upsert to overwrite if file already exists
      await _supabaseClient.storage
          .from(_bucketName)
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      return Right(filePath);
    } on StorageException catch (e) {
      // If file already exists, still return success with the path
      if (e.message.toLowerCase().contains('already exists')) {
        final filePath = '$userId/$fileName';
        return Right(filePath);
      }
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to upload document: $e'));
    }
  }

  /// Download a file from Supabase Storage
  Future<Either<Failure, List<int>>> downloadDocument({
    required String filePath,
  }) async {
    try {
      final bytes = await _supabaseClient.storage
          .from(_bucketName)
          .download(filePath);

      return Right(bytes);
    } on StorageException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to download document: $e'));
    }
  }

  /// Delete a file from Supabase Storage
  Future<Either<Failure, void>> deleteDocument({
    required String filePath,
  }) async {
    try {
      await _supabaseClient.storage.from(_bucketName).remove([filePath]);

      return const Right(null);
    } on StorageException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete document: $e'));
    }
  }

  /// Get public URL for a file
  String getPublicUrl(String filePath) {
    return _supabaseClient.storage.from(_bucketName).getPublicUrl(filePath);
  }

  /// Check if bucket exists and is accessible
  Future<Either<Failure, bool>> checkBucketAccess() async {
    try {
      await _supabaseClient.storage.from(_bucketName).list();
      return const Right(true);
    } on StorageException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to access bucket: $e'));
    }
  }
}
