# OpenAPI & Swagger Generator Flutter POC

A fully functional Flutter application demonstrating the integration of **OpenAPI / Swagger Generator** (YAML and JSON formats) with **Dio**, **BLoC**, and **Clean Architecture**.

---

## 🚀 Overview

This project serves as a production-ready reference architecture for auto-generating API client code from an `openapi.yaml` or `swagger.json` specification in Flutter. It demonstrates how to seamlessly connect OpenAPI/Swagger-generated code to Clean Architecture layers (Domain, Data, Presentation) using `flutter_bloc` state management.

It includes a built-in simulated backend interceptor so you can run and test the application immediately without needing a running external backend server!

---

## ✨ Features

- **OpenAPI 3.0 & Swagger Code Generation**: Supports both **YAML** (`openapi.yaml`) and **JSON** (`swagger.json` / `openapi.json`) specifications.
- **Configured Generator**: Uses `openapi_generator_annotations` and `openapi_generator` with the `dart-dio` target generator.
- **Clean Architecture**: Clear separation of concerns into Domain, Data, and Presentation layers.
- **BLoC State Management**: Predictable state handling using `flutter_bloc` and `equatable`.
- **Dio Network Client**: Robust HTTP client configured with logging and interceptors.
- **Simulated Network Interceptor**: Built-in mock data handler supporting success (`200 OK`), invalid input (`400 Bad Request`), and missing resource (`404 Not Found`) scenarios out-of-the-box.
- **Interactive Flutter UI**: Modern Material 3 UI with quick-action test chips, loading indicators, user cards, and detailed error handling.

---

## 📐 Architecture

The application strictly adheres to Clean Architecture principles:

