import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Models/family_member_model.dart';
import 'family_members_event.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc() : super(FamilyLoaded([
    FamilyMember(name: 'Sara Hassan', role: 'Resident • Primary family member'),
    FamilyMember(name: 'Yara Hassan', role: 'Resident • Child access'),
  ])) {
    on<LoadFamilyMembers>((event, emit) {
    });
  }
}