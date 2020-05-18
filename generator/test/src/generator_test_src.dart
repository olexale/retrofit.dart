import 'dart:io';

import 'package:source_gen_test/annotations.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

@ShouldGenerate(r'''
class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;
''', contains: true)
@RestApi()
abstract class RestClient {}

@ShouldGenerate(r'''
class _BaseUrl implements BaseUrl {
  _BaseUrl(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://httpbin.org/';
  }

  final Dio _dio;

  String baseUrl;
}
''', contains: true)
@RestApi(baseUrl: "http://httpbin.org/")
abstract class BaseUrl {}

@ShouldGenerate(
  r'''
    const _extra = <String, dynamic>{};
''',
  contains: true,
)
@RestApi()
abstract class EmptyExtras {
  @GET('/list/')
  @Extra({})
  Future<void> list();
}

@ShouldGenerate(
  r'''
    const _extra = <String, dynamic>{'key': 'value'};
''',
  contains: true,
)
@RestApi()
abstract class ExtrasWithPrimitiveValues {
  @GET('/list/')
  @Extra({'key': 'value'})
  Future<void> list();
}

@ShouldGenerate(
  r'''
    const _extra = <String, dynamic>{'key': CustomConstant()};
''',
  contains: true,
)
@RestApi()
abstract class ExtrasWithCustomConstant {
  @GET('/list/')
  @Extra({'key': CustomConstant()})
  Future<void> list();
}

