package by.chemerisuk.cordova.firebase;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.dynamiclinks.DynamicLink;
import com.google.firebase.dynamiclinks.DynamicLink.AndroidParameters;
import com.google.firebase.dynamiclinks.DynamicLink.GoogleAnalyticsParameters;
import com.google.firebase.dynamiclinks.DynamicLink.IosParameters;
import com.google.firebase.dynamiclinks.DynamicLink.ItunesConnectAnalyticsParameters;
import com.google.firebase.dynamiclinks.DynamicLink.NavigationInfoParameters;
import com.google.firebase.dynamiclinks.DynamicLink.SocialMetaTagParameters;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;
import com.google.firebase.dynamiclinks.ShortDynamicLink;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONException;
import org.json.JSONObject;

import by.chemerisuk.cordova.support.CordovaMethod;
import by.chemerisuk.cordova.support.ReflectiveCordovaPlugin;


public class FirebaseDynamicLinksPlugin extends ReflectiveCordovaPlugin {
    private static final String TAG = "FirebaseDynamicLinks";

    private FirebaseDynamicLinks firebaseDynamicLinks;
    private String domainUriPrefix;
    private CallbackContext dynamicLinkCallback;

    @Override
    protected void pluginInitialize() {
        Log.d(TAG, "Starting Firebase Dynamic Links plugin");

        this.firebaseDynamicLinks = FirebaseDynamicLinks.getInstance();
        this.domainUriPrefix = this.preferences.getString("DYNAMIC_LINK_URIPREFIX", "");
    }

