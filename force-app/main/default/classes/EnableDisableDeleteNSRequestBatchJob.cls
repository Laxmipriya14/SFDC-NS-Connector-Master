/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 04-02-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class EnableDisableDeleteNSRequestBatchJob {
    @InvocableMethod(label='Schedule/Abort NSSyncRequest Batch Job' description='Based on User input from connector config deleteNSSyncRequest batch job will be either schduled or deleted')
    public static List<outputParams> createAbortBatchJob(List<inputParams> getInputDetails) {
        List<outputParams> resultList = new List<outputParams>();
        outputParams output = new outputParams();
        try {
            String jobName = 'Delete_Netsuite_Sync_Requests';
            inputParams record = getInputDetails.get(0);
            Boolean isEnable = record.enableBatchJob;
            String scheduleTimings = record.schedulePreference;
            List<CronTrigger> jobIdLst = new List<CronTrigger>();
            jobIdLst = [select id from CronTrigger where CronJobDetailId in (select id from CronJobDetail where Name = :jobName)];
            
            if(isEnable && jobIdLst.size() == 0){
                String cronExp = scheduleTimings; //'0 0 0 * * ?'; // runs every day at 12 AM
                deleteNetsuiteSyncRequests job = new deleteNetsuiteSyncRequests();
                System.schedule(jobName, cronExp, job);
                output.isJobScheduled = true;
            }else{
                if(jobIdLst.Size() > 0){
                    for(CronTrigger job:jobIdLst )
                    {
                        System.abortJob(job.id);
                        output.isJobAborted = true;
                    }
                }
            }
        }
        catch (Exception e) {
            // Catch any exceptions and handle them
            output.errorMessage = ('An error occurred: ' + e.getMessage());
            e.setMessage(e.getMessage());
            throw e;
            
        }
        if(output != null){
            resultList.add(output);
        }
        return resultList;
    }
    public class inputParams {
        @InvocableVariable
        public Boolean enableBatchJob;
        
        @InvocableVariable
        public String schedulePreference;
        
    }
    
    public class outputParams {
        @InvocableVariable 
        public String errorMessage;
        
        @InvocableVariable 
        public Boolean isJobScheduled;
        
        @InvocableVariable 
        public Boolean isJobAborted;
    }
}