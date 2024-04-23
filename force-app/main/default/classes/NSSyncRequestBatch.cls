/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NSSyncRequestBatch implements Database.Batchable<SObject>,Database.AllowsCallouts,Database.Stateful {
    
    private String sourceobjectName = '';
    private List<Id> sourceRecIdList;
    private List<NS_Sync_Request__c> syncRecList;
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-20-2024 
    * @param syncRecList 
    * @param sourceobjectName
    **/
    public NSSyncRequestBatch(List<NS_Sync_Request__c> syncRecList,String sourceobjectName) {
        this.syncRecList = syncRecList;
        this.sourceobjectName = sourceobjectName;
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-20-2024 
    * @param bc 
    * @return Database.QueryLocator 
    **/
    public Iterable<sObject> start(Database.BatchableContext bc){
        if(this.syncRecList != null && !this.syncRecList.isEmpty()){
            return new CustomNSSyncRequestIterable(this.syncRecList);
        }
        return  new CustomNSSyncRequestIterable(this.sourceobjectName) ;
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-20-2024 
    * @param bc 
    * @param scope 
    **/
    public void execute(Database.BatchableContext bc, List<SObject> scope){
        List<NSSyncService.SyncParent> syncParentList = new List<NSSyncService.SyncParent>();
        String jsonBody = '';
        HttpResponse resp;
        String message = '';
        try
        {
            
            this.syncRecList = (List<NS_Sync_Request__c>)scope;
            
            syncParentList = NSSyncService.newSyncDataWithNetSuite((List<NS_Sync_Request__c>)scope,this.sourceobjectName);

            jsonBody = NSSyncService.createJSON(syncParentList);
         
            resp = NSSyncService.makeCallout(jsonBody,this.sourceobjectName);

            ResponseJSONWrapper respWrap = new ResponseJSONWrapper(); 
            respWrap = respWrap.parseJson(resp.getBody());

            if( respWrap != null && String.isNotBlank(respWrap.status) && '200'.equalsIgnoreCase(respWrap.status)){
                NSSyncService.updateNSSyncReqStatus('Processed',' ',jsonBody,resp.getBody(),scope,bc.getJobId());
            }else if(respWrap != null && String.isNotBlank(respWrap.status)){
                throw new NSSyncService.NSSyncRequestProcessingException(respWrap.status + ' : ' + respWrap.statusText);
            }
        }
        Catch(Exception e){
            NSSyncService.updateNSSyncReqStatus('Failure',e.getMessage(),jsonBody,resp?.getBody(),scope,bc.getJobId());
        }
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-20-2024 
    * @param bc 
    **/
    public void finish(Database.BatchableContext bc){
        
        /*AsyncApexJob jobInfo = [SELECT Status,NumberOfErrors,TotalJobItems,ExtendedStatus,CompletedDate,LastProcessed,JobType FROM AsyncApexJob WHERE Id=: bc.getJobId()];
        
        for(NS_Sync_Request__c req : this.syncRecList){
            req.Job_Status__c = jobInfo.Status;
            req.NumberOfErrors__c = jobInfo.NumberOfErrors;
            req.TotalJobItems__c = jobInfo.TotalJobItems;
            req.ExtendedStatus__c = jobInfo.ExtendedStatus;
            req.CompletedDate__c = jobInfo.CompletedDate;
            req.LastProcessed__c = jobInfo.LastProcessed;
            req.JobType__c = jobInfo.JobType;
        }
        try{
            update this.syncRecList;
        }catch(Exception e){
            System.debug('jobinfo ==>' + e.getMessage());
        }*/
        //Database.update(this.syncRecList,false);
    }

    public class ResponseJSONWrapper{
        public String statusText = '';
        public String status = '';
        public ResponseJSONWrapper parseJson(String jsonInput){
            return (ResponseJSONWrapper) System.JSON.deserialize(jsonInput, ResponseJSONWrapper.class);
        }
    }
}