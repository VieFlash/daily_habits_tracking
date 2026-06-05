import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._local);

  final ProfileLocalDataSource _local;

  @override
  String getName() => _local.getName();

  @override
  String getHandle() => _local.getHandle();

  @override
  DateTime getInstalledAt() => _local.getInstalledAt();

  @override
  Future<void> saveName(String name) => _local.setName(name);
}
