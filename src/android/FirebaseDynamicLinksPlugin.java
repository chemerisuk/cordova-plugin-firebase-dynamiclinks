package by.chemerisuk.cordova.firebase;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import by.chemerisuk.cordova.support.CordovaMethod;
import by.chemerisuk.cordova.support.ReflectiveCordovaPlugin;

import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.dynamiclinks.DynamicLink;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;
import com.google.firebase.dynamiclinks.ShortDynamicLink;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONException;
import org.json.JSONObject;

import static com.google.firebase.dynamiclinks.ShortDynamicLink.Suffix.SHORT;
import static com.google.firebase.dynamiclinks.ShortDynamicLink.Suffix.UNGUESSABLE;


public class FirebaseDynamicLinksPlugin extends ReflectiveCordovaPlugin {
    private static final String TAG = "FirebaseDynamicLinks";

    private FirebaseDynamicLinks firebaseDynamicLinks;
    private CallbackContext dynamicLinkCallback;

    @Override
    protected void pluginInitialize() {
        Log.d(TAG, "Starting Firebase Dynamic Links plugin");

        this.firebaseDynamicLinks = FirebaseDynamicLinks.getInstance();
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        if (this.dynamicLinkCallback != null) {
            respondWithDynamicLink(intent);
        }
    }

    @CordovaMethod
    private void onDynamicLink(CallbackContext callbackContext) {
        this.dynamicLinkCallback = callbackContext;

        respondWithDynamicLink(cordova.getActivity().getIntent());
    }

    @CordovaMethod(ExecutionThread.WORKER)
    private void createLink(JSONObject params, int linkType, CallbackContext callbackContext) throws JSONException {
        DynamicLink.Builder builder = createDynamicLinkBuilder(params);
        if (linkType == 0) {
            callbackContext.success(builder.buildDynamicLink().getUri().toString());
        } else {
            builder.buildShortDynamicLink(linkType)
                    .addOnCompleteListener(this.cordova.getActivity(), new OnCompleteListener<ShortDynamicLink>() {
                        @Override
                        public void onComplete(@NonNull Task<ShortDynamicLink> task) {
                            if (task.isSuccessful()) {
                                callbackContext.success(task.getResult().getShortLink().toString());
                            } else {
                                callbackContext.error(task.getException().getMessage());
                            }
                        }
                    });
        }
    }

    private DynamicLink.Builder createDynamicLinkBuilder(JSONObject params) throws JSONException {
        DynamicLink.Builder builder = this.firebaseDynamicLinks.createDynamicLink();
        // TODO: read preferences value
        builder.setDomainUriPrefix(params.optString("domainUriPrefix"));
        builder.setLink(Uri.parse(params.getString("link")));

        JSONObject androidInfo = params.optJSONObject("androidInfo");
        if (androidInfo != null) {
            DynamicLink.AndroidParameters.Builder androidInfoBuilder = new DynamicLink.AndroidParameters.Builder();
            if (androidInfo.has("androidFallbackLink")) {
                androidInfoBuilder.setFallbackUrl(Uri.parse(androidInfo.getString("androidFallbackLink")));
            }
            if (androidInfo.has("androidMinPackageVersionCode")) {
                androidInfoBuilder.setMinimumVersion(androidInfo.getInt("androidMinPackageVersionCode"));
            }
            builder.setAndroidParameters(androidInfoBuilder.build());
        }

        JSONObject iosInfo = params.optJSONObject("iosInfo");
        if (iosInfo != null) {
            DynamicLink.IosParameters.Builder iosInfoBuilder = new DynamicLink.IosParameters.Builder(iosInfo.getString("iosBundleId"));
            if (iosInfo.has("iosAppStoreId")) {
                iosInfoBuilder.setAppStoreId(iosInfo.getString("iosAppStoreId"));
            }
            if (iosInfo.has("iosFallbackLink")) {
                iosInfoBuilder.setFallbackUrl(Uri.parse(iosInfo.getString("iosFallbackLink")));
            }
            if (iosInfo.has("iosIpadFallbackLink")) {
                iosInfoBuilder.setIpadFallbackUrl(Uri.parse(iosInfo.getString("iosIpadFallbackLink")));
            }
            if (iosInfo.has("iosMinPackageVersion")) {
                iosInfoBuilder.setMinimumVersion(iosInfo.getString("iosMinPackageVersion"));
            }
            builder.setIosParameters(iosInfoBuilder.build());
        }

        JSONObject navigationInfo = params.optJSONObject("navigationInfo");
        if (navigationInfo != null) {
            DynamicLink.NavigationInfoParameters.Builder navigationInfoBuilder = new DynamicLink.NavigationInfoParameters.Builder();
            if (navigationInfo.has("enableForcedRedirect")) {
                navigationInfoBuilder.setForcedRedirectEnabled(navigationInfo.getBoolean("enableForcedRedirect"));
            }
            builder.setNavigationInfoParameters(navigationInfoBuilder.build());
        }

        JSONObject analyticsInfo = params.optJSONObject("analyticsInfo");
        if (analyticsInfo != null) {
            // TODO
        }

        JSONObject socialMetaTagInfo = params.optJSONObject("socialMetaTagInfo");
        if (socialMetaTagInfo != null) {
            // TODO
        }

        return builder;
    }

    private void respondWithDynamicLink(Intent intent) {
        this.firebaseDynamicLinks.getDynamicLink(intent)
                .continueWith(new Continuation<PendingDynamicLinkData, JSONObject>() {
                    @Override
                    public JSONObject then(Task<PendingDynamicLinkData> task) throws JSONException {
                        PendingDynamicLinkData data = task.getResult();

                        JSONObject result = new JSONObject();
                        result.put("deepLink", data.getLink());
                        result.put("clickTimestamp", data.getClickTimestamp());
                        result.put("minimumAppVersion", data.getMinimumAppVersion());

                        if (dynamicLinkCallback != null) {
                            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, result);
                            pluginResult.setKeepCallback(true);
                            dynamicLinkCallback.sendPluginResult(pluginResult);
                        }

                        return result;
                    }
                });
    }
}