```text
┌─────────────────────────────────────────────────────────────────┐
│                       PRESENTATION LAYER                         │
│  UserPage (Flutter UI) ──► UserBloc (Events & States)           │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DOMAIN LAYER                            │
│  GetUserUseCase ──► UserRepository (Interface) ──► UserEntity   │
└─────────────────────────────────▲───────────────────────────────┘
                                  │
                                  │ (Implementation)
┌─────────────────────────────────┴───────────────────────────────┐
│                           DATA LAYER                            │
│  UserRepositoryImpl ──► UserRemoteDataSourceImpl               │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      OPENAPI GENERATED LAYER                    │
│  UserApi (Generated Dio Client) ──► UserDto (Generated Model)   │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                          NETWORK LAYER                          │
│  Dio Client Factory (Base Options & Simulated Interceptor)      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```text
lib/
├── api/
│   ├── openapi_config.dart          # OpenAPI / Swagger Generator config class (@Openapi)
│   └── generated/                   # Generated OpenAPI/Swagger Dio code
│       ├── api_client.dart          # Generated ApiClient wrapper
│       ├── api/
│       │   └── user_api.dart        # Generated UserApi endpoint (Dio)
│       └── model/
│           ├── user_dto.dart        # Generated UserDto model
│           └── user_dto.g.dart      # JSON Serialization mapping
├── core/
│   ├── error/
│   │   └── failures.dart            # Domain Failure abstractions (ServerFailure, etc.)
│   └── network/
│       └── dio_client.dart          # Dio factory with simulated network interceptor
├── features/
│   └── user/
│       ├── domain/                  # Enterprise & Business Logic
│       │   ├── entities/
│       │   │   └── user_entity.dart # Core Domain User entity
│       │   ├── repositories/
│       │   │   └── user_repository.dart # Abstract repository interface
│       │   └── usecases/
│       │       └── get_user_usecase.dart # Fetch User Use Case
│       ├── data/                    # Data Operations & API Mapping
│       │   ├── datasources/
│       │   │   └── user_remote_datasource.dart # Remote data source interface & impl
│       │   └── repositories/
│       │       └── user_repository_impl.dart   # Maps UserDto -> UserEntity & error handling
│       └── presentation/            # User Interface & State Management
│           ├── bloc/
│           │   ├── user_bloc.dart   # BLoC logic
│           │   ├── user_event.dart  # BLoC events
│           │   └── user_state.dart  # BLoC states
│           └── pages/
│               └── user_page.dart   # Interactive User UI Page
├── main.dart                        # App Entry Point & Dependency Injection
├── swagger.json                     # Swagger / OpenAPI JSON API Definition Specification
└── openapi.yaml                     # OpenAPI YAML API Definition Specification
```

---

## 📝 API Specification Formats

This project supports both **Swagger/JSON** (`swagger.json` or `openapi.json`) and **YAML** (`openapi.yaml`).

### Swagger / JSON Format (`swagger.json`)

```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "User API",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://api.mycompany.com"
    }
  ],
  "paths": {
    "/users/{id}": {
      "get": {
        "operationId": "getUser",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Success",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/User"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "User": {
        "type": "object",
        "properties": {
          "id": {
            "type": "integer"
          },
          "name": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

---

## 🔄 Step-by-Step Guide: Re-running Generator for Swagger / JSON or YAML

Follow these steps whenever you update your API spec or add a new API endpoint / model schema:

### Step 1: Update your Specification File
Update `swagger.json` (or `openapi.json` / `openapi.yaml`) with your new paths and component schemas.

---

### Step 2: Configure Generator Input Spec (`lib/api/openapi_config.dart`)

Configure `lib/api/openapi_config.dart` to point to your desired specification file format:

#### For Swagger / JSON Specification:
```dart
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  apiPackage: 'openapi_poc_api',
  inputSpec: InputSpec(path: 'swagger.json'), // Or InputSpec.json() for openapi.json
  generatorName: Generator.dio,
  outputDirectory: 'lib/api/generated',
)
class OpenAPIConfig {}
```

#### For YAML Specification:
```dart
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  apiPackage: 'openapi_poc_api',
  inputSpec: InputSpec.yaml(), // Points to openapi.yaml
  generatorName: Generator.dio,
  outputDirectory: 'lib/api/generated',
)
class OpenAPIConfig {}
```

---

### Step 3: Re-run Code Generation

Run `build_runner` to process the specification and generate/update the Dart Dio API client and model classes:

```bash
# Option A: Using Dart run (Recommended)
dart run build_runner build --delete-conflicting-outputs

# Option B: Using Flutter pub run
flutter pub run build_runner build --delete-conflicting-outputs

# Option C: Using OpenAPI Generator CLI directly for Swagger/JSON
openapi-generator-cli generate -i swagger.json -g dart-dio -o lib/api/generated
```

This will automatically update the files in `lib/api/generated/`:
- `lib/api/generated/model/` (Generated DTO classes & JSON serializers)
- `lib/api/generated/api/` (Generated Dio API endpoint methods)
- `lib/api/generated/api_client.dart` (ApiClient container)

---

### Step 4: Integrate New Endpoint into Clean Architecture

After generating code, connect the new API endpoint into your application layers:

1. **Remote Data Source (`lib/features/.../data/datasources/`)**:
   Add a method to the remote data source interface and implement it by calling your generated API method (e.g. `userApi.createUser(...)`).

2. **Repository (`lib/features/.../data/repositories/` & `domain/repositories/`)**:
   - Define abstract repository method in the Domain layer.
   - Implement the repository in the Data layer, converting generated DTOs to Domain Entities and mapping Dio exceptions to `Failure` instances.

3. **Use Case (`lib/features/.../domain/usecases/`)**:
   Create a dedicated Use Case class encapsulating the business logic for the new API operation.

4. **BLoC & UI (`lib/features/.../presentation/`)**:
   - Add new `UserEvent` and `UserState` classes in your BLoC.
   - Trigger the event from your Flutter UI widgets and render the state using `BlocBuilder`.

---

## ⚙️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.x or higher)

### Installation & Running

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd openapi_poc
   ```

2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Run Flutter Analyze**:
   ```bash
   flutter analyze
   ```

4. **Run Unit & Widget Tests**:
   ```bash
   flutter test
   ```

5. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing Scenarios in App UI

When running the application, you can test various API scenarios using the quick-test chips or entering an ID manually:

| ID Input | Simulated Result | Description |
|---|---|---|
| `1` | `200 OK` | Returns `Alice Smith` |
| `2` | `200 OK` | Returns `Bob Jones` |
| `42` | `200 OK` | Returns `Douglas Adams` |
| `404` | `404 Not Found` | Triggers a `NotFoundFailure` error state |
| `-1` | `400 Bad Request` | Triggers a `ServerFailure` with invalid ID error |

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).
