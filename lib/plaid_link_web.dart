import 'dart:async';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:plaid_link/plaid_js.dart';
import 'package:plaid_link/plaid_link.dart';

class PlaidLinkPlugin {
  final MethodChannel _channel;

  PlaidLinkPlugin(this._channel) {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'plaid_link',
      const StandardMethodCodec(),
      registrar.messenger,
    );
    PlaidLinkPlugin(channel);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'open':
        final Map<dynamic, dynamic> arguments = call.arguments;

        String clientName = arguments['clientName'];
        String publicKey = arguments['publicKey'];
        String env = arguments['env'];
        String language = arguments['language'];
        String publicToken = arguments['publicToken'];
        String linkCustomizationName = arguments['linkCustomizationName'];
        String webhook = arguments['webhook'];
        List<String> countryCodes = (arguments['countryCodes'] as List<dynamic>)
            ?.map((e) => e.toString())
            ?.toList();
        String oauthNonce = arguments['oauthNonce'];
        String oauthRedirectUri = arguments['oauthRedirectUri'];
        List<String> product = (arguments['products'] as List<dynamic>)
            ?.map((e) => e.toString())
            ?.toList();

        // Custom type required for subtypes (not accessed in JS by string).
        PlaidJsAccountSubtypeOptions accountSubtypes;
        if (arguments['accountSubtypes'] != null) {
          List<PlaidAccountSubtype> accountSubtypesList =
          (arguments['accountSubtypes'] as List<dynamic>)
              .map((e) =>
              PlaidAccountSubtype.values.firstWhere((element) =>
              element
                  .toString()
                  .split('.')
                  .last == e.toString()))
              .toList();

          accountSubtypes = PlaidJsAccountSubtypeOptions();
          accountSubtypesList.forEach((subtype) {
            switch (subtype.plaidTypeName) {
              case 'investment':
                accountSubtypes.investment = (accountSubtypes.investment == null
                    ? []
                    : accountSubtypes.investment)
                  ..add(subtype.plaidSubtypeName);
                break;
              case 'credit':
                accountSubtypes.credit = (accountSubtypes.credit == null
                    ? []
                    : accountSubtypes.credit)
                  ..add(subtype.plaidSubtypeName);
                break;
              case 'loan':
                accountSubtypes.loan = (accountSubtypes.loan == null
                    ? []
                    : accountSubtypes.loan)
                  ..add(subtype.plaidSubtypeName);
                break;
              case 'depository':
                accountSubtypes.depository = (accountSubtypes.depository == null
                    ? []
                    : accountSubtypes.depository)
                  ..add(subtype.plaidSubtypeName);
                break;
              case 'other':
                accountSubtypes.other = (accountSubtypes.other == null
                    ? []
                    : accountSubtypes.other)
                  ..add(subtype.plaidSubtypeName);
                break;
            }
          });
        }

        Plaid.create(PlaidOptions(
          clientName: clientName,
          key: publicKey,
          env: env,
          token: publicToken,
          language: language,
          linkCustomizationName: linkCustomizationName,
          webhook: webhook,
          countryCodes: countryCodes,
          oauthNonce: oauthNonce,
          oauthRedirectUri: oauthRedirectUri,
          product: product,
          accountSubtypes: accountSubtypes,
          onLoad: allowInterop(() {
            // No onLoad handled by the library.
          }),
          onEvent: allowInterop((event, metadata) {
            Map<String, dynamic> arguments = {
              'eventName': event.toLowerCase(),
              'metadata': _eventMetadataMap(metadata),
            };
            _channel.invokeMethod('onEvent', arguments);
          }),
          onSuccess: allowInterop((publicToken, metadata) {
            Map<String, dynamic> arguments = {
              'publicToken': publicToken,
              'metadata': _successMetadataToMap(metadata),
            };
            _channel.invokeMethod('onSuccess', arguments);
          }),
          onExit: allowInterop((error, metadata) {
            Map<String, dynamic> arguments = {
              'error': error == null ? null : _errorToMap(error),
              'metadata': _exitMetadataToMap(metadata),
            };
            _channel.invokeMethod('onExit', arguments);
          }),
        )).open();
        break;
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The plaid_link plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}

Map<String, dynamic> _eventMetadataMap(PlaidJsEventMetadata metadata) {
  return {
    'errorCode': metadata.error_code,
    'errorMessage': metadata.error_message,
    'errorType': metadata.error_type,
    'exitStatus': metadata.exit_status,
    'institution': () {
      if (metadata.institution_id != null && metadata.institution_name != null) {
        return {
          'id': metadata.institution_id,
          'name': metadata.institution_name,
        };
      } else {
        return null;
      }
    }(),
    'institutionSearchQuery': metadata.institution_search_query,
    'linkSessionId': metadata.link_session_id,
    'mfaType': metadata.mfa_type,
    'requestId': metadata.request_id,
    'timestamp': metadata.timestamp,
    'viewName': metadata.view_name,
  };
}

Map<String, dynamic> _successMetadataToMap(PlaidJsSuccessMetadata metadata) {
  return {
    'linkSessionId': metadata.link_session_id,
    'institution': _institutionToMap(metadata.institution),
    'accounts': metadata.accounts.map(_accountToMap).toList(),
  };
}

Map<String, dynamic> _exitMetadataToMap(PlaidJsExitMetadata metadata) {
  return {
    'linkSessionId': metadata.link_session_id,
    'requestId': metadata.request_id,
    'status': metadata.status,
    'institution': _institutionToMap(metadata.institution),
  };
}

Map<String, dynamic> _errorToMap(PlaidJsError error) {
  return {
    'error_type': error.error_type,
    'error_code': error.error_code,
    'error_message': error.error_message,
    'display_message': error.display_message,
  };
}

Map<String, dynamic> _institutionToMap(PlaidJsInstitution inst) {
  return {
    'name': inst.name,
    'institutionId': inst.institution_id,
  };
}

Map<String, dynamic> _accountToMap(PlaidJsAccount account) {
  return {
    'id': account.id,
    'name': account.name,
    'mask': account.mask,
    'type': account.type,
    'subtype': account.subtype,
    'verificationStatus': account.verification_status
  };
}
