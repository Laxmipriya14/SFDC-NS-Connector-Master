/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class NSSyncRequestTestClass {
    @isTest static void syncAccounttoNS(){
        NS_Sandboxes__c inst = new NS_Sandboxes__c();
        inst.Name = 'demo sandbox';
        inst.End_Point_URL__c = 'https://td2345/restlet.api';
        insert inst;
        
        NS_Scripts__c script = new NS_Scripts__c(
            Object_Name__c = 'Account',
            NS_Sandboxes__c = inst.id,
            Script_URL__c = '?script=1595&deploy=1'
        );
        insert script;

        Connector_Configurations__c config = new Connector_Configurations__c();
        config.Enable_Sync__c = true;
        config.Netsuite_Instance__c = inst.id;
        insert config;
        
        SObject_Mapping__c sobj = new SObject_Mapping__c();
        sobj.IsActive__c = true;
        sobj.JSON_Sobject_Name__c = 'Customer';
        sobj.Name = 'Account';
        insert sobj;
        
        List<Field_Mapping__c> fieldMList = new List<Field_Mapping__c>();
        Field_Mapping__c fieldM = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'URL',
            NetSuite_Field_API_Name__c = 'url', 
            SFDC_Field_API_Name__c = 'Website' 
        );
        fieldMList.add(fieldM);
        Field_Mapping__c fieldM1 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'custentity_external_id', 
            SFDC_Field_API_Name__c = 'Id' 
        );
        fieldMList.add(fieldM1);
        Field_Mapping__c fieldM2 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'companyname', 
            SFDC_Field_API_Name__c = 'Name' 
        );
        fieldMList.add(fieldM2);
        Field_Mapping__c fieldM3 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'phone', 
            SFDC_Field_API_Name__c = 'phone' 
        );
        fieldMList.add(fieldM3);
        Field_Mapping__c fieldM4 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'Country', 
            SFDC_Field_API_Name__c = 'BillingCountry' 
        );
        fieldMList.add(fieldM4);
        insert fieldMList;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockWebserviceClass_Test());
            Account testAccount = new Account(Name = 'Test Account');
            testAccount.Toggle_Sync_to_NS__c = true;
            insert testAccount;
        Test.stopTest();
        
    }
    
    @isTest static void syncOpportunitytoNS(){
      
        NS_Sandboxes__c inst = new NS_Sandboxes__c();
        inst.Name = 'demo sandbox';
        inst.End_Point_URL__c = 'https://td2345/restlet.api';
        insert inst;
        
        NS_Scripts__c script = new NS_Scripts__c(
            Object_Name__c = 'Opportunity',
            NS_Sandboxes__c = inst.id,
            Script_URL__c = '?script=1595&deploy=1'
        );
        insert script;

        Connector_Configurations__c config = new Connector_Configurations__c();
        config.Enable_Sync__c = true;
        config.Netsuite_Instance__c = inst.id;
        insert config;
        
        SObject_Mapping__c sobj = new SObject_Mapping__c();
        sobj.IsActive__c = true;
        sobj.JSON_Sobject_Name__c = 'Sales Order';
        sobj.Name = 'Opportunity';
        insert sobj;

        SObject_Mapping__c sobj1 = new SObject_Mapping__c();
        sobj1.IsActive__c = true;
        sobj1.JSON_Sobject_Name__c = 'OpportunityLineItem';
        sobj1.Name = 'OpportunityLineItem';
        sobj1.Parent_SObject_Map__c = sobj.id;
        sobj1.Relationship_Type__c = 'Child';
        sobj1.Relationship_with_parent__c   = 'OpportunityId';
        insert sobj1;

        List<Field_Mapping__c> fieldMList = new List<Field_Mapping__c>();
        Field_Mapping__c fieldM = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'URL',
            NetSuite_Field_API_Name__c = 'amount', 
            SFDC_Field_API_Name__c = 'Amount',
            IsActive__c = true
        );
        fieldMList.add(fieldM);

        Field_Mapping__c fieldM2 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'URL',
            NetSuite_Field_API_Name__c = 'custbody_salesforce_ext_id', 
            SFDC_Field_API_Name__c = 'Id' ,
            IsActive__c = true
        );
        fieldMList.add(fieldM2);

        Field_Mapping__c fieldM3 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'URL',
            NetSuite_Field_API_Name__c = 'opportunity', 
            SFDC_Field_API_Name__c = 'Name',
            IsActive__c = true 
        );
        fieldMList.add(fieldM3);

        Field_Mapping__c fieldM4 = new Field_Mapping__c(
            SObject_Mapping__c=sobj.id,
            Field_Type__c = 'URL',
            NetSuite_Field_API_Name__c = 'entity', 
            SFDC_Field_API_Name__c = 'AccountId' ,
            IsActive__c = true
        );
        fieldMList.add(fieldM4);

        Field_Mapping__c fieldM5 = new Field_Mapping__c(
            SObject_Mapping__c=sobj1.id,
            Field_Type__c = 'Number',
            NetSuite_Field_API_Name__c = 'rate', 
            SFDC_Field_API_Name__c = 'UnitPrice',
            IsActive__c = true
        );
        fieldMList.add(fieldM5);

        Field_Mapping__c fieldM6 = new Field_Mapping__c(
            SObject_Mapping__c=sobj1.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'custitem_salesforce_prd_id', 
            SFDC_Field_API_Name__c = 'Product2Id',
            IsActive__c = true
        );
        fieldMList.add(fieldM6);
        Field_Mapping__c fieldM7 = new Field_Mapping__c(
            SObject_Mapping__c=sobj1.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'displayname', 
            SFDC_Field_API_Name__c = 'Name' ,
            IsActive__c = true
        );
        fieldMList.add(fieldM7);
        Field_Mapping__c fieldM8 = new Field_Mapping__c(
            SObject_Mapping__c=sobj1.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'custcol_leid', 
            SFDC_Field_API_Name__c = 'Id' ,
            IsActive__c = true
        );
        fieldMList.add(fieldM8);
        Field_Mapping__c fieldM9 = new Field_Mapping__c(
            SObject_Mapping__c=sobj1.id,
            Field_Type__c = 'Text',
            NetSuite_Field_API_Name__c = 'quantity', 
            SFDC_Field_API_Name__c = 'Quantity' ,
            IsActive__c = true
        );
        fieldMList.add(fieldM9);
        insert fieldMList;
        
       

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity testOpp = new Opportunity(Name = 'Test Oppo');
        testOpp.StageName = 'Closed Won';
        testOpp.AccountId = acc.Id;
        testOpp.CloseDate = System.today();
        testOpp.Toggle_Sync_to_NS__c = false;
        insert testOpp;

        Product2 prod2 = new Product2(
            Name = 'testName',
            IsActive=true);
        insert prod2;
        
        PricebookEntry price = new PricebookEntry(
            UseStandardPrice = false,
            Pricebook2Id = test.getStandardPricebookId(),
            UnitPrice = 1.0,
            IsActive = true,
            Product2Id = prod2.Id);
        insert price;
        
        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = testOpp.Id,quantity=2,unitprice=20,PricebookEntryId =price.id );
        insert oli;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceClass_Test());
            Opportunity opp = [Select id,Toggle_Sync_to_NS__c,AccountId,StageName,CloseDate From Opportunity where Name = 'Test Oppo'];
            opp.Toggle_Sync_to_NS__c = true;
            opp.StageName = 'Closed Lost';
            update opp;
        Test.stopTest();

    }
    @isTest
    static void syncContacttoNS(){
        Test.startTest();
        Contact newContact = new Contact(FirstName = 'New', LastName = 'Contact');
        insert newContact;
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

    @isTest
    static void syncRequestBatchSchedulerTest(){
        Test.startTest();
        NSSyncRequestBatchScheduler scheduler = new NSSyncRequestBatchScheduler('Account');
        scheduler.execute(null);
        Test.stopTest();
    }


    @isTest
    static void SyncRequestErrorTest(){
        Test.startTest();
        TriggerServiceHandler handler = new TriggerServiceHandler();
        NS_Sync_Request__c req = new NS_Sync_Request__c(
            Source_Record_Id__c = '012365478912365',
            Source_Object_Type__c = 'Account',
            Sync_Status__c = 'Queueddd'
        );
        handler.creatNSSyncRequests(new List<NS_Sync_Request__c>{req});
        Test.stopTest();
    }

    @isTest
    static void syncRequestHandler(){
        NSSyncRequestTriggerServiceImpl req= new NSSyncRequestTriggerServiceImpl();
        req.beforeInsert();
        req.beforeUpdate();
        req.beforeDelete();
        req.afterUpdate();
        req.afterDelete();
        req.afterUndelete();
    }
}