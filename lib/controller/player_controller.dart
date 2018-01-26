import '../ladder_api.dart';
import '../model/player.dart';

class PlayerController extends HTTPController {

  @httpGet
  Future<Response> getAllPlayers() async {
    var query = new Query<Player>();
    var allPlayers = await query.fetch();

    return new Response.ok(allPlayers);
  }

  @httpGet
  Future<Response> getPlayerByIndex(@HTTPPath("id") int id) async {
    var query = new Query<Player>()
      ..where.id = whereEqualTo(id);

    var question = await query.fetchOne();

    return (question == null)
        ? new Response.notFound()
        : new Response.ok(question);
  }

}