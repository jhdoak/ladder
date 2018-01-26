import '../ladder_api.dart';
import '../model/challenge.dart';

class ChallengeController extends HTTPController {

  @httpGet
  Future<Response> getAllChallenges() async {
    var query = new Query<Challenge>();
    var allChallenges = await query.fetch();

    return new Response.ok(allChallenges);
  }

  @httpGet
  Future<Response> getChallengeById(@HTTPPath("id") int id) async {
    var query = new Query<Challenge>()
      ..where.id = whereEqualTo(id);

    var challenge = await query.fetchOne();

    return (challenge == null)
        ? new Response.notFound()
        : new Response.ok(challenge);
  }

}