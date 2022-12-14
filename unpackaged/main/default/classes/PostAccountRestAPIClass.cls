@RestResource(urlMapping='/Account/*')
global with sharing class PostAccountRestAPIClass
{
    @HttpPost
    global static Account doPost(String Name) 
    {
        Account acc = new Account();
        acc.Name= Name;
        insert acc;
        
        return acc;
    }

}