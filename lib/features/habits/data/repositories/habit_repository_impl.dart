import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this._local);

  final HabitLocalDataSource _local;

  @override
  List<Habit> getHabits() => _local.read();

  @override
  Future<void> saveHabits(List<Habit> habits) =>
      _local.write(habits.map(HabitModel.fromEntity).toList());
}
