/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TriggerServiceHandler {
    

    /**
    * @description : This is the common method for all the trigger services on specific objects  
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-21-2024 
    * @param sourceRec 
    * @return NS_Sync_Request__c 
    **/
    public NS_Sync_Request__c initNSSyncRequest(SObject sourceRec){
        Id sourceRecId = (Id)sourceRec.get('Id');
        String sourceRecordType = String.valueOf(sourceRec.getSObjectType());
        String sourceRecName = String.valueOf(sourceRec.get('Name'));

        return new NS_Sync_Request__c(
            Source_Record_Id__c = sourceRecId, 
            Source_Object_Type__c = sourceRecordType,
            Sync_Status__c = 'Queued'
            );
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-04-2024 
    * @param syncReqList 
    **/
    public void creatNSSyncRequests(List<NS_Sync_Request__c> syncReqList)
    {
        List<NS_Connector_Logs__c> errorLogList = new List<NS_Connector_Logs__c>();
        //Insert NS Sync Requests-start
        List<Database.SaveResult> resultList = Database.insert(syncReqList,false);

        if(resultList != null && !resultList.isEmpty()){
            for(Integer i = 0; i < resultList.size();i++){
                if(!resultList[i].isSuccess()){
                    //log successfully inserted 
                    for(Database.Error err : resultList[i].getErrors()){
                        errorLogList.add(new NS_Connector_Logs__c(Component_Name__c ='TriggerServiceHandler:creatNSSyncRequests',
                        Error_Message__c = 'Object Type : '+syncReqList[i].Source_Object_Type__c +' Error : '+err.getMessage(),
                        Logging_Level__c = String.valueOf(LoggingLevel.ERROR),
                        Source_Record_Id__c = syncReqList[i].Source_Record_Id__c,
                        Timestamp__c = system.now()) );
                    }
                }
            }
        }

        if(!errorLogList.isEmpty()){
            insert errorLogList;
        }
        //Insert NS Sync Requests-end

    }
}