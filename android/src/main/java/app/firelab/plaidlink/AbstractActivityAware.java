package app.firelab.plaidlink;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public abstract class AbstractActivityAware implements ActivityAware {
    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
