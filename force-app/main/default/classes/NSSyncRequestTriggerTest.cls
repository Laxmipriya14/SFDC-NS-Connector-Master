@isTest
public class NSSyncRequestTriggerTest {

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
        sobj.JSON_Sobject_Name__c = 'NS_Sync_Request__c';
        sobj.Name = 'NS_Sync_Request__c';
        insert sobj;
       
        Test.startTest();
        NS_Sync_Request__c newSyncRequest = new NS_Sync_Request__c();
        insert newSyncRequest;
        Test.stopTest();

    }
}