/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 03-18-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NSSyncRequestBatchHelper{
    
    public List<NS_Sync_Request__c> syncRecList;
    public String objName;
    
    public NSSyncRequestBatchHelper(List<NS_Sync_Request__c> syncRecList,String objName){
        this.syncRecList = syncRecList;
        this.objName = objName;
    } 
    
    public void execute(){
        List<AsyncApexJob> apexJob = [SELECT id FROM AsyncApexJob WHERE Status In ('Holding','Preparing','Processing','Queued') AND ApexClass.Name = 'NSSyncRequestBatch'];
        Datetime now = Datetime.now();
        Integer minutesFromNow = 2;
        // Calculate the scheduled time
        Datetime scheduledTime = now.addMinutes(minutesFromNow);
        // Build the cron expression
        String cronExpression = scheduledTime.second() + ' ' + scheduledTime.minute() + ' ' + scheduledTime.hour() + ' ' + scheduledTime.day() + ' ' + scheduledTime.month() + ' ? ' + scheduledTime.year();
        if(apexJob != null && !apexJob.isEmpty()){  
            NSSyncRequestBatchScheduler nsReq = new NSSyncRequestBatchScheduler( this.objName);
            System.schedule('Connector Scheduled Batch', cronExpression, nsReq);                   
        }else{
            Database.executeBatch(new NSSyncRequestBatch(this.syncRecList,this.objName),1);
        } 
    }
}