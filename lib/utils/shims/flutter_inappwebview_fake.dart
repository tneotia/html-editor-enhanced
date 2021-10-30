///Class that is used by [WebView.shouldOverrideUrlLoading] event.
///It represents the policy to pass back to the decision handler.
class NavigationActionPolicy {
  final int _value;

  const NavigationActionPolicy._internal(this._value);

  int toValue() => _value;

  ///Cancel the navigation.
  static const CANCEL = NavigationActionPolicy._internal(0);

  ///Allow the navigation to continue.
  static const ALLOW = NavigationActionPolicy._internal(1);

  @override
  bool operator ==(value) => value == _value;

  @override
  int get hashCode => _value.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'action': _value,
    };
  }
}

///Class that represents the WebView context menu. It used by [WebView.contextMenu].
///
///**NOTE**: To make it work properly on Android, JavaScript should be enabled!
class ContextMenu {
  ///Event fired when the context menu for this WebView is being built.
  ///
  ///[hitTestResult] represents the hit result for hitting an HTML elements.
  final void Function(dynamic hitTestResult)? onCreateContextMenu;

  ///Event fired when the context menu for this WebView is being hidden.
  final void Function()? onHideContextMenu;

  ///Event fired when a context menu item has been clicked.
  ///
  ///[contextMenuItemClicked] represents the [ContextMenuItem] clicked.
  final void Function(ContextMenuItem contextMenuItemClicked)?
      onContextMenuActionItemClicked;

  ///Context menu options.
  final ContextMenuOptions? options;

  ///List of the custom [ContextMenuItem].
  final List<ContextMenuItem> menuItems;

  ContextMenu(
      {this.menuItems = const [],
      this.onCreateContextMenu,
      this.onHideContextMenu,
      this.options,
      this.onContextMenuActionItemClicked});

  Map<String, dynamic> toMap() {
    return {
      'menuItems': menuItems.map((menuItem) => menuItem.toMap()).toList(),
      'options': options?.toMap()
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

///Class that represent an item of the [ContextMenu].
class ContextMenuItem {
  ///Android menu item ID.
  int? androidId;

  ///iOS menu item ID.
  String? iosId;

  ///Menu item title.
  String title;

  ///Menu item action that will be called when an user clicks on it.
  Function()? action;

  ContextMenuItem(
      {this.androidId, this.iosId, required this.title, this.action});

  Map<String, dynamic> toMap() {
    return {'androidId': androidId, 'iosId': iosId, 'title': title};
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

///Class that represents available options used by [ContextMenu].
class ContextMenuOptions {
  ///Whether all the default system context menu items should be hidden or not. The default value is `false`.
  bool hideDefaultSystemContextMenuItems;

  ContextMenuOptions({this.hideDefaultSystemContextMenuItems = false});

  Map<String, dynamic> toMap() {
    return {
      'hideDefaultSystemContextMenuItems': hideDefaultSystemContextMenuItems
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

///Class that represents contains the constants for the times at which to inject script content into a [WebView] used by an [UserScript].
class UserScriptInjectionTime {
  final int _value;

  const UserScriptInjectionTime._internal(this._value);

  static final Set<UserScriptInjectionTime> values = {
    UserScriptInjectionTime.AT_DOCUMENT_START,
    UserScriptInjectionTime.AT_DOCUMENT_END,
  };

  static UserScriptInjectionTime? fromValue(int? value) {
    if (value != null) {
      try {
        return UserScriptInjectionTime.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  @override
  String toString() {
    switch (_value) {
      case 1:
        return 'AT_DOCUMENT_END';
      case 0:
      default:
        return 'AT_DOCUMENT_START';
    }
  }

  ///**NOTE for iOS**: A constant to inject the script after the creation of the webpage’s document element, but before loading any other content.
  ///
  ///**NOTE for Android**: A constant to try to inject the script as soon as the page starts loading.
  static const AT_DOCUMENT_START = UserScriptInjectionTime._internal(0);

  ///**NOTE for iOS**: A constant to inject the script after the document finishes loading, but before loading any other subresources.
  ///
  ///**NOTE for Android**: A constant to inject the script as soon as the page finishes loading.
  static const AT_DOCUMENT_END = UserScriptInjectionTime._internal(1);

  @override
  bool operator ==(value) => value == _value;

  @override
  int get hashCode => _value.hashCode;
}

///Class that represents a script that the [WebView] injects into the web page.
class UserScript {
  ///The script’s group name.
  String? groupName;

  ///The script’s source code.
  String source;

  ///The time at which to inject the script into the [WebView].
  UserScriptInjectionTime injectionTime;

  ///A Boolean value that indicates whether to inject the script into the main frame.
  ///Specify true to inject the script only into the main frame, or false to inject it into all frames.
  ///The default value is `true`.
  ///
  ///**NOTE**: available only on iOS.
  bool iosForMainFrameOnly;

  ///A scope of execution in which to evaluate the script to prevent conflicts between different scripts.
  ///For more information about content worlds, see [ContentWorld].
  late ContentWorld contentWorld;

  UserScript(
      {this.groupName,
      required this.source,
      required this.injectionTime,
      this.iosForMainFrameOnly = true,
      ContentWorld? contentWorld}) {
    this.contentWorld = contentWorld ?? ContentWorld.PAGE;
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'source': source,
      'injectionTime': injectionTime.toValue(),
      'iosForMainFrameOnly': iosForMainFrameOnly,
      'contentWorld': contentWorld.toMap()
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

final _contentWorldNameRegExp = RegExp(r'[\s]');

///Class that represents an object that defines a scope of execution for JavaScript code and which you use to prevent conflicts between different scripts.
///
///**NOTE for iOS**: available on iOS 14.0+. This class represents the native [WKContentWorld](https://developer.apple.com/documentation/webkit/wkcontentworld) class.
///
///**NOTE for Android**: it will create and append an `<iframe>` HTML element with `id` attribute equals to `flutter_inappwebview_[name]`
///to the webpage's content that contains only the inline `<script>` HTML elements in order to define a new scope of execution for JavaScript code.
///Unfortunately, there isn't any other way to do it.
///There are some limitations:
///- for any [ContentWorld], except [ContentWorld.PAGE] (that is the webpage itself), if you need to access to the `window` or `document` global Object,
///you need to use `window.top` and `window.top.document` because the code runs inside an `<iframe>`;
///- also, the execution of the inline `<script>` could be blocked by the `Content-Security-Policy` header.
class ContentWorld {
  ///The name of a custom content world.
  ///It cannot contain space characters.
  final String name;

  ///Returns the custom content world with the specified name.
  ContentWorld.world({required this.name}) {
    // WINDOW-ID- is used internally by the plugin!
    assert(!name.startsWith('WINDOW-ID-') &&
        !name.contains(_contentWorldNameRegExp));
  }

  ///The default world for clients.
  // ignore: non_constant_identifier_names
  static final ContentWorld DEFAULT_CLIENT =
      ContentWorld.world(name: 'defaultClient');

  ///The content world for the current webpage’s content.
  ///This property contains the content world for scripts that the current webpage executes.
  ///Be careful when manipulating variables in this content world.
  ///If you modify a variable with the same name as one the webpage uses, you may unintentionally disrupt the normal operation of that page.
  // ignore: non_constant_identifier_names
  static final ContentWorld PAGE = ContentWorld.world(name: 'page');

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
