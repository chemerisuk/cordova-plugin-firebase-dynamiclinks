package by.chemerisuk.cordova.firebase;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import android.content.Intent;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.util.Log;
import android.text.TextUtils;

import by.chemerisuk.cordova.support.CordovaMethod;
import by.chemerisuk.cordova.support.ReflectiveCordovaPlugin;

import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.dynamiclinks.DynamicLink;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class FirebaseDynamicLinksPlugin extends ReflectiveCordovaPlugin {
    private static final String TAG = "FirebaseDynamicLinks";

    private CallbackContext dynamicLinkCallback;

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

    private void respondWithDynamicLink(Intent intent) {
        FirebaseDynamicLinks.getInstance().getDynamicLink(intent)
            .addOnSuccessListener(cordova.getActivity(), new OnSuccessListener<PendingDynamicLinkData>() {
                @Override
                public void onSuccess(PendingDynamicLinkData pendingDynamicLinkData) {
                    if (pendingDynamicLinkData != null) {
                        Uri deepLink = pendingDynamicLinkData.getLink();

                        if (deepLink != null) {
                            JSONObject response = new JSONObject();
                            try {
                                response.put("deepLink", deepLink);
                                response.put("clickTimestamp", pendingDynamicLinkData.getClickTimestamp());

                                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, response);
                                pluginResult.setKeepCallback(true);
                                dynamicLinkCallback.sendPluginResult(pluginResult);
                            } catch (JSONException e) {
                                Log.e(TAG, "Fail to handle dynamic link data", e);
                            }
                        }
                    }
                }
            });
    }
}
