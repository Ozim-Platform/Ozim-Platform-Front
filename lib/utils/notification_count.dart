class NotificationCount{
  NotificationCount._();

  static final NotificationCount _instance = NotificationCount._();

  static NotificationCount get instance => _instance;

  static int get count => _count;
  static int _count = 0;

  void increment() => ++_count;

  void reset() => _count = 0;

}