/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class NSSyncRequestBatchSchedulerTest {
    
    @isTest
    static void testExecute() {
        
        String objName = 'TestObject';
        
        Test.startTest();
        NSSyncRequestBatchScheduler scheduler = new NSSyncRequestBatchScheduler(objName);
        scheduler.execute(null);
        Test.stopTest();
    }

    @isTest
    static void serializeAddressTest(){

        Account acct = new Account(name = 'TestAccount', BillingStreet='xyz',BillingCity = 'Pune', BillingState = 'Maharashtra', BillingCountry = 'India' , Billingpostalcode = '1234');
        NSSyncService.serializeAddress(acct,'Billing');

        Account acct2 = new Account(name = 'TestAccount', ShippingStreet='xyz',ShippingCity = 'Pune', ShippingState = 'Maharashtra', ShippingCountry = 'India' , Shippingpostalcode = '1234');
        NSSyncService.serializeAddress(acct2,'Shipping');
    
        Contact cont = new Contact(FirstName = 'Test', LastName = 'Contact', MailingStreet = 'xyz',MailingCity = 'Pune',MailingState = 'Maharashtra',MailingCountry = 'India',Mailingpostalcode = '1234');
        NSSyncService.serializeAddress(cont,'Mailing');

        Contact cont1 = new Contact(FirstName = 'Test', LastName = 'Contact', OtherStreet = 'xyz',OtherCity = 'Pune',OtherState = 'Maharashtra',OtherCountry = 'India',Otherpostalcode = '1234');
        NSSyncService.serializeAddress(cont1,'other');
    
    }
}

