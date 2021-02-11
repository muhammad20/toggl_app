import 'package:rxdart/subjects.dart';
import 'package:toggl_app/core/base/bloc.dart';
import 'package:toggl_app/core/usecases/view-recent-time-entries/view-recent-time-entries.request.dart';
import 'package:toggl_app/core/usecases/view-recent-time-entries/view-recent-time-entries.usecase.dart';
import 'package:toggl_app/core/usecases/view-recent-time-entries/view-recent-time-entries.viewmodel.dart';
import 'package:toggl_app/data/web/repositories/time-entries.repository.dart';

class RecentTimeEntriesBloc implements IBLoC {
  BehaviorSubject<RecentTimeEntriesViewModel> _recentTimeEntriesBehaviorSubject;
  Stream<RecentTimeEntriesViewModel> get recentTimeEntriesStream =>
      _recentTimeEntriesBehaviorSubject.stream;

  RecentTimeEntriesBloc() {
    _recentTimeEntriesBehaviorSubject =
        BehaviorSubject<RecentTimeEntriesViewModel>();

    getRecentMonthTimeEntries();
  }

  Future<void> getRecentMonthTimeEntries() async {
    var usecase = ViewRecentTimeEntriesUseCase(TimeEntriesWebRepository());
    try {
      var response = await usecase.execute(ViewRecentTimeEntriesRequest()).last;
      _recentTimeEntriesBehaviorSubject.add(response);
    } catch (e) {
      _recentTimeEntriesBehaviorSubject.addError('failed to load');
      print(e);
    }
  }

  @override
  void dispose() {
    _recentTimeEntriesBehaviorSubject.close();
  }
}
