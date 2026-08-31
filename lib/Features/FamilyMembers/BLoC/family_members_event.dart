import '../../../Data/Models/family_member_model.dart';

abstract class FamilyEvent {}

class LoadFamilyMembers extends FamilyEvent {}

// --- BLoC States ---
abstract class FamilyState {}

class FamilyLoaded extends FamilyState {
  final List<FamilyMember> members;
  FamilyLoaded(this.members);
}