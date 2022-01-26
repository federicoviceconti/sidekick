import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';

import 'release.dto.dart';

/// Releae channel dto
class ChannelDto extends ReleaseDto {
  /// Latest releae of a channel
  Release? currentRelease;

  /// SDK Version
  final String? sdkVersion;

  /// Constructor
  ChannelDto({
    required String name,
    Release? release,
    required CacheVersion? cache,
    required needSetup,
    required this.sdkVersion,
    this.currentRelease,
    required isGlobal,
  }) : super(
          name: name,
          release: release,
          needSetup: needSetup,
          isChannel: true,
          cache: cache,
          isGlobal: isGlobal,
        );
}
