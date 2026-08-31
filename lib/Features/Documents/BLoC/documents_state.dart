import '../../../Data/Models/document_model.dart';

abstract class DocumentsState {}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<DocumentModel> documents;
  DocumentsLoaded(this.documents);
}