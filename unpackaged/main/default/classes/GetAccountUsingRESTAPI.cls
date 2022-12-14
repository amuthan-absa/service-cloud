public class GetAccountUsingRESTAPI {
    private final String clientId = '3MVG9Y6d_Btp4xp76bqER5TVja2UXuSV1QQON1sKpWLeoPpBDQVxkvtphbqnaAD.UGpPANBx5uffZhJgdljoR';
    private final String clientSecret = '1BF2ADB9C2D79FE5CC348F47429B202413D397CBCC57ED36D1616640467EA41E';
    private final String username = 'test.user@ecommerce.com';
    private final String password = 'Welcome@11';
    public class deserializeResponse
    {
        public String id;
        public String access_token;
    }
    public String ReturnAccessToken (GetAccountUsingRESTAPI acount)
    {
        String reqbody = 'grant_type=password' + '&client_id='+clientId +
                        '&client_secret='+clientSecret + '&username='+username + '&password='+password;
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse res = h.send(req);
        deserializeResponse response = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        system.debug('@@@@access_token@@'+response );
        return response.access_token;
    }
    public static list<account> callGetAccount()
    {
        GetAccountUsingRESTAPI acount1 = new GetAccountUsingRESTAPI();
        String accessToken;
        accessToken = acount1.ReturnAccessToken (acount1);
        system.debug('accessToken'+accessToken);
        list<account> ListAccount=new List<account>();
        if(accessToken != null) {
            String endPoint = 'https://amuthan-dev-ed.lightning.force.com/services/apexrest/Account/';
           system.debug('endPoint'+endPoint);
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('POST');
            //req1.setClientCertificateName('Source');
            req1.setEndpoint(endPoint);
            req1.setBody('{"name":"oAuth Account"}');
            
            HttpResponse res1 = h2.send(req1);
            system.debug('res1'+res1); 
            
            If(res1.getStatusCode() == 301 || res1.getStatusCode() == 302)
         {    
         req1.setEndpoint(res1.getHeader('Location'));
         res1 = new Http().send(req1);
         system.debug('res1'+res1);
         }

       String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('@@@RESPONSE@@'+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            set<account> accList=new set<account>();
            
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ) {
                    Account acc;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                        parser.nextToken();
                        String sId= parser.getText();
                        acc=new Account();
                        acc.Id=sId;
                        system.debug('Id@@@' + sId);
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Name')) {
                            parser.nextToken();
                            string sName= parser.getText();
                            acc.Name=sName;
                            system.debug('Name@@@' + sName );
                        }
                    }
                    accList.add(acc); 
                }
                accList.remove(null);
            }
            ListAccount.AddAll(accList);
            system.debug('AccountList@@@@'+Json.serialize(ListAccount));
        }
        return ListAccount;
    }
}