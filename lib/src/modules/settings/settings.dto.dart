import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fvm/fvm.dart';
import 'package:hive/hive.dart';
import 'package:i18next/i18next.dart';
import 'package:sidekick/i18n/language_manager.dart';

import 'settings.utils.dart';

/// All Settings
class AllSettings {
  SidekickSettings sidekick;
  FvmSettings fvm;
  FlutterSettings flutter;

  AllSettings({
    SidekickSettings? sidekick,
    FvmSettings? fvm,
    FlutterSettings? flutter,
  })
      : sidekick = sidekick ?? SidekickSettings(),
        fvm = fvm ?? FvmSettings(),
        flutter = flutter ?? FlutterSettings();

  AllSettings copy() => AllSettings(
        sidekick: SidekickSettings.fromJson(sidekick.toJson()),
        fvm: FvmSettings.fromJson(fvm.toJson()),
        flutter: FlutterSettings.fromMap(flutter.toMap()),
      );
}

/// Sidekick settings
class SidekickSettings {
  /// Constructor
  SidekickSettings({
    this.onlyProjectsWithFvm = false,
    this.projectPaths = const [],
    this.themeMode = SettingsThemeMode.system,
    this.locale,
    this.ide,
  }) : localizationsDelegate = I18NextLocalizationDelegate(
          locales: languageManager.supportedLocales.toList(),
          dataSource: AssetBundleLocalizationDataSource(
            bundlePath: 'localizations',
          ),
          options: I18NextOptions(formatter: languageManager.formatter),
        );

  /// Storage key
  static const key = 'settings_key';

  bool onlyProjectsWithFvm;
  List<String> projectPaths;
  String themeMode;
  I18NextLocalizationDelegate localizationsDelegate;
  Locale? locale;
  String? ide;

  factory SidekickSettings.fromJson(String str) =>
      SidekickSettings.fromMap(json.decode(str));

  factory SidekickSettings.fromMap(Map<String, dynamic> json) {
    final language = json['i18Locale'];
    final locale = language != null
        ? Locale.fromSubtags(
            languageCode: (language as String).split('-')[0],
            countryCode: language.split('-')[1])
        : null;

    return SidekickSettings(
      projectPaths: (json['projectPaths'] as List<dynamic>).cast<String>(),
      onlyProjectsWithFvm: json['onlyProjectsWithFvm'] as bool,
      themeMode: json['themeMode'] as String,
      locale: locale,
      ide: json['ide'],
    );
  }

  /// Converts Master Secret to Json
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'projectPaths': projectPaths,
      'onlyProjectsWithFvm': onlyProjectsWithFvm,
      'themeMode': themeMode,
      'i18Locale': locale?.toLanguageTag() ??
          languageManager.supportedLocales.first.toLanguageTag(),
      'ide': ide,
    };
  }
}

class SidekickSettingsAdapter extends TypeAdapter<SidekickSettings> {
  @override
  int get typeId => 1; // this is unique, no other Adapter can have the same id.

  @override
  SidekickSettings read(BinaryReader reader) {
    // FIXME: Check why subtype does not match
    final value = Map<String, dynamic>.from(reader.readMap());
    return SidekickSettings.fromMap(value);
  }

  @override
  void write(BinaryWriter writer, SidekickSettings obj) {
    writer.writeMap(obj.toMap());
  }
}

/// Flutter settings
class FlutterSettings {
  /// Constructor
  FlutterSettings({
    this.analytics = true,
    this.linux = false,
    this.macos = false,
    this.windows = false,
    this.web = false,
  });

  /// Analytics enabled
  bool analytics;

  /// MacOS enabled
  bool macos;

  /// Linux enabled
  bool linux;

  /// Windows enabled
  bool windows;

  /// Web enabled
  bool web;

  /// Flutter settings from map
  factory FlutterSettings.fromMap(Map<String, bool> map) {
    return FlutterSettings(
      analytics: map['analytics'] ?? false,
      macos: map['macos']  ?? false,
      windows: map['windows']  ?? false,
      linux: map['linux'] ?? false,
      web: map['web'] ?? false,
    );
  }

  /// Flutter settings to map
  Map<String, bool> toMap() {
    return {
      'analytics': analytics,
      'macos': macos,
      'linux': linux,
      'windows': windows,
      'web': web,
    };
  }
}
