/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 03-21-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class DeleteNetsuiteSyncRequestsTest {
    
    @isTest
    static void testStartMethod() {
        // Test setup
        NS_Sandboxes__c inst = new NS_Sandboxes__c();
        inst.Name = 'demo sandbox';
        inst.End_Point_URL__c = 'https://td2345/restlet.api';
        insert inst;
        
        Connector_Configurations__c config = new Connector_Configurations__c();
        config.Enable_Sync__c = true;
        config.Netsuite_Instance__c = inst.id;
        insert config;
        
        
        // Call the start method
        Test.startTest();
        DeleteNetsuiteSyncRequests batchClass = new DeleteNetsuiteSyncRequests();
        Database.QueryLocator queryLocator = batchClass.start(null);
        Test.stopTest();
    }
    
    @isTest
    static void testExecuteMethod() {
        // Call the execute method
        Test.startTest();
        DeleteNetsuiteSyncRequests batchClass = new DeleteNetsuiteSyncRequests();
        batchClass.execute(null, new List<NS_Sync_Request__c>());
        Test.stopTest();
    }
    
    @isTest
    static void testFinishMethod() {
        // Test the finish method
        Test.startTest();
        DeleteNetsuiteSyncRequests batchClass = new DeleteNetsuiteSyncRequests();
        batchClass.finish(null);
        Test.stopTest();
    }
    
    @isTest
    static void testSchedulableMethod() {
        // Test the schedulable method
        Test.startTest();
        DeleteNetsuiteSyncRequests batchClass = new DeleteNetsuiteSyncRequests();
        batchClass.execute(null);
        Test.stopTest();
    }
}