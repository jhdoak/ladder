import 'harness/app.dart';

Future main() async {
  TestApplication app = new TestApplication();

  final nameRegExp = new RegExp("^[A-Z]+[a-zA-Z]*\$");

  setUpAll(() async {
    await app.start();
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
          everyElement(matches(nameRegExp))
        ]));
  });

  test("/players/index returns a single player", () async {
    expectResponse(
        await app.client.request("/players/2").get(),
        200,
        body: matches(nameRegExp));
  });

  test("/players/index out of range returns 404", () async {
    expectResponse(
        await app.client.request("/players/500").get(),
        404);
  });


}
