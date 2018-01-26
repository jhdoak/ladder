import '../ladder_api.dart';
import '../model/player_challenge_join.dart';

class Player extends ManagedObject<_Player> implements _Player {}

class _Player {
  @managedPrimaryKey
  int id;

  ManagedSet<PlayerChallengeJoin> playerChallenge;

  String name;

  String slackHandle;

  int ladderPosition;

  int wins;

  int losses;
}