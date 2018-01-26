import '../ladder_api.dart';

class PlayerController extends HTTPController {
  var players = ["Josiah", "Beatrice", "Ann", "Artemis"];

  @httpGet
  Future<Response> getAllPlayers() async {
    return new Response.ok(players);
  }

  @httpGet
  Future<Response> getPlayerByIndex(@HTTPPath("index") int index) async {
    return (index < 0 || index >= players.length)
        ? new Response.notFound()
        : new Response.ok(players[index]);
  }

}