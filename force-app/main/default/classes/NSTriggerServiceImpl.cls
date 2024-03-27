/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-13-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NSTriggerServiceImpl extends TriggerService{
    /**
    * @description : Operations to be performed before record saved to the database
                   : Operations performed in beforeInsert: 
                   1.
                   2.
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void beforeInsert(){ // NOPMD

    }
    /**
    * @description : Operations to be performed before record updates saved to the database
                   : Operations performed in beforeUpdate: 
                   1.
                   2.
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void beforeUpdate(){ // NOPMD

    }
    /**
    * @description : Operations to be performed before record removed from the database
                   : Operations performed in beforeDelete: 
                   1.
                   2.
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void beforeDelete(){ // NOPMD

    }

    /**
    * @description : Operations to be performed after record inserted to the database
                   : Operations performed in afterInsert
                   1.
                   2.
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void afterInsert(){ 
          //Instance of the handler class where all logic for this trigger is written
          TriggerServiceHandler handler = new TriggerServiceHandler();

          List<NS_Sync_Request__c> syncReqList = new List<NS_Sync_Request__c>();
          
          for(SObject newRec : Trigger.New)
          {   
              //Toggle sync to NS check - start
              //In before save of record to the database Toggle_Sync_to_NS__c field is toggled due to the required condition is met to sync record to netsuite
              if((Boolean)newRec.get('Toggle_Sync_to_NS__c')){
                  NS_Sync_Request__c req = handler.initNSSyncRequest(newRec);  
                  syncReqList.add(req);  
              }//Toggle sync to NS check - end                    
          
          }        
  
          if(!syncReqList.isEmpty()){
              handler.creatNSSyncRequests(syncReqList);
          }
    }

    /**
    * @description : Operations to be performed after record updates saved to the database
                   : Operations performed in afterUpdate:
                   1. Insert NS Sync Request if Toggle Sync to NS it switched from true -> false / false -> true
                   2. Log success or error save result for NS Sync Request insert DML  
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-23-2024 
    **/
    public override void afterUpdate(){

        //Instance of the handler class where all logic for this trigger is written
        TriggerServiceHandler handler = new TriggerServiceHandler();

        List<NS_Sync_Request__c> syncReqList = new List<NS_Sync_Request__c>();
        
        for(SObject newRec : Trigger.New)
        {   
            //Store old account details for update id in oldAcc variable 
            SObject oldRec = Trigger.oldMap.get(newRec.Id);
            
            //Toggle sync to NS check - start
            //In before save of record to the database Toggle_Sync_to_NS__c field is toggled due to the required condition is met to sync record to netsuite
            if(newRec.get('Toggle_Sync_to_NS__c') != oldRec.get('Toggle_Sync_to_NS__c')){
                NS_Sync_Request__c req = handler.initNSSyncRequest(newRec);  
                syncReqList.add(req);  
            }//Toggle sync to NS check - end                    
        
        }        

        if(!syncReqList.isEmpty()){
            handler.creatNSSyncRequests(syncReqList);
        }
    }
    /**
    * @description : Operations to be performed after record is deleted from the database
                   : Operations performed in afterDelete:
                   1.
                   2. 
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void afterDelete(){ // NOPMD
    
    }
    /**
    * @description : Operations to be performed after record is undeleted from the database
                   : Operations performed in afterUndelete:
                   1.
                   2. 
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void afterUndelete(){ // NOPMD
    
    }
}