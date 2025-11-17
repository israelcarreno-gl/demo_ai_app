import 'package:mocktail/mocktail.dart';

class MockSupabaseClient extends Mock {
  // `from` returns a filter builder for selective queries
  FakeFilterBuilder from(String table) =>
      super.noSuchMethod(Invocation.method(#from, [table]))
          as FakeFilterBuilder;
}

class MockFunctions extends Mock {
  Future<FakeFunctionsResponse?> invoke(String func, {Object? body}) =>
      throw UnimplementedError();
}

class FakeFunctionsResponse {
  FakeFunctionsResponse(this.data);
  final Object? data;
}

class FakeFilterBuilder {
  FakeFilterBuilder(this.result);
  final Object? result;
  FakeFilterBuilder select([String? fields]) => this;
  FakeFilterBuilder eq(String col, Object value) => this;
  Future<Object?> order(String col, {bool ascending = true}) async => result;
  Future<Object?> single() async => result;
  Future<Object?> insert(Object? data) async => result;
  Future<Object?> update(Object? data) async => result;
  Future<Object?> delete() async => result;
}
