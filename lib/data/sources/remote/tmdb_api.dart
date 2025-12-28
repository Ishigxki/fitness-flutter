import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

/// Make these top-level so the generated file can refer to them.
part 'tmdb_api.g.dart';

const String _tmdbApiKey = String.fromEnvironment('API_KEY', defaultValue: '');
const String _tmdbBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://api.themoviedb.org/3');

@RestApi(baseUrl: _tmdbBaseUrl)
abstract class TMDBApi {
  // Match generated constructor signature (no ParseErrorLogger parameter)
  factory TMDBApi(Dio dio, {String? baseUrl}) = _TMDBApi;

  @GET("/movie/popular")
  Future<Map<String, dynamic>> getPopularMovies({
    @Query("api_key") String key = _tmdbApiKey,
    @Query("page") int page = 1,
    @Query("language") String? language,
  });
}
