import 'harness/app.dart';
import 'package:ladder_api/model/player.dart';

Future main() async {
  TestApplication app = new TestApplication();

  final nameRegExp = new RegExp("^[A-Z]+[a-zA-Z]*\$");

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
          hasLength(greaterThan(0)),
          everyElement(containsPair("name", matches(nameRegExp))),
          everyElement(containsPair("ladderPosition", greaterThan(0)))
        ]));
  });

  test("/players/id returns a single player", () async {
    expectResponse(
        await app.client.request("/players/2").get(),
        200,
        body: allOf([
          containsPair("name", matches(nameRegExp)),
          containsPair("ladderPosition", greaterThan(0))
        ]));
  });

  test("/players/id out of range returns 404", () async {
    expectResponse(
        await app.client.request("/players/500").get(),
        404);
  });


}
