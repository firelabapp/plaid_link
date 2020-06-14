import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlaidLink {
  static MethodChannel _channel = MethodChannel('plaid_link');

  static Future<void> open(
    PlaidLinkOptions options, {
    PlaidSuccessCallback onSuccess,
    PlaidEventCallback onEvent,
    PlaidExitCallback onExit,
  }) async {
    _channel.setMethodCallHandler((call) async {
      Map<dynamic, dynamic> arguments = call.arguments;
      switch (call.method) {
        case 'onSuccess':
          await handleSuccess(onSuccess, arguments);
          break;
        case 'onEvent':
          await handleEvent(onEvent, arguments);
          break;
        case 'onExit':
          await handleExit(onExit, arguments);
          break;
        default:
          throw ArgumentError('Unsupported call: $call');
      }
    });
    await _channel.invokeMethod('open', options.toMap());
  }

  static Future<void> handleSuccess(
      PlaidSuccessCallback callback, Map<dynamic, dynamic> arguments) async {
    String publicToken = arguments['publicToken'];
    final metadata = PlaidSuccessMetadata.fromMap(arguments['metadata']);
    callback(publicToken, metadata);
  }

  static Future<void> handleEvent(
      PlaidEventCallback callback, Map<dynamic, dynamic> arguments) async {
    final eventName = PlaidEventName.values
        .firstWhere((e) => asEnumName(e) == arguments['eventName']);
    final metadata = PlaidEventMetadata.fromMap(arguments['metadata']);
    callback(eventName, metadata);
  }

  static Future<void> handleExit(
      PlaidExitCallback callback, Map<dynamic, dynamic> arguments) async {
    final error = arguments['error'] == null
        ? null
        : PlaidError.fromMap(arguments['error']);
    final metadata = PlaidExitMetadata.fromMap(arguments['metadata']);
    callback(error, metadata);
  }
}

// Plaid open options (passed to the platform plugin).

class PlaidLinkOptions {
  const PlaidLinkOptions({
    @required this.clientName,
    @required this.env,
    @required this.products,
    this.publicToken,
    @Deprecated("use publicToken") this.publicKey,
    this.webhook,
    this.accountSubtypes,
    this.linkCustomizationName,
    this.language,
    this.countryCodes,
  });

  final String clientName;

  final PlaidEnv env;

  final String publicToken;

  final String publicKey;

  final String webhook;

  final List<PlaidProduct> products;

  final List<PlaidAccountSubtype> accountSubtypes;

  final String linkCustomizationName;

  final String language;

  final List<String> countryCodes;

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'env': env == null ? null : asEnumName(env),
      'products': products?.map((e) => asEnumName(e))?.toList(),
      'publicToken': publicToken,
      'publicKey': publicKey,
      'webhook': webhook,
      'accountSubtypes': accountSubtypes?.map((e) => asEnumName(e))?.toList(),
      'linkCustomizationName': linkCustomizationName,
      'language': language,
      'countryCodes': countryCodes
    };
  }
}

String asEnumName(e) => e.toString().split('.').last;

enum PlaidEnv {
  sandbox,
  development,
  production,
}

enum PlaidProduct {
  auth,
  transactions,
  identity,
  income,
  assets,
  investments,
  liabilities,
  payment_initiation,
}

enum PlaidAccountSubtype {
  credit_credit_card,
  credit_paypal,
  depository_cash_management,
  depository_cd,
  depository_checking,
  depository_hsa,
  depository_savings,
  depository_money_market,
  depository_paypal,
  depository_prepaid,
  loan_auto,
  loan_commercial,
  loan_construction,
  loan_consumer,
  loan_home_equity,
  loan_loan,
  loan_mortgage,
  loan_overdraft,
  loan_line_of_credit,
  loan_student,
  other_other,
}

extension PlaidAccountSubtypeExtension on PlaidAccountSubtype {
  String get plaidTypeName => toString().split('.').last.split('_').first;

  String get plaidSubtypeName {
    final full = toString().split('.').last;
    return full.substring(full.indexOf('_'));
  }
}

// Callbacks and callback types (passed from the platform plugin).

typedef void PlaidSuccessCallback(
    String publicToken, PlaidSuccessMetadata metadata);

class PlaidSuccessMetadata {
  PlaidSuccessMetadata._({
    this.linkSessionId,
    this.institution,
    this.accounts,
  });

