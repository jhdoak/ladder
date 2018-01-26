import '../ladder_api.dart';

class Challenge extends ManagedObject<_Challenge> implements _Challenge {}

class _Challenge {
  @managedPrimaryKey
  int id;

  String challengeStatus;

  int challengingPlayerId;

  int defendingPlayerId;

  int winningPlayerId;

  int losingPlayerId;

  int winnerScore;

  int loserScore;
}