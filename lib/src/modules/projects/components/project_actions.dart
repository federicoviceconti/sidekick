import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/projects/project.dto.dart';

import '../../../components/atoms/typography.dart';
import '../projects.provider.dart';

/// Possible actions for installed release
enum ProjectActionOptions {
  /// Opens directory
  openDirectory,

  /// Remove project
  remove,
}

/// Display actions for a project
class ProjectActions extends StatelessWidget {
  /// Constructor
  const ProjectActions(
    this.project, {
    Key? key,
  }) : super(key: key);

  /// Project
  final Project project;

  /// Render menu button
  Widget renderMenuButton({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 10),
        Caption(label),
      ],
    );
  }

  /// Renders menu options
  List<PopupMenuEntry<ProjectActionOptions>> renderMenuOptions(
      BuildContext context) {
    final menus = <PopupMenuEntry<ProjectActionOptions>>[
      PopupMenuItem(
        value: ProjectActionOptions.openDirectory,
        child: renderMenuButton(
          label: context.i18n('modules:projects.components.open'),
          icon: MdiIcons.openInNew,
        ),
      ),
      PopupMenuItem(
        value: ProjectActionOptions.remove,
        child: renderMenuButton(
          label: context.i18n('modules:projects.components.remove'),
          icon: MdiIcons.delete,
        ),
      ),
    ];

    return menus;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProjectActionOptions>(
      onSelected: (result) {
        if (result == ProjectActionOptions.remove) {
          context.read(projectsProvider.notifier)
              .removeProject(project as FlutterProject);
        }

        if (result == ProjectActionOptions.openDirectory) {
          OpenFile.open(
            project.projectDir.absolute.path,
          );
        }
      },
      itemBuilder: (context) {
        return renderMenuOptions(context);
      },
      child: const Icon(MdiIcons.dotsVertical),
    );
  }
}
