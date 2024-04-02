/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 04-02-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class DeleteNetsuiteSyncRequests implements Database.Batchable<sObject>, Schedulable {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        List<Connector_Configurations__c> configCon = [SELECT Id,Schedule_Delete_Job__c,NS_Requests_Delete_Days__c FROM Connector_Configurations__c ORDER BY CreatedDate DESC LIMIT 1 ];
        Date currentDt = Date.today();
        
        if(configCon.size() == 1){
            Connector_Configurations__c configRec = configCon[0];
            Integer userSetDays = Integer.valueOf((Decimal)configRec.get('NS_Requests_Delete_Days__c'));
            if(userSetDays > 0){
                currentDt = currentDt.addDays(-userSetDays);
            }else{
                currentDt = currentDt.addDays(-15);
            }
        }
        String query = 'SELECT Id, (SELECT Id From Attachments) FROM NS_Sync_Request__c WHERE CreatedDate < :currentDt';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<NS_Sync_Request__c> scope) {
        // Delete the NS Sync Request records in the current batch
        delete scope;
    }
    
    public void finish(Database.BatchableContext context) {
        // doNothing;
    }
    
    public void execute(SchedulableContext context) {
        // Implement the scheduling logic here
        DeleteNetsuiteSyncRequests batchJob = new DeleteNetsuiteSyncRequests();
        Database.executeBatch(batchJob,200); 
    }
}