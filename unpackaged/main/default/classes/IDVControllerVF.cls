public class IDVControllerVF{

    public String acctNumber{ get; set; }
    
    Account acctExist;
    Map<Id, IdVQuestionnaire__c> questionsMap = new Map<Id, IdVQuestionnaire__c>();
    
    public String validateAccountNumber(String aNumber) {
        String response = 'false';
        
        
        acctExist = [SELECT Id, AccountNumber, PersonBirthdate, BillingPostalCode, Name, Phone, PersonEmail 
                        FROM Account WHERE AccountNumber =: aNumber LIMIT 1];
        if( acctExist != null ) {
            response = 'true';
        }
                        
        return response;
    }
    
    
    public List<IdVQuestionnaire__c> getQuestions() {
    
        
        
        for(IdVQuestionnaire__c quest : [Select Id, Answer__c, Question__c, Required__c From IdVQuestionnaire__c WHERE Required__c=True AND Answer__c !='AccountNumber']) {
            questionsMap.put(quest.Id, quest);
        }
    
        List<String> orderBys = new List<String>{'Answer__c Asc','Answer__c Desc','Name Asc','Name Desc','Question__c Desc','Question__c Asc','CreatedDate Asc','CreatedDate Desc','Id Asc','Id Desc'};
        Integer count = [Select Count() From IdVQuestionnaire__c WHERE Required__c=False];
        Integer rand = Math.floor(Math.random() * count).intValue();
        String orderBy = orderBys.get(Math.mod(rand,orderBys.size()));
        List<IdVQuestionnaire__c> questions = (List<IdVQuestionnaire__c>)Database.query('Select Id, Answer__c, Question__c, Required__c From IdVQuestionnaire__c Order By ' + orderBy + ' Limit 2');
        
        for(IdVQuestionnaire__c quest : questions) {
            questionsMap.put(quest.Id, quest);
        }
        return questionsMap.values();
    }
    
    public Boolean validateResponses(Id questId, String userResponse) {
    
        Boolean isSuccess = False;
    
        IdVQuestionnaire__c questionInput = questionsMap.get(questId);
        String actualValue = (String)acctExist.get(questionInput.Answer__c);
        
        if(actualValue == userResponse) {
            isSuccess = True;
        }
        return isSuccess;
    }

}