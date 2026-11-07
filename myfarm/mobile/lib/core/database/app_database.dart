import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart'
    show applyWorkaroundToOpenSqliteUsingOpenSynonym;
import 'package:my_farm/core/logging/app_logger.dart';

part 'app_database.g.dart';

/// Placeholder Drift database.
///
/// No business tables exist yet — Phase 02+ adds entity tables
/// under `mobile/lib/features/<feature>/` and they are registered here.
/// This file exists so `flutter pub run build_runner build` succeeds
/// and proves the Drift + SQLite wiring compiles cleanly.
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal(QueryExecutor e) : super(e);

  factory AppDatabase() {
    AppLogger.i('Initializing Drift database');
    return AppDatabase._internal(
      _createExecutor(),
    );
  }

  static QueryExecutor _createExecutor() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = p.join(dbFolder.path, 'my_farm.db');
      AppLogger.d('Database file: $file');

      // Workaround for Web/desktop: load sqlite3 flutter libs
      await applyWorkaroundToOpenSqliteUsingOpenSynonym();

      return NativeDatabase.createInBackground(File(file));
    });
  }

  @override
  int get schemaVersion => 1;
}
