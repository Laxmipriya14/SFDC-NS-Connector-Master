/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CustomNSSyncRequestIterable implements Iterable<NS_Sync_Request__c> {
    public String objName = '';
    public List<NS_Sync_Request__c> syncRecList;
    public CustomNSSyncRequestIterable(String objName){
        this.objName = objName;
    }
    public CustomNSSyncRequestIterable(List<NS_Sync_Request__c> syncRecList){
        this.syncRecList = syncRecList;
    }
    public Iterator<NS_Sync_Request__c> iterator() {
        List<NS_Sync_Request__c> syncRequestList = new List<NS_Sync_Request__c>();
        if(String.isNotBlank( this.objName)){
            syncRequestList = [SELECT Id, Sync_Status__c, Sync_Error__c, Source_Record_Id__c, Source_Object_Type__c,Job_Status__c,NumberOfErrors__c,TotalJobItems__c,ExtendedStatus__c,CompletedDate__c,LastProcessed__c,JobType__c FROM NS_Sync_Request__c WHERE Sync_Status__c = 'Queued' AND Source_Object_Type__c =: this.objName];
        }else if(this.syncRecList != null && !this.syncRecList.isEmpty()){
            syncRequestList = [SELECT Id, Sync_Status__c, Sync_Error__c, Source_Record_Id__c, Source_Object_Type__c,Job_Status__c,NumberOfErrors__c,TotalJobItems__c,ExtendedStatus__c,CompletedDate__c,LastProcessed__c,JobType__c FROM NS_Sync_Request__c WHERE Id In: this.syncRecList ];
        }
    
        return new CustomNSSyncRequestIterator(syncRequestList);
    }
}