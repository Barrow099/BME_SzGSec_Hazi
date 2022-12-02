import 'package:oauth2/oauth2.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

final authorizationEndpoint = Uri.parse("https://10.0.2.2:44315/connect/authorize");
final tokenEndpoint = Uri.parse("https://10.0.2.2:44315/connect/token");
final revoke = Uri.parse("https://10.0.2.2:44315/connect/revocation");
final endSession = Uri.parse("https://10.0.2.2:44315/connect/endsession");
final redirectUrl =  Uri.parse("com.example.flutterapp://callback");

const identifier = 'flutter';

class WebshopOAuth2Client {
  Client? client;

  Future<String> getAccessToken() async {
    AuthorizationCodeGrant grant = AuthorizationCodeGrant(
        identifier,
        authorizationEndpoint,
        tokenEndpoint,
    );

    Uri authorizationUrl = grant.getAuthorizationUrl(
      redirectUrl,
      scopes: ['openid', 'profile', 'offline_access', 'apiScope'],
    );

    await redirect(authorizationUrl);
    Uri? responseUrl = await listen(redirectUrl);

    if (responseUrl == null) {
      throw Exception('Response URL was null');
    }

    client = await grant.handleAuthorizationResponse(responseUrl.queryParameters);
    return client!.credentials.accessToken;
  }

  Future<void> redirect(Uri authorizationUrl) async {
    // TODO find equivalent non depricated functions (launchUri does not work)
    // ignore: deprecated_member_use
    if (await canLaunch(authorizationUrl.toString())) {
      // ignore: deprecated_member_use
      await launch(authorizationUrl.toString());
    }
    else {
      throw Exception('Unable to launch authorization URL.');
    }
  }

  Future<Uri?> listen(Uri redirectUrl) async {
    return await uriLinkStream.firstWhere(
          (element) => element.toString().startsWith(
        redirectUrl.toString(),
      ),
    );
  }
}