class CustomConstant {
  const CustomConstant();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'GET',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpGetTest {
  @GET("/get")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'POST',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPostTest {
  @POST("/post")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'PUT',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPutTest {
  @PUT("/put")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'DELETE',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpDeleteTest {
  @DELETE("/delete")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'PATCH',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPatchTest {
  @PATCH("/delete")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
    contentType: 'application/x-www-form-urlencoded',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FormUrlEncodedTest {
  @POST("/get")
  @FormUrlEncoded()
  Future<String> ip();
}

@ShouldGenerate(
  r'''
    final _data = FormData();
    _data.files.add(MapEntry(
        'image',
        MultipartFile.fromFileSync(image.path,
            filename: image.path.split(Platform.pathSeparator).last)));
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FilePartTest {
  @POST("/profile")
  Future<String> setProfile(@Part() File image);
}

@ShouldGenerate(
  r'''
    final _data = FormData();
    _data.files.add(MapEntry(
        'image',
        MultipartFile.fromFileSync(image.path,
            filename: 'my_profile_image.jpg')));
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FilePartWithCustomNameTest {
  @POST("/profile")
  Future<String> setProfile(
      @Part(name: 'image', fileName: 'my_profile_image.jpg') File image);
}

@ShouldGenerate(
  r'''
    final _data = FormData();
    _data.files.add(MapEntry(
        'image',
        MultipartFile.fromFileSync(image.path,
            filename: image.path.split(Platform.pathSeparator).last)));
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class UploadFileInfoPartTest {
  @POST("/profile")
  Future<String> setProfile(@Part() File image);
}

@ShouldGenerate(
  r'''
    final value = User.fromJson(_result.data);
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class GenericCast {
  @POST("/users/1")
  Future<User> getUser();
}

class User {
  User();
  factory User.fromJson(Map<String, dynamic> json) {
    return User();
  }
  Map<String, dynamic> toJson() {
    return {};
  }
}

@ShouldGenerate(
  r'''
    final value = _result.data;
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class GenericCastBasicType {
  @POST("/users/1")
  Future<String> getUser();
}

@ShouldGenerate(
  r'''
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestObjectBody {
  @POST("/users")
  Future<String> createUser(@Body() User user);
}

@ShouldGenerate(
  r'''
    final queryParameters = <String, dynamic>{r'u': u?.toJson()};
    queryParameters.addAll(user1?.toJson() ?? <String, dynamic>{});
    queryParameters.addAll(user2?.toJson() ?? <String, dynamic>{});
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestObjectQueries {
  @POST("/users")
  Future<String> createUser(@Query('u') User u, @Queries() User user1, @Queries() User user2);
}

class CustomObject {
  final String id;
  CustomObject(this.id);
}

@ShouldGenerate(
    r'''
    final _data = customObject;
''',
    contains: true,
    expectedLogItems: [
      "CustomObject must provide a `toJson()` method which return a Map.\n"
          "It is programmer's responsibility to make sure the CustomObject is properly serialized",
    ])
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestCustomObjectBody {
  @POST("/custom-object")
  Future<String> createCustomObject(@Body() CustomObject customObject);
}

@ShouldGenerate(
  r'''
    var value = _result.data.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => User.fromJson(i as Map<String, dynamic>))
            .toList()));

''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestMapBody {
  @GET("/xx")
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  r'''
    var value = _result.data.map((k, dynamic v) =>
        MapEntry(k, User.fromJson(v as Map<String, dynamic>)));
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestMapBody2 {
  @GET("/xx")
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data.cast<String>();
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListString {
  @GET("/xx")
  Future<List<String>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data.cast<bool>();
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListBool {
  @GET("/xx")
  Future<List<bool>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data.cast<int>();
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListInt {
  @GET("/xx")
  Future<List<int>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data.cast<double>();
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListDouble {
  @GET("/xx")
  Future<List<double>> getResult();
}

@ShouldGenerate(
  "cancelToken: cancelToken",
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestCancelToken {
  @POST("/users")
  Future<String> createUser(
      @Body() User user, @CancelRequest() CancelToken cancelToken);
}

@ShouldGenerate(
  "onSendProgress: onSendProgress",
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestSendProgress {
  @POST("/users")
  Future<String> createUser(
      @Body() User user, @SendProgress() ProgressCallback onSendProgress);
}

@ShouldGenerate(
  "onReceiveProgress: onReceiveProgress",
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestReceiveProgress {
  @POST("/users")
  Future<String> createUser(
      @Body() User user, @ReceiveProgress() ProgressCallback onReceiveProgress);
}

@ShouldGenerate(r'''
        options: RequestOptions(
            method: 'HEAD',
''', contains: true)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestHeadMethod {
  @HEAD("/")
  Future<String> testHeadMethod();
}

@ShouldGenerate(r'''
        options: RequestOptions(
            method: 'OPTIONS',
''', contains: true)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestOptionsMethod {
  @OPTIONS("/")
  Future<String> testOptionsMethod();
}

@ShouldGenerate(r'''
    final httpResponse = HttpResponse(null, _result);
''', contains: true)
@RestApi()
abstract class TestHttpResponseVoid {
  @GET("/")
  Future<HttpResponse<void>> noResponseData();
}

@ShouldGenerate(r'''
    final httpResponse = HttpResponse(value, _result);
''', contains: true)
@RestApi()
abstract class TestHttpResponseObject {
  @GET("/")
  Future<HttpResponse<Map<String, dynamic>>> responseWithObject();
}

@ShouldGenerate(r'''
    final httpResponse = HttpResponse(value, _result);
''', contains: true)
@RestApi()
abstract class TestHttpResponseArray {
  @GET("/")
  Future<HttpResponse<List<String>>> responseWithArray();
}

@ShouldGenerate(r'''
    final _data = FormData();
    _data.files.addAll(files?.map((i) => MapEntry(
        'files',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
''', contains: true)
@ShouldGenerate(r'''
    if (file != null) {
      _data.files.add(MapEntry(
          'file',
          MultipartFile.fromFileSync(file.path,
              filename: file.path.split(Platform.pathSeparator).last)));
    }
''', contains: true)
@RestApi()
abstract class TestFileList {
  @POST("/")
  Future<void> testFileList(@Part() List<File> files);

  @POST("/")
  Future<void> testOptionalFile({@Part() File file});
}

@ShouldGenerate(r'''
    final _data = FormData();
    _data.fields.add(MapEntry('users', jsonEncode(users)));
''', contains: true)
@ShouldGenerate(r'''
    final _data = FormData();
    _data.fields.add(MapEntry('item', jsonEncode(user ?? <String, dynamic>{})));
    ''', contains: true)
@ShouldGenerate(r'''
    final _data = FormData();
    _data.fields.add(MapEntry('mapList', jsonEncode(mapList)));
    ''', contains: true)
@ShouldGenerate(r'''
    final _data = FormData();
    _data.fields.add(MapEntry('map', jsonEncode(map)));
''', contains: true)
@ShouldGenerate(r'''
    if (a != null) {
      _data.fields.add(MapEntry('a', a.toString()));
    }
    if (b != null) {
      _data.fields.add(MapEntry('b', b.toString()));
    }
    if (c != null) {
      _data.fields.add(MapEntry('c', c.toString()));
    }
    if (d != null) {
      _data.fields.add(MapEntry('d', d));
    }
''', contains: true)
@RestApi()
abstract class TestModelList {
  @POST("/")
  Future<void> testUserList(@Part() List<User> users);

  @POST("/")
  Future<void> testUser(@Part(name: "item") User user);

  @POST("/")
  Future<void> testListMap(@Part() List<Map<String, dynamic>> mapList);

  @POST("/")
  Future<void> testMap(@Part() Map<String, dynamic> map);

  @POST("/")
  Future<void> testBasicType(
    @Part() int a,
    @Part() bool b,
    @Part() double c,
    @Part() String d,
  );
}

@ShouldGenerate(r'''
  RequestOptions newRequestOptions(Options options) {
    if (options is RequestOptions) {
      return options;
    }
    if (options == null) {
      return RequestOptions();
    }
    return RequestOptions(
      method: options.method,
      sendTimeout: options.sendTimeout,
      receiveTimeout: options.receiveTimeout,
      extra: options.extra,
      headers: options.headers,
      responseType: options.responseType,
      contentType: options.contentType.toString(),
      validateStatus: options.validateStatus,
      receiveDataWhenStatusError: options.receiveDataWhenStatusError,
      followRedirects: options.followRedirects,
      maxRedirects: options.maxRedirects,
      requestEncoder: options.requestEncoder,
      responseDecoder: options.responseDecoder,
    );
  }
''', contains: true)
@ShouldGenerate(r'''
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(<String, dynamic>{});
    await _dio.request<void>('',
        queryParameters: queryParameters,
        options: newOptions.merge(method: 'GET', baseUrl: baseUrl),
        data: _data);
    ''', contains: true)
@RestApi()
abstract class CustonOptions {
  @GET("")
  Future<void> testOptions(@DioOptions() Options options);
}

@ShouldGenerate(
  r'''
    final value = JsonMapper.deserialize<User>(_result.data);
    return Future.value(value);
''',
  contains: true,
)
@RestApi(
  baseUrl: "https://httpbin.org/",
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperGenericCast {
  @POST("/xx")
  Future<User> getUser();
}

@ShouldGenerate(
  r'''
    var value = _result.data
        .map((dynamic i) =>
            JsonMapper.deserialize<User>(i as Map<String, dynamic>))
        .toList();
''',
  contains: true,
)
@RestApi(
  baseUrl: "https://httpbin.org/",
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperTestListBody {
  @GET("/xx")
  Future<List<User>> getResult();
}

@ShouldGenerate(
  r'''
    var value = _result.data.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => JsonMapper.deserialize<User>(i as Map<String, dynamic>))
            .toList()));

''',
  contains: true,
)
@RestApi(
  baseUrl: "https://httpbin.org/",
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperTestMapBody {
  @GET("/xx")
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  r'''
    var value = _result.data.map((k, dynamic v) =>
        MapEntry(k, JsonMapper.deserialize<User>(v as Map<String, dynamic>)));
''',
  contains: true,
)
@RestApi(
  baseUrl: "https://httpbin.org/",
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperTestMapBody2 {
  @GET("/xx")
  Future<Map<String, User>> getResult();
}
