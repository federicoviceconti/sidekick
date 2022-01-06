import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18next/i18next.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/projects/project.dto.dart';
import 'package:sidekick/src/modules/settings/settings.provider.dart';
import 'package:sidekick/src/modules/settings/settings.utils.dart';

import '../../../components/atoms/typography.dart';
import '../../../components/molecules/version_install_button.dart';
import '../../releases/releases.provider.dart';
import '../../sandbox/sandbox.screen.dart';
import 'project_actions.dart';
import 'project_release_select.dart';

/// Project list item
class ProjectListItem extends HookWidget {
  /// Constructor
  const ProjectListItem(
    this.project, {
    this.versionSelect = false,
    key,
  }) : super(key: key);

  /// Flutter project
  final Project project;

  /// Show version selector
  final bool versionSelect;

  @override
  Widget build(BuildContext context) {
    final cachedVersions = useProvider(releasesStateProvider).all;

    final version = useProvider(getVersionProvider(project.pinnedVersion));

    final needInstall = version != null && project.pinnedVersion != null;

    final ideName = useProvider(settingsProvider).sidekick.ide;
    final ide = ideName != null
        ? supportedIDEs.firstWhere((element) => element.name == ideName)
        : null;

    void openProjectPlayground() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SandboxScreen(
            project: project,
          ),
        ),
      );
    }

    void openIde() {
      ide?.launch(context, project.projectDir.absolute.path);
    }

    return Container(
      height: 170,
      child: Center(
        child: Card(
          child: Column(
            children: [
              Container(
                child: ListTile(
                  leading: const Icon(MdiIcons.alphaPBox),
                  title: Subheading(project.name ?? ''),
                  trailing: ProjectActions(project as FlutterProject),
                ),
              ),
              const Divider(height: 0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Paragraph(
                            (project as FlutterProject).description,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(thickness: 1, height: 0),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Tooltip(
                    message: I18Next.of(context)!.t(
                        'modules:projects.components.openTerminalPlayground'),
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      icon: const Icon(MdiIcons.consoleLine),
                      onPressed: openProjectPlayground,
                    ),
                  ),
                  if (ideName != null)
                    Tooltip(
                      message: I18Next.of(context)
                          !.t('modules:projects.components.openIde', variables: {
                        'ideName': ide?.name,
                      }),
                      child: IconButton(
                        iconSize: 20,
                        splashRadius: 20,
                        icon: ide?.icon ?? Container(),
                        onPressed: openIde,
                      ),
                    ),
                  const Spacer(),
                  versionSelect
                      ? Row(
                          children: [
                            needInstall
                                ? VersionInstallButton(version,
                                    warningIcon: true)
                                : const SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            ProjectReleaseSelect(
                              project: project as FlutterProject,
                              releases: cachedVersions,
                            )
                          ],
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
