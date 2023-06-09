part of 'project_bloc.dart';

abstract class ProjectEvent {
  const ProjectEvent();
}

class ProjectStatusChanged extends ProjectEvent {
  const ProjectStatusChanged(this.status);

  final ProjectStatus status;
}

class ProjectUpdateRequested extends ProjectEvent {
  const ProjectUpdateRequested(this.project);

  final Project project;
}
