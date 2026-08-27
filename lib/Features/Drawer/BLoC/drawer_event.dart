abstract class DrawerEvent {}

class ChangeDrawerPageEvent extends DrawerEvent {
  final String alias;
  ChangeDrawerPageEvent(this.alias);
}