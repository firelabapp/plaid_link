package app.firelab.plaidlink;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.NonNull;
import app.firelab.plaidlink.mappers.LinkEventMapper;
import app.firelab.plaidlink.mappers.LinkExitMapper;
import app.firelab.plaidlink.mappers.LinkSuccessMapper;
import com.plaid.link.Plaid;
import com.plaid.link.configuration.AccountSubtype;
import com.plaid.link.configuration.LinkConfiguration;
import com.plaid.link.configuration.LinkConfiguration.Builder;
import com.plaid.link.configuration.PlaidEnvironment;
import com.plaid.link.configuration.PlaidProduct;
import com.plaid.link.event.LinkEvent;
import com.plaid.link.result.LinkExit;
import com.plaid.link.result.LinkSuccess;
import com.plaid.link.result.PlaidLinkResultHandler;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

/**
 * PlaidLinkPlugin
 */
public class PlaidLinkPlugin extends AbstractActivityAware implements FlutterPlugin,
    MethodCallHandler, ActivityResultListener {

  private MethodChannel channel;
  private Activity activity;
  private PlaidLinkResultHandler linkResultHandler = new PlaidLinkResultHandler(
      new Function1<LinkSuccess, Unit>() {
        @Override
        public Unit invoke(LinkSuccess linkSuccess) {
          handleSuccess(linkSuccess);
          return Unit.INSTANCE;
        }
      },
      new Function1<LinkExit, Unit>() {
        @Override
        public Unit invoke(LinkExit linkExit) {
          handleExit(linkExit);
          return Unit.INSTANCE;
        }
      });

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),
        "plaid_link");
    channel.setMethodCallHandler(this);

    Plaid.setLinkEventListener(new Function1<LinkEvent, Unit>() {
      @Override
      public Unit invoke(LinkEvent linkEvent) {
        handleEvent(linkEvent);
        return Unit.INSTANCE;
      }
    });
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    Plaid.initialize(activity.getApplication());
    binding.addActivityResultListener(this);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    return linkResultHandler.onActivityResult(requestCode, resultCode, data);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("open")) {
      Map<String, Object> arguments = call.arguments();
      Plaid.openLink(activity, linkConfigurationFromArgs(arguments));
    } else {
      result.notImplemented();
    }
  }

  private void handleSuccess(LinkSuccess success) {
    channel.invokeMethod("onSuccess", LinkSuccessMapper.INSTANCE.apply(success));
  }

  private void handleEvent(LinkEvent event) {
    channel.invokeMethod("onEvent", LinkEventMapper.INSTANCE.apply(event));
  }

  private void handleExit(LinkExit exit) {
    channel.invokeMethod("onExit", LinkExitMapper.INSTANCE.apply(exit));
  }

  @SuppressWarnings("unchecked")
  private LinkConfiguration linkConfigurationFromArgs(Map<String, Object> arguments) {
    LinkConfiguration.Builder builder = new Builder();

    builder.clientName = (String) arguments.get("clientName");

    String envStr = (String) arguments.get("env");
    if (envStr != null) {
      builder.environment = PlaidEnvironment.valueOf(envStr.toUpperCase());
    }

    final List<String> productStrs = (List<String>) arguments.get("products");
    if (productStrs != null) {
      builder.products = new ArrayList<PlaidProduct>() {{
        for (String productStr : productStrs) {
          add(PlaidProduct.valueOf(productStr.toUpperCase()));
        }
      }};
    }

    builder.token = (String) arguments.get("publicToken");
    builder.publicKey = (String) arguments.get("publicKey");
    builder.webhook = (String) arguments.get("webhook");

    final List<String> accountSubtypeStrs = (List<String>) arguments.get("accountSubtypes");
    if (accountSubtypeStrs != null) {
      builder.accountSubtypeFilter = new ArrayList<AccountSubtype>() {{
        for (String accountSubtypeStr : accountSubtypeStrs) {
          add(PlaidAccountSubtype.valueOf(accountSubtypeStr.toUpperCase()).getInstance());
        }
      }};
    }

    builder.linkCustomizationName = (String) arguments.get("linkCustomizationName");

    String language = (String) arguments.get("language");
    if (language != null) {
      builder.language = language;
    }

    List<String> countryCodes = (List<String>) arguments.get("countryCodes");
    if (countryCodes != null) {
      builder.countryCodes = countryCodes;
    }

    return builder.build();
  }

}
