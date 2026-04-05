abstract class TaskStrategy {
  int getTaskCount();
}

class NewEmployeeStrategy extends TaskStrategy {
  @override
  int getTaskCount() {
    return 5;
  }
}

class OldEmployeeStrategy extends TaskStrategy {
  @override
  int getTaskCount() {
    return 10;
  }
}
