import 'package:get/get.dart';
import '../data/db_helper.dart';
import '../data/models/billboard.dart';

class BillboardController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  var billboards = <Billboard>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBillboards();
  }

  Future<void> fetchBillboards() async {
    try {
      isLoading(true);
      var fetchedBillboards = await _dbHelper.getAllBillboards();
      billboards.assignAll(fetchedBillboards);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addBillboard(Billboard billboard) async {
    await _dbHelper.insertBillboard(billboard);
    await fetchBillboards();
  }

  Future<void> deleteBillboard(int id) async {
    await _dbHelper.deleteBillboard(id);
    await fetchBillboards();
  }
}
