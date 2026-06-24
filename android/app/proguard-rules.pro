# Flutter engine and plugin native code
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep all plugin classes
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**

# Keep SQLite native library references
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Keep protobuf (used internally)
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**
