import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry point to the Plaid Link SDK (platform-independent).
/// 
/// For up-to-date and more detailed documentation, see the Plaid docs:
/// https://plaid.com/docs/#integrating-with-link
class PlaidLink {
  static MethodChannel _channel = MethodChannel('plaid_link');

  /// Starts the Plaid Link interface.
  /// Returns a future which resolves once the call is complete. 
  /// Callbacks may be passed in to respond to various events.
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
          await _handleSuccess(onSuccess, arguments);
          break;
        case 'onEvent':
          await _handleEvent(onEvent, arguments);
          break;
        case 'onExit':
          await _handleExit(onExit, arguments);
          break;
        default:
          throw ArgumentError('Unsupported call: $call');
      }
    });
    await _channel.invokeMethod('open', options._toMap());
  }

  static Future<void> _handleSuccess(
      PlaidSuccessCallback callback, Map<dynamic, dynamic> arguments) async {
    if (callback == null) {
      return;
    }
    String publicToken = arguments['publicToken'];
    final metadata = PlaidSuccessMetadata.fromMap(arguments['metadata']);
    callback(publicToken, metadata);
  }

  static Future<void> _handleEvent(
      PlaidEventCallback callback, Map<dynamic, dynamic> arguments) async {
    if (callback == null) {
      return;
    }
    final eventName = PlaidEventName.values
        .firstWhere((e) => _asEnumName(e) == arguments['eventName']);
    final metadata = PlaidEventMetadata.fromMap(arguments['metadata']);
    callback(eventName, metadata);
  }

  static Future<void> _handleExit(
      PlaidExitCallback callback, Map<dynamic, dynamic> arguments) async {
    if (callback == null) {
      return;
    }
    final error = arguments['error'] == null
        ? null
        : PlaidError.fromMap(arguments['error']);
    final metadata = PlaidExitMetadata.fromMap(arguments['metadata']);
    callback(error, metadata);
  }
}

/// Plaid open options (passed to the platform plugin).
/// 
/// For up-to-date and more detailed documentation, see the Plaid docs:
/// https://plaid.com/docs/#integrating-with-link
class PlaidLinkOptions {
  const PlaidLinkOptions({
    @required this.clientName,
    @required this.env,
    @required this.products,
    this.publicToken,
    this.publicKey,
    this.webhook,
    this.accountSubtypes,
    this.linkCustomizationName,
    this.language,
    this.countryCodes,
  });

  /// Plaid client name.
  final String clientName;

  /// The environment to use.
  final PlaidEnv env;

  /// The public token for a Plaid item (update mode).
  final String publicToken;

  /// The public key for your Plaid account.
  final String publicKey;

  /// The webhook to use for receiving item/transaction updates from Plaid.
  final String webhook;

  /// Plaid products to use for this link.
  final List<PlaidProduct> products;

  /// Account subtypes to filter to.
  final List<PlaidAccountSubtype> accountSubtypes;

  /// Name of a custom link customization.
  final String linkCustomizationName;

  /// The language to use (may be required on some platforms).
  final String language;

  /// List of country codes (may change behavior of the link).
  final List<String> countryCodes;

  Map<String, dynamic> _toMap() {
    return {
      'clientName': clientName,
      'env': env == null ? null : _asEnumName(env),
      'products': products?.map((e) => _asEnumName(e))?.toList(),
      'publicToken': publicToken,
      'publicKey': publicKey,
      'webhook': webhook,
      'accountSubtypes': accountSubtypes?.map((e) => _asEnumName(e))?.toList(),
      'linkCustomizationName': linkCustomizationName,
      'language': language,
      'countryCodes': countryCodes
    };
  }
}

String _asEnumName(e) => e.toString().split('.').last;

/// Plaid environments.
enum PlaidEnv {
  sandbox,
  development,
  production,
}

/// Plaid product types.
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

/// Plaid account subtypes (prefixed by the account type).
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

/// Callback used for handling success.
typedef void PlaidSuccessCallback(
    String publicToken, PlaidSuccessMetadata metadata);

/// Metadata related to the success.
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

/// Data that identifies an institution.
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

  /// The institution name.
  final String name;

  /// The institution id.
  final String id;
}

/// An account returned from the Plaid SDK.
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

  /// The account id.
  final String id;
  /// The account name.
  final String name;
  /// The account number (masked).
  final String mask;
  /// The account type.
  final String type;
  /// The account subtype.
  final String subtype;
  /// The accounts verification status.
  final String verificationStatus;
}

/// Callback used for handling exiting.
/// The [error] may be null in the case there was no error which caused the exit.
typedef void PlaidExitCallback(PlaidError error, PlaidExitMetadata metadata);

/// An error returned from the Plaid SDK.
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

  /// The error code.
  final String errorCode;

  /// The error message.
  final String errorMessage;

  /// The error type.
  final String errorType;

  /// The display message.
  final String displayMessage;
}

/// Data related to exiting the Plaid interface.
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

  /// The exit status.
  final String exitStatus;

  /// The institution.
  final PlaidInstitution institution;

  /// The link session id.
  final String linkSessionId;

  /// The request id.
  final String requestId;

  /// The "status"... Plaid does not make it clear.
  final String status;
}

/// Callback used for handling events.
typedef void PlaidEventCallback(
    PlaidEventName event, PlaidEventMetadata metadata);

/// The name of a Plaid event.
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

/// Data related to an event from Plaid.
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

  /// The error code.
  final String errorCode;

  /// The error message.
  final String errorMessage;

  /// The error type.
  final String errorType;

  /// The exit status.
  final String exitStatus;
  
  /// The institution associated with the event.
  final PlaidInstitution institution;
  
  /// The institution search query.
  final String institutionSearchQuery;

  /// The link session id.
  final String linkSessionId;

  /// The mfa type.
  final String mfaType;
  
  /// The request id.
  final String requestId;

  /// The timestamp of the event.
  final String timestamp;

  /// The view for the event.
  final String viewName;
}
