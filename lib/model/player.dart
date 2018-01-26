import '../ladder_api.dart';

class Player extends ManagedObject<_Player> implements _Player {}

class _Player {
  @managedPrimaryKey
  int id;

  String name;

  String slackHandle;

  int ladderPosition;

  int wins;

  int losses;
}