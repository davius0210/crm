import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class NotificationService {
  final String serverUrl =
      'https://fcm.googleapis.com/v1/projects/crmmobile-bd71a/messages:send';
  Future<String> _getAccessToken() async {
    const clientEmail =
        "firebase-adminsdk-fbsvc@crmmobile-bd71a.iam.gserviceaccount.com";
    const privateKey =
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDZJK55FXoVVtAc\n/yj95A6WMPz0qwogFng6cKOkDa2sUdYjNWPUw5ugrWthpv2GolyNwk6c1bKglLIt\naCqm9pxYc9C8c0O8ok+eE0FWa6I2sGPDn6EwpeZ4Poca9VduF1ASLP6RD/itOAKl\npcPiOanFmGAANmUIh3AzREIgBaJY4l1Ur0UnDHknBA3GYYal0zh7dG5EETzFY0pu\nVaeRwdo05h1httLs83JEVwlpQfzmTipbLjjZ1aIL+CSMvr9UvRmxnP/rj+PbaXn+\nB8xMQ6ECYYd/Z8pOvzVdhlmi9w6lkm1KFfyP6fLkwQeOvSjQ4i5dXN4KzuDQmCQU\nKZ0FdHabAgMBAAECggEABVH1p/s209M3lrl8gezDaLpuVpMV1Lk7aXi9O0J0iPf/\n7m2BjFx28ZLEj0HXc1ccbzXqb10TAWxmb/nESPWNphZZIzNFxRdK9305FbERNxRo\nrvA4M4HVEDwj9K0IxXM/xhPUVuFUmLxHE4aCTDm/QM6d1FOA2gElGbR1IRi4pHae\nLTQyS7t7GVILxDX5jdsoXKKZL0jqTyy7ort2MZ5SwTBkk/IwlyMJzJ1EnyxA1f0i\n6HuRUOEl0/ehCNj66UeCyWxq5nSdA7B6c00SauOUXM6PzyIeCZMsRf7m4D/D/HwT\n8/yrjQA8kGa91Q9dUgmEu6zxSCVsrb/X6VaVN5ntkQKBgQD79Bzns6fT/mFF7uMX\nmQPBCgjM737ls+zgLuz9wxO9BFoBdOl1frXltZHwU7F0nmNyNB8E6de9ROY99MtH\nKy0oDQJeuza4qjHSaj/KThY39ID1o4UPmYaOUYL0vDumRWOEcDWtoUUC9q+X1fw2\nArZisanQglnNsCrQozvNGS4q6wKBgQDcoXLs0sj4gnPkzTAgWXak5fSkleAAGYHU\nJeJahmQT/QsN212Qv17tqMtftMLtavr7Xbdvjrpjkk4Fs9VX4kLAmKFGMHlEZeUY\nJ89zRotGllC2MbxPljXKfmC211svUqtK3ApwsEbIQdlHcuxJAo3iBiYraZMHLGWZ\nh8bGP3mXEQKBgDLJ+8WtToiKf9tUE40fOEWCm1GMeb0eLwLmErn4yBLTPL2Mbr9T\noqFCn7+db2k9wHg2D4azCN1LdUpJ/WxERN8M+ExWWuqQzGhJKMDESvBOpmxd4SXK\n4ffwcICbLT8QP8ZjxD5TAxFc3vqxlRziIRf2DnBMxoOTHp5eOWDX0ZmvAoGAMZGE\nRHjG9i4443rGCT6QTVPstt2FSgBxDrzEMhpneaYsSZyzVMXqCfMWXhY6hSS35qmT\ngNjMP3qrVNSmZexLmwGvmhlh5WAPLHIlRXzf5af30jcyW58fzrK9/9Y6glNMcLEn\nF1JDVNKWglrrgyuzvMgs4ywBAGeVG/1JR1kTdEECgYEA8+EJiIcyBFNrfHaSCmTs\nWA7aScUQJlTMngFVimdsyrxvexVlGWZ4A4/PCCuQGETT20VdH07KERvTzOszmiSW\naLuT8NoRvyIKvsbLQd0tcf4eWTpsWkAYLAHUME/FoqM6Krqe2sLaK8LzN+zJOgTw\n1POkGFTuUQbHx1mRdCRPj7Y=\n-----END PRIVATE KEY-----\n";
    final iat = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final exp = iat + 3600;
    // Create a JWT
    final jwt = JWT(
      {
        'iss': clientEmail,
        'scope': 'https://www.googleapis.com/auth/cloud-platform',
        'aud': 'https://oauth2.googleapis.com/token',
        'iat': iat,
        'exp': exp,
      },
    );
    // Sign the JWT with the private key
    final token = jwt.sign(
      RSAPrivateKey(privateKey),
      algorithm: JWTAlgorithm.RS256,
    );
    // Request an access token
    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': token,
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['access_token'];
    } else {
      throw Exception('Failed to obtain access token: ${response.body}');
    }
  }

  Future<void> sendPushMessage({
    required String token,
    required String title,
    required String body,
    required String gotopage,
  }) async {
    final accessToken = await _getAccessToken();
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            'message': {
              'token': token,
              'notification': {
                'title': title,
                'body': body,
              },
              'data': {
                'url': gotopage // Used for navigation
              },
            },
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Push message sent successfully');
      } else {
        print('Failed to send push message: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error sending push message: $e');
    }
  }
}
