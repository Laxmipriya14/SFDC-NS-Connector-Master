@isTest
private class NSSyncRequestTriggerTest {

    @isTest
    static void testTriggerLogic() {
        NS_Sync_Request__c testSyncRequest = new NS_Sync_Request__c();
        insert testSyncRequest;

        Test.startTest();
        NS_Sync_Request__c newSyncRequest = new NS_Sync_Request__c();
        insert newSyncRequest;
        Test.stopTest();

    }
}