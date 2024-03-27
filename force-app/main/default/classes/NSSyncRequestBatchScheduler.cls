/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NSSyncRequestBatchScheduler implements schedulable {
    public String objName; 
    public NSSyncRequestBatchScheduler(String objName){
        this.objName = objName;
    }
    public void execute(schedulableContext ctx){
        NSSyncRequestBatchHelper batchHelp =  new NSSyncRequestBatchHelper(new List<NS_Sync_Request__c>(),this.objName);
        batchHelp.execute();
    }
}