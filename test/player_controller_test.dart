import 'harness/app.dart';
import 'package:ladder_api/model/challenge.dart';
import 'package:ladder_api/model/player.dart';
import 'package:ladder_api/model/player_challenge_join.dart';

Future main() async {
  TestApplication app = new TestApplication();

  final capitalFirstLetterRegExp = new RegExp("^[A-Z]+[a-zA-Z]*\$");

  setUpAll(() async {
    await app.start();

    var players = [
      new Player()
        ..name = "Brandon"
        ..slackHandle = "brando"
        ..ladderPosition = 1
        ..wins = 4
        ..losses = 3,
      new Player()
        ..name = "Fran"
        ..slackHandle = "fran"
        ..ladderPosition = 2
        ..wins = 2
        ..losses = 4
    ];

    var challenges = [
      new Challenge()
        ..challengeStatus = "Active"
        ..winnerScore = 0
        ..loserScore = 0,
      new Challenge()
        ..challengeStatus = "Complete"
        ..winnerScore = 10
        ..loserScore = 3,
    ];

    var playerChallengeJoins = [
      new PlayerChallengeJoin()
        ..player = players[0]
        ..challenge = challenges[0]
        ..isChallenger = false
        ..isDefender = true
        ..isWinner = null
        ..isLoser = null,
      new PlayerChallengeJoin()
        ..player = players[1]
        ..challenge = challenges[0]
        ..isChallenger = true
        ..isDefender = false
        ..isWinner = null
        ..isLoser = null
    ];

    await Future.forEach(players, (q) {
      var query = new Query<Player>()
          ..values = q;
      return query.insert();
    });

  });

  tearDownAll(() async {
    await app.stop();
  });

  test("/players returns a list of all players", () async {
    var request = app.client.request("/players");
    expectResponse(
        await request.get(),
        200,
        body: allOf([
          hasLength(2),
          everyElement(containsPair("name", matches(capitalFirstLetterRegExp))),
          everyElement(containsPair("ladderPosition", greaterThan(0)))
        ]));
  });

  test("/players/id returns a single player", () async {
    expectResponse(
        await app.client.request("/players/2").get(),
        200,
        body: allOf([
          containsPair("name", "Fran"),
          containsPair("ladderPosition", 2)
        ]));
  });

  test("/players/id out of range returns 404", () async {
    expectResponse(
        await app.client.request("/players/500").get(),
        404);
  });

  test("/players/id/challenges returns player info with challenges", () async {
    var request = app.client.request("/players/2/challenges");

    expectResponse(
        await request.get(),
        200,
        body: partial({
          "name": "Fran",
          "challenges": allOf([
            containsPair("challengeStatus", isString),
            containsPair("winnerScore", isNonNegative),
            containsPair("loserScore", isNonNegative)
          ])
        }));
  });


}
