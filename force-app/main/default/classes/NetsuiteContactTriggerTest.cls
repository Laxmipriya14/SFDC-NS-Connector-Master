@isTest
public class NetsuiteContactTriggerTest {

    @isTest
    public static void testTriggerLogic() {
        
        NS_Sandboxes__c inst = new NS_Sandboxes__c();
        inst.Name = 'demo sandbox';
        inst.End_Point_URL__c = 'https://td2345/restlet.api';
        insert inst;
        
        Connector_Configurations__c config = new Connector_Configurations__c();
        config.Enable_Sync__c = true;
        config.Netsuite_Instance__c = inst.id;
        insert config;
        
        SObject_Mapping__c sobj = new SObject_Mapping__c();
        sobj.IsActive__c = true;
        sobj.JSON_Sobject_Name__c = 'Contact';
        sobj.Name = 'Contact';
        insert sobj;
       
        Test.startTest();
        Contact newContact = new Contact(FirstName = 'New', LastName = 'Contact');
        insert newContact;
        Test.stopTest();

    }
}