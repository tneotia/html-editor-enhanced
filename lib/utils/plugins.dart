import 'package:flutter/foundation.dart';

/// Abstract class that all the plguin classes extend
abstract class Plugins {
  const Plugins();

  /// Provides the JS and CSS tags to be inserted inside <head>. Only used for Web
  String getHeadString();

  /// Provides the toolbar option for the plugin
  String getToolbarString();
}
