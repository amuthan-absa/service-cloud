public class IDV_auraController {
    
    @AuraEnabled
    public static Account fetchAccount(String accNmber) {
        return [SELECT Id, Name, AccountNumber, Website, Phone, PersonBirthdate, BillingPostalCode, PersonEmail, PersonMobilePhone, AnnualRevenue 
                FROM Account WHERE AccountNumber =: accNmber LIMIT 1];
    }
    
    @AuraEnabled
    public static List<IdVQuestionnaire__c> fetchQuestion() {
        
        List<IdVQuestionnaire__c> questions = new List<IdVQuestionnaire__c>([Select Id, Answer__c, Question__c, Required__c From IdVQuestionnaire__c WHERE Required__c = True AND Answer__c ='AccountNumber' LIMIT 1]);
        
        List<IdVQuestionnaire__c> requiredQuestions = new List<IdVQuestionnaire__c>([Select Id, Answer__c, Question__c, Required__c From IdVQuestionnaire__c WHERE Required__c = True AND Answer__c !='AccountNumber']);
        questions.addAll(requiredQuestions);
        
        /*RandomQuestion rdQuesDetail = new RandomQuestion(randomNumSet, randomQuestions, requiredQuestions, randomDisplayCount);
        for(IdVQuestionnaire__c requiredQuestion :requiredQuestions){
            getRandomQuestion(rdQuesDetail);
        }*/
        
        List<IdVQuestionnaire__c> randomQuestions = new List<IdVQuestionnaire__c>();
        Set<Integer> randomNumSet = new Set<Integer>();
        Integer randomDisplayCount = 2;
        
        if(randomQuestions.size() < randomDisplayCount){
            List<IdVQuestionnaire__c> ordinaryQuestions = new List<IdVQuestionnaire__c>([Select Id, Answer__c, Question__c, Required__c From IdVQuestionnaire__c WHERE Required__c = false]);
            RandomQuestion rdQuesDetail = new RandomQuestion(randomNumSet, randomQuestions, ordinaryQuestions, randomDisplayCount);
            for(IdVQuestionnaire__c ordinaryQuestion :ordinaryQuestions){
                getRandomQuestion(rdQuesDetail);
            }
        }
        
        questions.addAll(randomQuestions);
        return questions;
    }
    
    
    public static void getRandomQuestion(RandomQuestion rdQues){
        List<IdVQuestionnaire__c> randomQuestions = rdQues.randomQuestions;
        List<IdVQuestionnaire__c> questions = rdQues.questions;
        Set<Integer> randomNumSet = rdQues.randomNumSet;
        Integer randomDisplayCount = rdQues.randomDisplayCount;
        Integer totalQuesCount = questions.size() - 1;
        
        if(randomQuestions.size() < randomDisplayCount){
            Integer i = 0;
            while(i == 0){
                Integer randomNum = Integer.valueOf(Math.rint((Math.random() * totalQuesCount)));
                if(randomNumSet.contains(randomNum) == false) {
                    i++;
                    randomNumSet.add(randomNum);
                    randomQuestions.add(questions[randomNum]);
                }
            }
        }
    }
    
    public class RandomQuestion{
        public Set<Integer> randomNumSet;
        public List<IdVQuestionnaire__c> randomQuestions;
        public List<IdVQuestionnaire__c> questions;
        public Integer randomDisplayCount;
        public RandomQuestion(Set<Integer> randomNumSet, List<IdVQuestionnaire__c> randomQuestions, 
                              List<IdVQuestionnaire__c> questions, Integer randomDisplayCount){
                                  this.randomNumSet = randomNumSet;
                                  this.randomQuestions = randomQuestions;
                                  this.questions = questions;
                                  this.randomDisplayCount = randomDisplayCount;
                                  
       }
    }
    
    
}