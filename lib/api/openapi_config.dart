import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

/// OpenAPI / Swagger Generator configuration class.
/// 
/// Supports input specifications in JSON (Swagger/OpenAPI) and YAML format.
/// 
/// For Swagger/JSON spec:
///   `inputSpec: InputSpec(path: 'swagger.json')` or `inputSpec: InputSpec.json()`
/// For YAML spec:
///   `inputSpec: InputSpec.yaml()` or `inputSpec: InputSpec(path: 'openapi.yaml')`
@Openapi(
  apiPackage: 'openapi_poc_api',
  inputSpec: InputSpec(path: 'swagger.json'),
  generatorName: Generator.dio,
  outputDirectory: 'lib/api/generated',
)
class OpenAPIConfig {}
