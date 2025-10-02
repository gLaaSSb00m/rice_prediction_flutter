# TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.nnapi.** { *; }
-keep class org.tensorflow.lite.flex.** { *; }

# TensorFlow Lite GPU Delegate
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }

# TensorFlow Lite NNAPI Delegate
-keep class org.tensorflow.lite.nnapi.NnApiDelegate$Options { *; }
-keep class org.tensorflow.lite.nnapi.NnApiDelegate { *; }

# TensorFlow Lite Flex Delegate
-keep class org.tensorflow.lite.flex.FlexDelegate { *; }

# Keep all TensorFlow Lite native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes that extend TensorFlow Lite delegates
-keep class * extends org.tensorflow.lite.gpu.GpuDelegate
-keep class * extends org.tensorflow.lite.nnapi.NnApiDelegate
-keep class * extends org.tensorflow.lite.flex.FlexDelegate

# Keep TensorFlow Lite interpreter
-keep class org.tensorflow.lite.Interpreter { *; }
-keep class org.tensorflow.lite.Interpreter$Options { *; }

# Keep TensorFlow Lite support library
-keep class org.tensorflow.lite.support.** { *; }

# Suppress warnings for missing TensorFlow Lite GPU delegate classes
# These classes may not exist in all versions or may be renamed during build
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Play Core - Split Compatibility
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Google Play Core - Split Install
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallException { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManager { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManagerFactory { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest$Builder { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener { *; }
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }

# Keep all Play Core classes and interfaces
-keep class * implements com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class * implements com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class * implements com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener { *; }

# Image processing
-keep class com.bumptech.glide.** { *; }

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes that are referenced by reflection
-keep class **.R$* { *; }

# Keep all View classes
-keepclassmembers class * extends android.view.View {
    public <init>(android.content.Context);
}

# Keep all Activity classes
-keepclassmembers class * extends android.app.Activity {
    public void *(android.view.View);
}

# Keep all Fragment classes
-keepclassmembers class * extends androidx.fragment.app.Fragment {
    public void *(android.view.View);
}

# Keep all Service classes
-keepclassmembers class * extends android.app.Service {
    public <init>();
}

# Keep all BroadcastReceiver classes
-keepclassmembers class * extends android.content.BroadcastReceiver {
    public <init>();
}

# Keep all ContentProvider classes
-keepclassmembers class * extends android.content.ContentProvider {
    public <init>();
}

# Keep all Application classes
-keepclassmembers class * extends android.app.Application {
    public <init>();
}

# Keep all annotation classes
-keep @interface * { *; }

# Keep all enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep all Parcelable classes
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep all Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