    @Override
    public void onNewIntent(Intent intent) {
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
    private void createDynamicLink(JSONObject params, int linkType, final CallbackContext callbackContext) throws JSONException {
        DynamicLink.Builder builder = createDynamicLinkBuilder(params);
        if (linkType == 0) {
            callbackContext.success(builder.buildDynamicLink().getUri().toString());
        } else {
            builder.buildShortDynamicLink(linkType)
                .addOnCompleteListener(this.cordova.getActivity(), new OnCompleteListener<ShortDynamicLink>() {
                    @Override
                    public void onComplete(Task<ShortDynamicLink> task) {
                        if (task.isSuccessful()) {
                            callbackContext.success(task.getResult().getShortLink().toString());
                        } else {
                            callbackContext.error(task.getException().getMessage());
                        }
                    }
                });
        }
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

    private DynamicLink.Builder createDynamicLinkBuilder(JSONObject params) throws JSONException {
        DynamicLink.Builder builder = this.firebaseDynamicLinks.createDynamicLink();
        builder.setDomainUriPrefix(params.optString("domainUriPrefix", this.domainUriPrefix));
        builder.setLink(Uri.parse(params.getString("link")));

        JSONObject androidInfo = params.optJSONObject("androidInfo");
        if (androidInfo != null) {
            builder.setAndroidParameters(getAndroidParameters(androidInfo));
        }

        JSONObject iosInfo = params.optJSONObject("iosInfo");
        if (iosInfo != null) {
            builder.setIosParameters(getIosParameters(iosInfo));
        }

        JSONObject navigationInfo = params.optJSONObject("navigationInfo");
        if (navigationInfo != null) {
            builder.setNavigationInfoParameters(getNavigationInfoParameters(navigationInfo));
        }

        JSONObject analyticsInfo = params.optJSONObject("analyticsInfo");
        if (analyticsInfo != null) {
            JSONObject googlePlayAnalyticsInfo = analyticsInfo.optJSONObject("googlePlayAnalytics");
            if (googlePlayAnalyticsInfo != null) {
                builder.setGoogleAnalyticsParameters(getGoogleAnalyticsParameters(googlePlayAnalyticsInfo));
            }
            JSONObject itunesConnectAnalyticsInfo = analyticsInfo.optJSONObject("itunesConnectAnalytics");
            if (itunesConnectAnalyticsInfo != null) {
                builder.setItunesConnectAnalyticsParameters(getItunesConnectAnalyticsParameters(itunesConnectAnalyticsInfo));
            }
        }

        JSONObject socialMetaTagInfo = params.optJSONObject("socialMetaTagInfo");
        if (socialMetaTagInfo != null) {
            builder.setSocialMetaTagParameters(getSocialMetaTagParameters(socialMetaTagInfo));
        }

        return builder;
    }

    private AndroidParameters getAndroidParameters(JSONObject androidInfo) throws JSONException {
        AndroidParameters.Builder androidInfoBuilder;
        if (androidInfo.has("androidPackageName")) {
            androidInfoBuilder = new AndroidParameters.Builder(androidInfo.getString("androidPackageName"));
        } else {
            androidInfoBuilder = new AndroidParameters.Builder();
        }
        if (androidInfo.has("androidFallbackLink")) {
            androidInfoBuilder.setFallbackUrl(Uri.parse(androidInfo.getString("androidFallbackLink")));
        }
        if (androidInfo.has("androidMinPackageVersionCode")) {
            androidInfoBuilder.setMinimumVersion(androidInfo.getInt("androidMinPackageVersionCode"));
        }
        return androidInfoBuilder.build();
    }

    private IosParameters getIosParameters(JSONObject iosInfo) throws JSONException {
        IosParameters.Builder iosInfoBuilder = new IosParameters.Builder(iosInfo.getString("iosBundleId"));
        iosInfoBuilder.setAppStoreId(iosInfo.optString("iosAppStoreId"));
        iosInfoBuilder.setIpadBundleId(iosInfo.optString("iosIpadBundleId"));
        iosInfoBuilder.setMinimumVersion(iosInfo.optString("iosMinPackageVersion"));
        if (iosInfo.has("iosFallbackLink")) {
            iosInfoBuilder.setFallbackUrl(Uri.parse(iosInfo.getString("iosFallbackLink")));
        }
        if (iosInfo.has("iosIpadFallbackLink")) {
            iosInfoBuilder.setIpadFallbackUrl(Uri.parse(iosInfo.getString("iosIpadFallbackLink")));
        }
        return iosInfoBuilder.build();
    }

    private NavigationInfoParameters getNavigationInfoParameters(JSONObject navigationInfo) throws JSONException {
        NavigationInfoParameters.Builder navigationInfoBuilder = new NavigationInfoParameters.Builder();
        if (navigationInfo.has("enableForcedRedirect")) {
            navigationInfoBuilder.setForcedRedirectEnabled(navigationInfo.getBoolean("enableForcedRedirect"));
        }
        return navigationInfoBuilder.build();
    }

    private GoogleAnalyticsParameters getGoogleAnalyticsParameters(JSONObject googlePlayAnalyticsInfo) {
        GoogleAnalyticsParameters.Builder gaInfoBuilder = new GoogleAnalyticsParameters.Builder();
        gaInfoBuilder.setSource(googlePlayAnalyticsInfo.optString("utmSource"));
        gaInfoBuilder.setMedium(googlePlayAnalyticsInfo.optString("utmMedium"));
        gaInfoBuilder.setCampaign(googlePlayAnalyticsInfo.optString("utmCampaign"));
        gaInfoBuilder.setContent(googlePlayAnalyticsInfo.optString("utmContent"));
        gaInfoBuilder.setTerm(googlePlayAnalyticsInfo.optString("utmTerm"));
        return gaInfoBuilder.build();
    }

    private ItunesConnectAnalyticsParameters getItunesConnectAnalyticsParameters(JSONObject itunesConnectAnalyticsInfo) {
        ItunesConnectAnalyticsParameters.Builder iosAnalyticsInfo = new ItunesConnectAnalyticsParameters.Builder();
        iosAnalyticsInfo.setAffiliateToken(itunesConnectAnalyticsInfo.optString("at"));
        iosAnalyticsInfo.setCampaignToken(itunesConnectAnalyticsInfo.optString("ct"));
        iosAnalyticsInfo.setProviderToken(itunesConnectAnalyticsInfo.optString("pt"));
        return iosAnalyticsInfo.build();
    }

    private SocialMetaTagParameters getSocialMetaTagParameters(JSONObject socialMetaTagInfo) throws JSONException {
        SocialMetaTagParameters.Builder socialInfoBuilder = new SocialMetaTagParameters.Builder();
        socialInfoBuilder.setTitle(socialMetaTagInfo.optString("socialTitle"));
        socialInfoBuilder.setDescription(socialMetaTagInfo.optString("socialDescription"));
        if (socialMetaTagInfo.has("socialImageLink")) {
            socialInfoBuilder.setImageUrl(Uri.parse(socialMetaTagInfo.getString("socialImageLink")));
        }
        return socialInfoBuilder.build();
    }
}
