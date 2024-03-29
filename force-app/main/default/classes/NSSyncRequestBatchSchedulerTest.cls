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
}