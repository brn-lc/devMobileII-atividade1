import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';

class CacheMapa {
  static Future<TileProvider> obterTileProvider() async {
    // Pasta privada do aplicativo
    final dir = await getApplicationSupportDirectory();
    return CachedTileProvider(
      store: FileCacheStore('${dir.path}/cache_mapa'),
    );
  }
}
