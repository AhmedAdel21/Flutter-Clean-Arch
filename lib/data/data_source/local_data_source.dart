import 'package:temp/app/constants.dart';
import 'package:temp/data/network/error_handler.dart';
import 'package:temp/data/response/responses.dart';

abstract class LocalDataSource {
  HomeResponse getHomeData();
  void saveHomeToCache(HomeResponse homeResponse);
  void clearCache();
  void removeFromCache(CacheKeys key);
}

enum CacheKeys {
  home,
}

class _CacheItemsInterval {
  static const home = Constants.defaultCacheInterval;
}

int _getCacheInterval(CacheKeys key) {
  switch (key) {
    case CacheKeys.home:
      return _CacheItemsInterval.home;
  }
}

class LocalDataSourceImpl implements LocalDataSource {
  // run time cache
  final Map<CacheKeys, CachedItem> _cacheMap = {};

  void _saveToCache(CacheKeys key, CachedItem item) => _cacheMap[key] = item;

  T _getData<T>(CacheKeys key) {
    CachedItem? cachedItem = _cacheMap[key];
    if (cachedItem != null && cachedItem.isValid(_getCacheInterval(key))) {
      // return the response from cache
      return cachedItem.data as T;
    } else {
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  HomeResponse getHomeData() => _getData<HomeResponse>(CacheKeys.home);

  @override
  void saveHomeToCache(HomeResponse homeResponse) =>
      _saveToCache(CacheKeys.home, CachedItem(homeResponse));

  @override
  void clearCache() => _cacheMap.clear();

  @override
  void removeFromCache(CacheKeys key) => _cacheMap.remove(key);
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTime) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool returnValue = (currentTime - cacheTime) <= expirationTime;
    return returnValue;
  }
}
