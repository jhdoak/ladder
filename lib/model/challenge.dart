import '../ladder_api.dart';
import '../model/player_challenge_join.dart';

class Challenge extends ManagedObject<_Challenge> implements _Challenge {}

class _Challenge {
  @managedPrimaryKey
  int id;

  ManagedSet<PlayerChallengeJoin> playerChallenge;

  String challengeStatus;

  int winnerScore;

  int loserScore;
}