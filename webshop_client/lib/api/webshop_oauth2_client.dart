import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';


const authorizationEndpoint = 'https://10.0.2.2:44315/connect/authorize';
const tokenEndpoint = 'https://10.0.2.2:44315/connect/token';
const redirectUrl = 'my.test.app:/oauth2-redirect.html';

const identifier = 'a8917271-3a4e-48dc-ba79-9dedcfebcacf';
const secret = 'a22939d0-2e41-40e6-8d33-f201c5e78016';

class WebshopOAuth2Client extends OAuth2Client {

  late OAuth2Helper helper;

  WebshopOAuth2Client(): super(
      authorizeUrl: authorizationEndpoint,
      tokenUrl: tokenEndpoint,
      redirectUri: redirectUrl,
      customUriScheme: 'my.test.app'
  ) {
    helper = OAuth2Helper(this,
        grantType: OAuth2Helper.authorizationCode,
        clientId: identifier,
        clientSecret: secret,
        scopes: ["openid", "profile", "caffApi"]
    );
  }
}