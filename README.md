# plaid_link

Plaid Link for Flutter (web and android).

![web_demo](https://github.com/firelab-app/plaid_link/blob/master/doc/web_demo.gif?raw=true)
![android_demo](https://github.com/firelab-app/plaid_link/blob/master/doc/android_demo.gif?raw=true)

## Example

```dart
PlaidLink.open(
  const PlaidLinkOptions(
    publicKey: 'YOUR_PLAID_PUBLIC_KEY',
    env: PlaidEnv.sandbox,
    clientName: 'Plaid Link Example',
    products: [PlaidProduct.transactions],
    language: 'en',
  ),
  onSuccess: (publicToken, _) {
    print('Success: $publicToken');
  },
);
```

## Android Setup

This package uses the [Plaid Android SDK](https://plaid.com/docs/link/android/).

You must add your Android package (i.e. `app.firelab.plaid_link_example`) in your [Plaid settings](https://dashboard.plaid.com/team/api).

## Web Setup

This package uses the [Plaid Link JS library](http://plaid.com/docs/#integrating-with-link).

Remember to include the library in your HTML page (usually index.html). See the [example](https://github.com/firelab-app/plaid_link/blob/master/example/web/index.html#L22).

```html
<script src="https://cdn.plaid.com/link/v2/stable/link-initialize.js"></script>
```

## iOS Setup

This package does not presently support iOS. Pull requests are welcomed! :)
