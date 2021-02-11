class TimeEntry {
  String title;
  int id;
  String projectName;
  String clientName;
  DateTime startTime;
  DateTime endTime;
  String duration;

  TimeEntry(this.title, this.projectName, this.clientName, this.startTime,
      this.endTime, this.id, this.duration);
}
