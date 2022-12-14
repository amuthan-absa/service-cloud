public class IDVController{
    list<IdVQuestionnaire__c> qns = new list<IdVQuestionnaire__c>();

  
    @InvocableMethod(label='Get Random Questions')
    public static void getRandomQuestions() {
      
        //List<IdVQuestionnaire__c> questions = [SELECT Id, Answer__c FROM IdVQuestionnaire__c]; 
      
        List<String> orderBys = new List<String>{'Answer__c Asc','Answer__c Desc','Name Asc','Name Desc','Question__c Desc','Question__c Asc','CreatedDate Asc','CreatedDate Desc','Id Asc','Id Desc'};
        Integer count = [Select Count() From IdVQuestionnaire__c WHERE Required__c=False];
        Integer rand = Math.floor(Math.random() * count).intValue();
        //System.debug('rand:::'+rand);
        String orderBy = orderBys.get(Math.mod(rand,orderBys.size()));
        List<IdVQuestionnaire__c> questions = (List<IdVQuestionnaire__c>)Database.query('Select Id, Answer__c From IdVQuestionnaire__c Order By ' + orderBy + ' Limit 2');
        //System.debug('questions:::'+questions);
        List<Results> randQuestionResults = new List<Results>();
        for(IdVQuestionnaire__c quest : questions) {
            Results tempResult = new Results();
            tempResult.randQuestion = quest;
            randQuestionResults.add(tempResult);
        }
        //return randQuestionResults;
  }
   /*
   @InvocableMethod
   public static List<String> getAccountIds(List<String> names) {
      List<Id> accountIds = new List<Id>();
      List<Account> accounts = [SELECT Id FROM Account WHERE Name in :names];
      for (Account account : accounts) {
         accountIds.add(account.Id);
      }
      return accountIds;
   }
   */
   
    public class Results {
        @InvocableVariable(label='Records of random questions' description='yourDescription' required=true)
        public IdVQuestionnaire__c randQuestion;
    }

}