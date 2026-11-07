import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder for global providers. Business-layer providers live
/// under `mobile/lib/features/<feature>/` and are registered here
/// as they are implemented (Phase 02+).
final appNameProvider = Provider<String>((ref) => 'myFarm');
