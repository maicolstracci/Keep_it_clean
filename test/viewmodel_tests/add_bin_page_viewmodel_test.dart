import 'package:flutter_test/flutter_test.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/add_bin_page_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AddBinPageViewModelTest -', () {
    test('Add type to list', () {
      var typeOfReportService = TypeOfReportServiceMock();
      locator.registerSingleton<TypeOfReportService>(typeOfReportService);
      var model = AddBinPageViewModel();



    });
  });
}
