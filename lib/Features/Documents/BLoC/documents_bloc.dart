import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/document_model.dart';
import 'documents_event.dart';
import 'documents_state.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc() : super(DocumentsLoaded([
    DocumentModel(
      name: 'Residential contract',
      details: 'Signed • Valid until 31 Dec 2026',
    ),
    DocumentModel(
      name: 'Community handbook',
      details: 'Updated 14 May 2026',
    ),
  ])) {
    on<LoadDocuments>((event, emit) {
      // جلب البيانات أو التعامل معها هنا
    });
  }
}