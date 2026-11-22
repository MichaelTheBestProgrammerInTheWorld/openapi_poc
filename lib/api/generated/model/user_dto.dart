import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// Generated DTO for [User] schema in openapi.yaml.
@JsonSerializable()
class UserDto {
  final int? id;
  final String? name;

  const UserDto({
    this.id,
    this.name,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
