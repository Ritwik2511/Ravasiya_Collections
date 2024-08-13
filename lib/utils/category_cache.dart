import 'package:ravasiya_collections/request_manager.dart';
// Import the async package

T valueOrDefault<T>(T? value, T defaultValue) =>
    (value is String && value.isEmpty) || value == null ? defaultValue : value;

final _categoryDetailCacheManager = FutureRequestManager<void>();

Future<void> categoryDetailCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _categoryDetailCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearCategoryDetailCacheCache() => _categoryDetailCacheManager.clear();

void clearCategoryDetailCacheCacheKey(String? uniqueKey) =>
    _categoryDetailCacheManager.clearRequest(uniqueKey);

final _subCategoryCacheManager = FutureRequestManager<void>();

Future<void> subCategoryCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _subCategoryCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearSubCategoryCacheCache() => _subCategoryCacheManager.clear();

void clearSubCategoryCacheCacheKey(String? uniqueKey) =>
    _subCategoryCacheManager.clearRequest(uniqueKey);

final _subCategoryDetailCacheManager = FutureRequestManager<void>();

Future<void> subCategoryDetailCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _subCategoryDetailCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearSubCategoryDetailCacheCache() =>
    _subCategoryDetailCacheManager.clear();

void clearSubCategoryDetailCacheCacheKey(String? uniqueKey) =>
    _subCategoryDetailCacheManager.clearRequest(uniqueKey);

final _allTrendingProductCacheManager = FutureRequestManager<void>();

Future<void> allTreandingProductCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _allTrendingProductCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearAllTrendingProductCacheCache() =>
    _allTrendingProductCacheManager.clear();

void clearAllTrendingProductCacheCacheKey(String? uniqueKey) =>
    _allTrendingProductCacheManager.clearRequest(uniqueKey);

final _productDetailRelatedProductCacheManager = FutureRequestManager<void>();

Future<void> productDetailRelatedProductCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _productDetailRelatedProductCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearProductDetailRelatedProductCacheCache() =>
    _productDetailRelatedProductCacheManager.clear();

void clearProductDetailRelatedProductCacheCacheKey(String? uniqueKey) =>
    _productDetailRelatedProductCacheManager.clearRequest(uniqueKey);

final _productDetailCacheManager = FutureRequestManager<void>();

Future<void> productDetailCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _productDetailCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearProductDetailCacheCache() => _productDetailCacheManager.clear();

void clearProductDetailCacheCacheKey(String? uniqueKey) =>
    _productDetailCacheManager.clearRequest(uniqueKey);

final _relatedProductCacheManager = FutureRequestManager<void>();

Future<void> relatedProductCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _relatedProductCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearRelatedProductCacheCache() => _relatedProductCacheManager.clear();

void clearRelatedProductCacheCacheKey(String? uniqueKey) =>
    _relatedProductCacheManager.clearRequest(uniqueKey);

final _myOrderCacheManager = FutureRequestManager<void>();

Future<void> myOrderCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _myOrderCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearMyOrderCacheCache() => _myOrderCacheManager.clear();

void clearMyOrderCacheCacheKey(String? uniqueKey) =>
    _myOrderCacheManager.clearRequest(uniqueKey);

final _shippingAddressCacheManager = FutureRequestManager<void>();

Future<void> shippingAddressCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _shippingAddressCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearShippingAddressCacheCache() => _shippingAddressCacheManager.clear();

void clearShippingAddressCacheCacheKey(String? uniqueKey) =>
    _shippingAddressCacheManager.clearRequest(uniqueKey);

final _randomCategoryCacheManager = FutureRequestManager<void>();

Future<void> randomCategoryCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _randomCategoryCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearRandomCategoryCacheCache() => _randomCategoryCacheManager.clear();

void clearRandomCategoryCacheCacheKey(String? uniqueKey) =>
    _randomCategoryCacheManager.clearRequest(uniqueKey);

final _variationCacheManager = FutureRequestManager<void>();

Future<void> variationCache({
  String? uniqueQueryKey,
  bool? overrideCache,
  required Future<void> Function() requestFn,
}) =>
    _variationCacheManager.performRequest(
      uniqueQueryKey: uniqueQueryKey,
      overrideCache: overrideCache,
      requestFn: requestFn,
    );

void clearVariationCacheCache() => _variationCacheManager.clear();

void clearVariationCacheCacheKey(String? uniqueKey) =>
    _variationCacheManager.clearRequest(uniqueKey);
