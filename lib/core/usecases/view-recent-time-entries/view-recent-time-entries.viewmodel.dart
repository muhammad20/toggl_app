class RecentTimeEntriesViewModel {
  List<TimeEntryItem> timeEntries;
  RecentTimeEntriesViewModel(this.timeEntries);
}

class TimeEntryItem {
  int id;
  String totalDuration;
  String projectName;
  String clientName;
  DateTime startDate;
  DateTime endDate;
  String title;

  TimeEntryItem(this.title, this.id, this.clientName, this.totalDuration, this.projectName, this.startDate, this.endDate);
}