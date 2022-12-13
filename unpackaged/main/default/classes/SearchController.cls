public class SearchController {
    private final String clientId = '3MVG9cHH2bfKACZYPL4rbfqZLSaC4_sPdOao0FLDsiqS5SEVKbkeK2IDwpNfpzHph2oyt0bxItQkbmcuk.W8j';
    private final String clientSecret = 'EFCA4CC631671D33B4E10094AA3481470AE917519B34715C2A18466BBAD37797';
    private final String username = 'thanaraj@datasirpi.com';
    private final String password = 'SURESH@87lMq675j4OTElRrRu7FT9asRl';
    public class deserializeResponse
    {
        public String id;
        public String access_token;
    }
    public String ReturnAccessToken (SearchController contact)
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
        system.debug('Access token ==> '+response );
        return response.access_token;
    }
    @AuraEnabled(cacheable=true)
    public static list<Contact> callGetContact(String strConName)
    {
        SearchController contact1 = new SearchController();
        String accessToken;
        accessToken = contact1.ReturnAccessToken (contact1);
        list<Contact> ListContact=new List<Contact>();
        if(accessToken != null) {
            String endPoint = 'https://thanaraj-dev-ed.my.salesforce.com/services/apexrest/v1/getContactss/'+strConName+'';
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('Accept','application/json');
            req1.setMethod('GET');
            req1.setEndpoint(endPoint);
            HttpResponse res1 = h2.send(req1);
        
            String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('Response ==> '+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            List<Contact> conList=new List<Contact>();
        
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                Contact con;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                    parser.nextToken();
                    String sId= parser.getText();
                    con=new Contact();
                    con.Id=sId;
                    system.debug('Id ==> ' + sId);
                    parser.nextToken();
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'LastName')) {
                    parser.nextToken();
                    string sName= parser.getText();
                    con.LastName=sName;
                    system.debug('Name ==> ' + sName );
                    }
                }
                conList.add(con);
            }
        }
        ListContact.AddAll(conList);
    }
    return ListContact;
    }
    @AuraEnabled
    public static string createContactwithCase(list<string> conLastName){
    List<Contact> lstCon = new List<Contact>();
    List<Contact> contactList = [SELECT Id,LastName,Email FROM Contact WHERE LastName LIKE:conLastName];
        if(contactList.size()>0){
        return contactList[0].Id;
        }
    else{
        Contact newContact1 = new Contact ();
        newContact1.LastName = conLastName[0];
        lstCon.Add(newContact1);
        insert lstCon;  
        }
    return lstCon[0].Id;
    }
}