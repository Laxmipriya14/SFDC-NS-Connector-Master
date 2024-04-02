/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 03-21-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class NSSyncQuickActionHandlerTest {
    
    @isTest
    static void testCreateNSSyncRequest() {
        // Test data setup
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
        
        NSSyncQuickActionHandler.inputParams input = new NSSyncQuickActionHandler.inputParams();
        input.recordId = acc.Id;
        input.userSyncConfirmation = false;
        List<NSSyncQuickActionHandler.inputParams> inputList = new List<NSSyncQuickActionHandler.inputParams>();
        inputList.add(input);
        
        // Test method execution
        Test.startTest();
        List<NSSyncQuickActionHandler.outputParams> resultList = NSSyncQuickActionHandler.createNSSyncRequest(inputList);
        Test.stopTest();
        
        // Assert results
        System.assertEquals(1, resultList.size(), 'Result list should contain one item');
        NSSyncQuickActionHandler.outputParams output = resultList[0];
        //System.assert(output.isCreaateSuccess != null, 'isCreaateSuccess should not be null');
        
    }
    
}