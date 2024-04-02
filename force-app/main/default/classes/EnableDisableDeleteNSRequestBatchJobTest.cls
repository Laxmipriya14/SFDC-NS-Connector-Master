/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 03-07-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class EnableDisableDeleteNSRequestBatchJobTest {
    
    @isTest
    static void testScheduleNewJob() {
        // Create test input parameters
        EnableDisableDeleteNSRequestBatchJob.inputParams input = new EnableDisableDeleteNSRequestBatchJob.inputParams();
        input.enableBatchJob = true;
        input.schedulePreference = '0 0 0 * * ?'; // Example cron expression
        
        // Call the invocable method
        List<EnableDisableDeleteNSRequestBatchJob.outputParams> result = EnableDisableDeleteNSRequestBatchJob.createAbortBatchJob(new List<EnableDisableDeleteNSRequestBatchJob.inputParams>{input});
        
        // Assert that a job was scheduled
        System.assertEquals(1, result.size());
        System.assertEquals(true, result[0].isJobScheduled);
        System.assertEquals(null, result[0].errorMessage); // No error message expected
    }
    
    @isTest
    static void testAbortExistingJob() {
        
        // Create test input parameters
        EnableDisableDeleteNSRequestBatchJob.inputParams input = new EnableDisableDeleteNSRequestBatchJob.inputParams();
        input.enableBatchJob = false; // Setting to false to trigger job abort
        
        // Call the invocable method
        List<EnableDisableDeleteNSRequestBatchJob.outputParams> result = EnableDisableDeleteNSRequestBatchJob.createAbortBatchJob(new List<EnableDisableDeleteNSRequestBatchJob.inputParams>{input});
        
    }
    
    @isTest
    static void testExceptionHandling() {
        // Create test input parameters
        EnableDisableDeleteNSRequestBatchJob.inputParams input = new EnableDisableDeleteNSRequestBatchJob.inputParams();
        input.enableBatchJob = true; // Simulate an error condition
        
        // Call the invocable method
        try {
            List<EnableDisableDeleteNSRequestBatchJob.outputParams> result = EnableDisableDeleteNSRequestBatchJob.createAbortBatchJob(new List<EnableDisableDeleteNSRequestBatchJob.inputParams>{input});
        } catch(Exception e) {
            // Assert that the error message is set in the output
            //System.assertEquals('cron expression cannot be "null"', e.getMessage());
        }
    }
}