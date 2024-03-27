@isTest
public class TriggerFactoryTest {
    
    @IsTest
    static void test1() {
        
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
        sobj.JSON_Sobject_Name__c = 'customer';
        sobj.Name = 'Account';
        insert sobj;
        
        Account acc = new Account();
        acc.Toggle_Sync_to_NS__c = true;
        acc.Name = 'Test Account';
        insert acc;
        
        
        
    }
}