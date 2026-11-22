import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

/// OpenAPI Generator configuration class.
/// 
/// This class uses [Openapi] annotation from `openapi_generator_annotations`
/// to configure code generation from `openapi.yaml`.
/// Target spec: `openapi.yaml`
/// Generator: `Generator.dio` (dart-dio)
/// Output directory: `lib/api/generated`
@Openapi(
  apiPackage: 'openapi_poc_api',
  inputSpec: InputSpec.yaml(),
  generatorName: Generator.dio,
  outputDirectory: 'lib/api/generated',
)
class OpenAPIConfig {}
