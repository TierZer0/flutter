import 'package:recipe_book/providers/app/app.state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final app = StateProvider<AppState>((ref) => AppState());
