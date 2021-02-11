abstract class IProjectRepository {
  // get all time entries for user story 2
  Stream<String> getProjectName(String projectId);
}