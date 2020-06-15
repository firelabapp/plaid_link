import 'package:flutter/material.dart';
import 'package:plaid_link/plaid_link.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plaid Link Example'),
        ),
        body: AppContent(),
      ),
    ),
  );
}

// Options can be const if desired.
const plaidLinkOptions = const PlaidLinkOptions(
  clientName: 'Plaid Link Example',
  publicKey: 'YOUR_PLAID_PUBLIC_KEY',
  env: PlaidEnv.sandbox,
  products: [PlaidProduct.auth],
  language: 'en',
);

class AppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Open Plaid'),
        onPressed: () {
          PlaidLink.open(
            plaidLinkOptions,
            onEvent: onEvent,
            onSuccess: onSuccess(context),
            onExit: onExit(context),
          );
        },
      ),
    );
  }

  void onEvent(PlaidEventName event, PlaidEventMetadata metadata) {
    print('Got event: event=$event, metadata=$metadata');
  }

  PlaidSuccessCallback onSuccess(BuildContext context) {
    return (String publicToken, PlaidSuccessMetadata metadata) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                Text('Successful Plaid Link'),
                Text('publicToken: $publicToken'),
                Text('linkSessionId: ${metadata.linkSessionId}'),
                Text(
                    'accounts.name: ${metadata.accounts.map((a) => a.name).toList()}'),
                Text('institution.name: ${metadata.institution.name}'),
              ],
            ),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    };
  }

  PlaidExitCallback onExit(BuildContext context) {
    return (PlaidError error, PlaidExitMetadata metadata) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                Text('Exited Plaid Link'),
                Text('error: $error'),
                Text('linkSessionId: ${metadata.linkSessionId}'),
              ],
            ),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    };
  }
}
