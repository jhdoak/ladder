import 'harness/app.dart';
import 'package:ladder_api/model/challenge.dart';

Future main() async {
  TestApplication app = new TestApplication();

  final capitalFirstLetterRegExp = new RegExp("^[A-Z]+[a-zA-Z]*\$");

  setUpAll(() async {
    await app.start();

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

    await Future.forEach(challenges, (q) {
      var query = new Query<Challenge>()
        ..values = q;
      return query.insert();
    });

  });

  tearDownAll(() async {
    await app.stop();
  });

  test("/challenges returns a list of all challenges", () async {
    var request = app.client.request("/challenges");
    expectResponse(
        await request.get(),
        200,
        body: allOf([
          hasLength(2),
          everyElement(containsPair("challengeStatus",
              matches(capitalFirstLetterRegExp)))
        ]));
  });
  
  test("/challenges?status=active returns all active challenges", () async {
    var request = app.client.request("/challenges?status=active");
    expectResponse (
        await request.get(),
        200,
        body:
          everyElement(containsPair("challengeStatus", "Active"))
    );
  });

  test("/challenges/id returns a single challenge", () async {
    expectResponse(
        await app.client.request("/challenges/2").get(),
        200,
        body: allOf([
          containsPair("challengeStatus", "Complete")
        ]));
  });

  test("/challenges/id out of range returns 404", () async {
    expectResponse(
        await app.client.request("/challenges/500").get(),
        404);
  });


}
