public class EinsteinVision_Sentiment {
    @auraenabled
     public static String findSentiment(String text)
    {
     ContentVersion con = [SELECT Title,VersionData
    FROM ContentVersion
    WHERE Title = 'einstein_platform'
    OR Title = 'predictive_services'
    ORDER BY Title LIMIT 1];

    String key = con.VersionData.tostring();
    key = key.replace( '-----BEGIN RSA PRIVATE KEY-----', '' );
    key = key.replace( '-----END RSA PRIVATE KEY-----', '' );
    key = key.replace( '\n', '' );
    JWT jwt = new JWT( 'RS256' );
    jwt.pkcs8 = key;
    jwt.iss = 'developer.force.com';
    jwt.sub = 'sman@salesforce.com'; // Update with your own email ID
    jwt.aud = 'https://api.einstein.ai/v2/oauth2/token';
    jwt.exp = String.valueOf(3600);
    String access_token = JWTBearerFlow.getAccessToken( 'https://api.einstein.ai/v2/oauth2/token', jwt );
    String keyaccess = access_token;

    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setMethod( 'POST' );
    req.setEndpoint( 'https://api.einstein.ai/v2/language/sentiment');
    req.setHeader( 'Authorization', 'Bearer ' + keyaccess );
    req.setHeader( 'Content-type', 'application/json' );
    String body = '{\"modelId\":\"CommunitySentiment\",\"document\":\"' + text + '\"}';
    req.setBody( body );
    HTTPResponse res = http.send( req );
    string fullString=res.getBody();
    string removeString=fullString.removeEnd('],"object":"predictresponse"}');
    string stringBody=removeString.removeStart('{"probabilities":[');
    return stringBody;
    }
}
