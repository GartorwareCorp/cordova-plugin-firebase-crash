package by.chemerisuk.cordova.firebase;

import android.util.Log;

import by.chemerisuk.cordova.support.CordovaMethod;
import by.chemerisuk.cordova.support.ReflectiveCordovaPlugin;

import com.google.firebase.crashlytics.FirebaseCrashlytics;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class FirebaseCrashPlugin extends ReflectiveCordovaPlugin {
    private final String TAG = "FirebaseCrashPlugin";

    private FirebaseCrashlytics firebaseCrashlytics;

    @Override
    protected void pluginInitialize() {
        Log.d(TAG, "Starting Firebase Crashlytics plugin");

        firebaseCrashlytics = FirebaseCrashlytics.getInstance();
    }

    @CordovaMethod(ExecutionThread.WORKER)
    private void log(String message, CallbackContext callbackContext) {
        firebaseCrashlytics.log(message);

        callbackContext.success();
    }

    @CordovaMethod(ExecutionThread.UI)
    private void logError(String message, JSONArray stackTrace, CallbackContext callbackContext) {
        try {
            Exception e = new JavaScriptException(message);
            if(stackTrace != null) {
                StackTraceElement[] trace = new StackTraceElement[stackTrace.length()];
                for (int i = 0; i < stackTrace.length(); i++) {
                    JSONObject elem = stackTrace.getJSONObject(i);
                    trace[i] = new StackTraceElement(
                            "",
                            elem.optString("functionName", "(anonymous function)"),
                            elem.optString("fileName", "(unknown file)"),
                            elem.optInt("lineNumber", -1)
                    );
                }
                e.setStackTrace(trace);
            }

            firebaseCrashlytics.recordException(e);
            
            callbackContext.success();
        } catch (Exception e) {
            firebaseCrashlytics.recordException(e);
            callbackContext.error(e.getMessage());
        }
    }

    @CordovaMethod(ExecutionThread.UI)
    private void setUserId(String userId, CallbackContext callbackContext) {
        firebaseCrashlytics.setUserId(userId);

        callbackContext.success();
    }

    @CordovaMethod
    private void setEnabled(boolean enabled, CallbackContext callbackContext) {
        firebaseCrashlytics.setCrashlyticsCollectionEnabled(enabled);

        callbackContext.success();
    }

}
