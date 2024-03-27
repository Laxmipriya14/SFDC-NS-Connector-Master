/**
 * @description       : Service implementation for NS Sync Request trigger
 *                      This class calls the methods in NSSyncRequestTriggerHanlder class
 *                      which consist of all the logic for this trigger.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class NSSyncRequestTriggerServiceImpl extends TriggerService
{
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
                   1. Execute NS Sync Request batch to sync data to Netsuite
                   2.
                   Note: Remove NOPMD comment when logic is written in this method. So that code under this method can be scanned by SF Code Analyzer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    **/
    public override void afterInsert(){
        String objName = '';
        
        for(NS_Sync_Request__c req : (List<NS_Sync_Request__c>)Trigger.new){
            objName = req.Source_Object_Type__c;
            break; 
        }

        //Execute NS Sync Request batch immediatly or schedule if another instance is running
        NSSyncRequestBatchHelper batchHelp =  new NSSyncRequestBatchHelper((List<NS_Sync_Request__c>)Trigger.new,objName);
        batchHelp.execute();

    }

    /**
    * @description : Operations to be performed after record updates saved to the database
                   : Operations performed in afterUpdate:
                   1. Insert NS Sync Request if Toggle Sync to NS it switched from true -> false / false -> true
                   2. Log success or error save result for NS Sync Request insert DML  
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-23-2024 
    **/
    public override void afterUpdate(){ //NOPMD
        System.debug('in after update ==>');
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