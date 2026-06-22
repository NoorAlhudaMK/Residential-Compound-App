abstract class VisitorEvent {}
class ToggleTab extends VisitorEvent { final int index; ToggleTab(this.index); }
class GeneratePermit extends VisitorEvent { final String visitorName; GeneratePermit(this.visitorName); }