import 'package:max_arch/presentation/widgets/reactor/reactor.dart';

class FakeUserModel with Reactive {
  @override
  final String? id;
  String? name;
  String? email;
  String? internalId;

  FakeUserModel({
    this.id,
    this.name,
    this.email,
    this.internalId,
  });

  @override
  void reactiveCopy(FakeUserModel source) {
    name = source.name;
    email = source.email;
  }

  FakeUserModel copyWith({String? id, String? name, String? email, String? internalId}) {
    return FakeUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      internalId: internalId ?? this.internalId,
    );
  }
}