  factory PlaidSuccessMetadata.fromMap(Map<dynamic, dynamic> map) {
    return PlaidSuccessMetadata._(
      linkSessionId: map['linkSessionId'],
      institution: map['institution'] == null
          ? null
          : PlaidInstitution.fromMap(map['institution']),
      accounts: PlaidAccount.fromMaps(map['accounts']),
    );
  }

  final String linkSessionId;
  final PlaidInstitution institution;
  final List<PlaidAccount> accounts;
}

class PlaidInstitution {
  PlaidInstitution._({
    this.name,
    this.id,
  });

  factory PlaidInstitution.fromMap(Map<dynamic, dynamic> map) {
    return PlaidInstitution._(
      name: map['name'],
      id: map['id'],
    );
  }

  final String name;
  final String id;
}

class PlaidAccount {
  PlaidAccount._({
    this.id,
    this.name,
    this.mask,
    this.type,
    this.subtype,
    this.verificationStatus,
  });

  factory PlaidAccount.fromMap(Map<dynamic, dynamic> map) {
    return PlaidAccount._(
      id: map['id'],
      name: map['name'],
      mask: map['mask'],
      type: map['type'],
      subtype: map['subtype'],
      verificationStatus: map['verificationStatus'],
    );
  }

  static List<PlaidAccount> fromMaps(List<dynamic> list) {
    return list.map((e) => PlaidAccount.fromMap(e)).toList();
  }

  final String id;
  final String name;
  final String mask;
  final String type;
  final String subtype;
  final String verificationStatus;
}

typedef void PlaidExitCallback(PlaidError error, PlaidExitMetadata metadata);

class PlaidError {
  PlaidError._({
    this.errorCode,
    this.errorMessage,
    this.errorType,
    this.displayMessage,
  });

  factory PlaidError.fromMap(Map<dynamic, dynamic> map) {
    return PlaidError._(
      errorCode: map['errorCode'],
      errorMessage: map['errorMessage'],
      errorType: map['errorType'],
      displayMessage: map['displayMessage'],
    );
  }

  final String errorCode;
  final String errorMessage;
  final String errorType;
  final String displayMessage;
}

class PlaidExitMetadata {
  PlaidExitMetadata._({
    this.exitStatus,
    this.institution,
    this.linkSessionId,
    this.requestId,
    this.status,
  });

  factory PlaidExitMetadata.fromMap(Map<dynamic, dynamic> map) {
    return PlaidExitMetadata._(
      exitStatus: map['exitStatus'],
      institution: map['institution'] == null
          ? null
          : PlaidInstitution.fromMap(map['institution']),
      linkSessionId: map['linkSessionId'],
      requestId: map['requestId'],
      status: map['status'],
    );
  }

  final String exitStatus;
  final PlaidInstitution institution;
  final String linkSessionId;
  final String requestId;
  final String status;
}

typedef void PlaidEventCallback(
    PlaidEventName event, PlaidEventMetadata metadata);

enum PlaidEventName {
  error,
  exit,
  handoff,
  open,
  open_my_plaid,
  other,
  search_institution,
  select_institution,
  submit_credentials,
  submit_mfa,
  transition_view
}

class PlaidEventMetadata {
  PlaidEventMetadata._({
    this.errorCode,
    this.errorMessage,
    this.errorType,
    this.exitStatus,
    this.institution,
    this.institutionSearchQuery,
    this.linkSessionId,
    this.mfaType,
    this.requestId,
    this.timestamp,
    this.viewName,
  });

  factory PlaidEventMetadata.fromMap(Map<dynamic, dynamic> map) {
    return PlaidEventMetadata._(
      errorCode: map['errorCode'],
      errorMessage: map['errorMessage'],
      errorType: map['errorType'],
      exitStatus: map['exitStatus'],
      institution: map['institution'] == null
          ? null
          : PlaidInstitution.fromMap(map['institution']),
      institutionSearchQuery: map['institutionSearchQuery'],
      linkSessionId: map['linkSessionId'],
      mfaType: map['mfaType'],
      requestId: map['requestId'],
      timestamp: map['timestamp'],
      viewName: map['viewName'],
    );
  }

  final String errorCode;
  final String errorMessage;
  final String errorType;
  final String exitStatus;
  final PlaidInstitution institution;
  final String institutionSearchQuery;
  final String linkSessionId;
  final String mfaType;
  final String requestId;
  final String timestamp;
  final String viewName;
}
