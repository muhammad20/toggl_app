import 'dart:async';

import 'package:toggl_app/core/base/usecase.dart';
import 'package:toggl_app/core/interfaces/repositories/time-entries.repository.dart';
import 'package:toggl_app/core/usecases/view-recent-time-entries/view-recent-time-entries.request.dart';
import 'package:toggl_app/core/usecases/view-recent-time-entries/view-recent-time-entries.viewmodel.dart';

class ViewRecentTimeEntriesUseCase
    implements
        IUseCase<ViewRecentTimeEntriesRequest, RecentTimeEntriesViewModel> {
  ITimeEntriesRepository _repository;

  ViewRecentTimeEntriesUseCase(this._repository);

  @override
  Stream<RecentTimeEntriesViewModel> execute(input) {
    StreamController<RecentTimeEntriesViewModel> controller =
        StreamController<RecentTimeEntriesViewModel>();
    this._repository.getRecentMonthTimeEntries().last.then((viewmodel) {
      List<TimeEntryItem> elements = [];
      viewmodel.forEach((element) {
        elements.add(TimeEntryItem(
            element.title,
            element.id,
            element.clientName,
            element.duration,
            element.projectName,
            element.startTime,
            element.endTime));
      });
      // sort according to date.
      elements.sort((elemB, elemA) => elemA.endDate.compareTo(elemB.endDate));
      controller.add(RecentTimeEntriesViewModel(elements));
      controller.close();
    }).catchError((e) {
      print(e);
      controller.close();
    });
    return controller.stream;
  }
}
