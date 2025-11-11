########################################
# Flutter + ML Kit ProGuard Rules
########################################

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

########################################
# ML Kit Text Recognition (All Languages)
########################################
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.common.** { *; }
-keep class com.google.android.gms.vision.text.** { *; }

# Prevent warnings from ML Kit + Play Services
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

########################################
# Kotlin & Reflection (if used)
########################################
-dontwarn kotlin.**
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.** { *; }

########################################
# Firebase (in case you use Firebase)
########################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

########################################
# Prevent stripping annotations
########################################
-keepattributes *Annotation*

########################################
# Prevent stripping generic types
########################################
-keepattributes Signature
