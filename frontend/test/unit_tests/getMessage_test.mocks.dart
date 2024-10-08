// Mocks generated by Mockito 5.4.4 from annotations
// in namer_app/test/unit_tests/getMessage_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:namer_app/backend/networkconection.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [Backend].
///
/// See the documentation for Mockito's code generation for more information.
class MockBackend extends _i1.Mock implements _i2.Backend {
  MockBackend() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String> sendMessage(
    String? message,
    String? requestpath,
    _i2.requestType? type,
    Map<String, dynamic>? queryParams,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendMessage,
          [
            message,
            requestpath,
            type,
            queryParams,
          ],
        ),
        returnValue: _i3.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #sendMessage,
            [
              message,
              requestpath,
              type,
              queryParams,
            ],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  bool isError(String? response) => (super.noSuchMethod(
        Invocation.method(
          #isError,
          [response],
        ),
        returnValue: false,
      ) as bool);

  @override
  dynamic setHttp(_i5.Client? client) => super.noSuchMethod(Invocation.method(
        #setHttp,
        [client],
      ));
}
