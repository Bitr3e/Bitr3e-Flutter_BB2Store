import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized before use');
});
