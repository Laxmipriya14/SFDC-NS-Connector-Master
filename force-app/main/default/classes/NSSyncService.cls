/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NSSyncService {

    public static boolean avoidRecurssion = false; 
    public static string  parentObject ;
    private static List<SObject_Mapping__c> lstParentMappings ;         // List of parent mapping records
    private static List<SObject_Mapping__c> lstChildMappings ;          // List of child mapping records
    private static Map<Id,SObject_Mapping__c> recordMappingDetails = new Map<Id,SObject_Mapping__c>() ;         // Map of recordId and soject mapping record satisfying condition.
    private static Map<Id,sObject> parentRecords = new Map<Id,sObject>();              

    private static Map<String,Map<String,List<sObject>>> parentChildMap = new Map<String,Map<String,List<sObject>>>();   // Key: ParentId , Value : Map of child objectname and list of child records.
    private static Map<Id,List<SObject_Mapping__c>> parentChildMapping = new Map<Id,List<sObject_Mapping__c>>();
    public class NSSyncRequestProcessingException extends Exception{}
    public class SyncParent{
        sObject record;
        SObject_Mapping__c Mapping;
        boolean sendAccount;
        String parentObjectName;
        SObject_Mapping__c accountMapping;
        sObject accountRecord;
        Map<string,List<SyncChild>> childRecords;
        
        private syncParent(){  
            sendAccount = false;
        }
    }
    
    private class SyncChild{
        sObject record;
        SObject_Mapping__c Mapping;
    }
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-14-2024 
    * @param syncRecList 
    * @param sourceobjectName 
    * @return List<SObject> 
    **/
    public static List<SObject> getSourceRecords(List<NS_Sync_Request__c> syncRecList,String sourceobjectName){
        String query = '';
        List<Id> sourceRecIdList = new List<Id>();
        List<String> sourceObjfieldList = new List<String>();
        NSSyncRequestBatchService batchService = new NSSyncRequestBatchService();
        for(NS_Sync_Request__c syncReq : syncRecList){
            sourceRecIdList.add(syncReq.Source_Record_Id__c);
        }
        sourceObjfieldList = batchService.getSourceObjFields(sourceobjectName);
        query = batchService.getSourceObjQuery(sourceObjfieldList,sourceobjectName,sourceRecIdList);
		return Database.query(query);        
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-14-2024 
    * @param status 
    * @param message 
    * @param request 
    * @param response 
    * @param scope 
    * @param jobId 
    **/
    public static void updateNSSyncReqStatus(String status, 
                                             String message,
                                             String request,
                                             String response,
                                             List<NS_Sync_Request__c> scope,
                                             String jobId){
        
       
            List<NS_Sync_Request__c> updateReqList = new List<NS_Sync_Request__c>();
            List<ContentVersion> contentVersionList = new List<ContentVersion>();
            Set<Id> sobjectIdlist = new Set<Id>();
            List<SObject> sobjectlist = new List<SObject>();
            String objName;  
            AsyncApexJob jobInfo = [SELECT Status,NumberOfErrors,TotalJobItems,ExtendedStatus,CompletedDate,LastProcessed,JobType FROM AsyncApexJob WHERE Id=: jobId];

            try{  
                for(NS_Sync_Request__c req : scope)
                {    
                    req.Sync_Status__c = status;
                    req.Sync_Error__c = message;
                    objName = objName ?? req.Source_Object_Type__c;

                    if('Failure'.equalsIgnoreCase(status)){
                        sobjectIdlist.add(req.Source_Record_Id__c);
                    }
                    if(String.isNotBlank(request)){
                        contentVersionList.add( new ContentVersion (Title = 'Request.txt',PathOnClient ='Request.txt',VersionData = Blob.valueOf(request),FirstPublishLocationId = req.Id));
                    }
                    if(String.isNotBlank(response)){
                        contentVersionList.add( new ContentVersion (Title = 'Request.txt',PathOnClient ='Request.txt', Body = Blob.valueOf(response),FirstPublishLocationId = req.Id));
                    }
                    req.Job_Status__c = jobInfo.Status;
                    req.NumberOfErrors__c = jobInfo.NumberOfErrors;
                    req.TotalJobItems__c = jobInfo.TotalJobItems;
                    req.ExtendedStatus__c = jobInfo.ExtendedStatus;
                    req.CompletedDate__c = jobInfo.CompletedDate;
                    req.LastProcessed__c = jobInfo.LastProcessed;
                    req.JobType__c = jobInfo.JobType;
                    req.Job_Id__c = jobId;
                    updateReqList.add(req);
                }
                update updateReqList;
                insert contentVersionList;
                if(!sobjectIdlist.isEmpty() && String.isNotBlank(objName)){
                    String query = 'SELECT id,Netsuite_Sync_Status__c FROM ' + objName + ' WHERE id In: sobjectIdlist'; 
                    for(SObject obj : Database.query(query)){
                        obj.put('Netsuite_Sync_Status__c','Failure');
                        sobjectlist.add(obj);
                    }
                }

              
                update sobjectlist;
            }Catch(Exception e){
                List<NS_Connector_Logs__c> errorLogList = new List<NS_Connector_Logs__c>();
                errorLogList.add(new NS_Connector_Logs__c(Component_Name__c ='NSSyncService:updateNSSyncReqStatus',
                        Error_Message__c = ' Error : '+e.getMessage(),
                        Logging_Level__c = String.valueOf(LoggingLevel.ERROR),
                        Timestamp__c = system.now()) );
                insert errorLogList;
            }
    }
       
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-14-2024 
    * @param syncRecList 
    * @param SobjectAPIName 
    * @return List<SyncParent> 
    **/
    @TestVisible
    public static List<SyncParent> newSyncDataWithNetSuite(List<NS_Sync_Request__c> syncRecList, String SobjectAPIName)
    {
        avoidRecurssion = true;
        parentObject = SobjectAPIName;
        List<SObject> lstSobject = new List<SObject>();
        lstSobject = getSourceRecords(syncRecList,SobjectAPIName);
        lstParentMappings =           [SELECT Id, Name,
                                           Relationship_Type__c,
                                           JSON_Sobject_Name__c,
                                           Parent_SObject_Map__c,
                                           Relationship_with_parent__c,
                                           Include_Billing_Address__c,
                                           Include_Shipping_Address__c,
                                           Include_Other_Address__c,
                                           Include_Mailing_Address__c,
                                           End_Point_URL__c,
                                           (SELECT Id, 
                                            Field_Type__c, 
                                            SObject_Mapping__c, 
                                            NetSuite_Field_API_Name__c, 
                                            SFDC_Field_API_Name__c,
                                            JSON_Sobject_Name__c,
                                            Type__c,
                                            IsActive__c
                                            FROM Field_Mappings__r WHERE IsActive__c = TRUE)
                                           FROM SObject_Mapping__c 
                                           WHERE Name =: SobjectAPIName  AND IsActive__c = TRUE]; 
        Set<Id> parentSobjectMappingIds = new Set<Id>();
        
        
        String relationshipType = '';
        Integer c = 0;
        for(sObject record : lstSobject){
            for(SObject_Mapping__c mapping : lstParentMappings)
            {
                //Ids of the Sobject mapping record used to fetch child records 
                parentSobjectMappingIds.add(mapping.Id); 
                
                //source object id -> Sobject mapping record
                recordMappingDetails.put(String.valueOf(record.get('Id')), mapping);
                
                //source object id -> source object record
                parentRecords.put(String.valueOf(record.get('Id')), record);
                
                
                relationshipType = mapping.Relationship_Type__c;
            }
        }

        getChildRecords(parentSobjectMappingIds, parentRecords.keyset());

        //recordMappingDetails : record Id -> object mapping
        //accountMappingRecord : list of sobject mapping
        //parentChildMap : parent record Id -> (child obj name -> child records list)
        //parentChildMapping : Parent Sobject mapping Id -> list of child sobjectmapping 
        List<SyncParent> serializeList = new List<SyncParent>();
        for(sObject pr : parentRecords.values())
        {
            SyncParent p = new SyncParent();
            Map<String,List<SyncChild>> tempMap = new Map<String,List<SyncChild>>();
            p.record = pr;
            P.Mapping = recordMappingDetails.get(String.valueOf(pr.get('Id')));
        
            if( !parentChildMap.isEmpty() && parentChildMap.containsKey(String.valueOf(pr.get('Id'))))
            {
                for(String childObjectName : parentChildMap.get(String.valueOf(pr.get('Id'))).keyset())
                {
                    SObject_Mapping__c childMapping ;
                    if(parentChildMapping.containsKey(recordMappingDetails.get(String.valueOf(pr.get('Id'))).Id))
                    {
                        for(SObject_Mapping__c cm :parentChildMapping.get(recordMappingDetails.get(String.valueOf(pr.get('Id'))).Id))
                        {
                            if(cm.Name == childObjectName){
                                if('Account'.equalsIgnoreCase(childObjectName)){
                                    p.accountMapping = cm;
                                    p.sendAccount = true;
                                }else{
                                    childMapping = cm;
                                }
                                break;
                            }   
                        }
                        List<SyncChild> lstCh = new List<SyncChild>();
                        for(sObject childRecord : parentChildMap.get(String.valueOf(pr.get('Id'))).get(childObjectName))
                        {
                            if('Account'.equalsIgnoreCase(childObjectName)){
                                p.accountRecord = childRecord;
                            }else{
                                SyncChild Ch = new SyncChild();
                                Ch.record = childRecord;
                                Ch.Mapping = childMapping;
                                lstCh.add(Ch);
                            }
                        }
                        tempMap.put(childObjectName,lstCh);
                    }
                }
                p.childRecords = tempMap;
            }
            serializeList.add(p);
        }
      
        /** Initiate wrapper class - end */
        if(serializeList.isEmpty()){
            throw new NSSyncRequestProcessingException('No records for processing');
        }
        return serializeList;
    }
    
    
    /**
    * @description : returns two maps 
                     1. parentChildMapping : Parent Sobject mapping Id -> list of child sobjectmapping 
                     2. parentChildMap : parent record Id -> (child obj name -> child records list) 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-07-2024 
    * @param parentSobjectMappingIds 
    * @param parentRecordIds 
    * @return boolean 
    **/
    @TestVisible
    private static boolean getChildRecords(Set<Id> parentSobjectMappingIds,Set<Id> parentRecordIds){
        lstChildMappings =               [SELECT Id, Name,
                                          Relationship_Type__c,
                                          JSON_Sobject_Name__c,
                                          Parent_SObject_Map__c,
                                          Relationship_with_parent__c,
                                          (SELECT Id, 
                                           Field_Type__c, 
                                           SObject_Mapping__c, 
                                           NetSuite_Field_API_Name__c, 
                                           SFDC_Field_API_Name__c,
                                           JSON_Sobject_Name__c,
                                           Type__c,
                                           IsActive__c
                                           FROM Field_Mappings__r WHERE IsActive__c = TRUE)
                                          FROM SObject_Mapping__c 
                                          WHERE Parent_SObject_Map__c IN : parentSobjectMappingIds  AND IsActive__c = TRUE];         
        
        
        if(lstChildMappings.size() > 0)
        {
            Map<String,Set<String>> childFields = new Map<String,Set<String>>();
            Map<String,String> relationshipNameMap = new Map<String,String>();
            
            //1. Prepare map of child obj name -> child obj fields &
            //2. prepare map of Parent Sobject mapping Id -> list of child sobjectmapping record
            for(SObject_Mapping__c childMapping : lstChildMappings)
            {
                Set<String> fieldsSet = new Set<String>();
                //name of the object -> foreign key
                relationshipNameMap.put(childMapping.Name,childMapping.Relationship_with_parent__c);
                fieldsSet.add(childMapping.Relationship_with_parent__c);
                List<SObject_Mapping__c> tempList = new List<SObject_Mapping__c>();

                if(parentChildMapping.keyset().contains(childMapping.Parent_SObject_Map__c))
                {
                    tempList = parentChildMapping.get(childMapping.Parent_SObject_Map__c);
                }

                tempList.add(childMapping);
                
                //Parent Sobject mapping Id -> list of child sobjectmapping 
                parentChildMapping.put(childMapping.Parent_SObject_Map__c,tempList); //global

                List<Field_Mapping__c> fieldsMappingList = childMapping.Field_Mappings__r;
                
                if(!fieldsMappingList.isEmpty()){
                    for(Field_Mapping__c fieldMapping : fieldsMappingList){
                        fieldsSet.add(fieldMapping.SFDC_Field_API_Name__c);
                    }
                }
               
                childFields.put(childMapping.Name,fieldsSet);
               
            }

            Map<String,List<sObject>> childRecords = new Map<String,List<sObject>>();
            
            if(childFields.keySet().size() > 0)
            {
                //3. Query on all child object records and store it in the map 
                for(String childObject : childFields.keyset())
                {
                    List<sObject> childList = new List<sObject>();

                    String query = 'SELECT ';
                    
                    for(String field : childFields.get(childObject)){
                        query += field +',';
                    }
                    
                    query = query.removeEnd(',');
                    
                    query += ' FROM '+ childObject +' Where '+ relationshipNameMap.get(childObject) +' IN : parentRecordIds';

                    childList= database.query(query);
                    
                    childRecords.put(childObject, childList);
                }
            }

           
           //4. loop over map in 3rd point to prepare map of parent Id -> (child obj name -> child records list)
            for(String childObject :  childRecords.keyset())
            {
                //child objname -> records
                Map<String,List<sObject>> a = new Map<String,List<sObject>>();

                for(sObject record :  childRecords.get(childObject))
                {
                    String parentRecordId = String.valueOf(record.get(relationshipNameMap.get(childObject)));

                    if(parentChildMap.keySet().contains(parentRecordId))
                    {
                        if(parentChildMap.get(parentRecordId).keyset().contains(childObject)){
                            parentChildMap.get(parentRecordId).get(childObject).add(record);
                        }else{
                            Map<String,List<sObject>> tempMap = parentChildMap.get(parentRecordId);
                            List<sObject> tempList2 = new List<sObject>();
                            tempList2.add(record);
                            tempMap.put(childObject,tempList2);
                            parentChildMap.get(parentRecordId).put(childObject,tempList2);
                        }
                    }else
                    {
                        List<sObject> tempList = new List<sObject>();
                        tempList.add(record);
                        a.put(childObject,tempList);
                        parentChildMap.put(parentRecordId, a);
                    }

                }
            }

            return true;
        }
        return false;
    }
    

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-14-2024 
    * @param serializeList 
    * @return String 
    **/
    public static String createJSON(List<SyncParent> serializeList){
        String jsonString = '';//{   
        String parentNode = '';
        boolean flag = false;
        String jsonContent = '';
        for(SyncParent parent : serializeList){
            jsonContent += '{';
            if(!flag){
                parentNode += '"' + recordMappingDetails.get(String.valueOf(parent.record.get('Id'))).JSON_Sobject_Name__c +'" : [';
                flag = true;
            }
            String addressString = '';
            String parentPart = newSerializeSobject1(parent.record, parent.mapping.Field_Mappings__r, recordMappingDetails.get(String.valueOf(parent.record.get('Id'))).JSON_Sobject_Name__c);
            String addressStr = '';
            if(parent.mapping.include_billing_address__c && parentObject == 'Account' ){
                addressStr += '{' + serializeAddress(parent.record,'Billing') + '},';
            }
            if(parent.mapping.include_shipping_address__c && parentObject == 'Account') {
                addressStr += '{' +serializeAddress(parent.record,'Shipping') +'},';
            }
            if(parent.mapping.include_other_address__c && parentObject == 'Contact' ){
                addressStr += '{' + serializeAddress(parent.record,'Other') + '},';
            }
            if(parent.mapping.include_mailing_address__c && parentObject == 'Contact') {
                addressStr += '{' +serializeAddress(parent.record,'Mailing') +'},';
            }
            
            addressStr = addressStr.removeEnd(',');
            if(addressStr != '')
                parentPart += ',"addressbook" : [' + addressStr +']';
            
            String childStr = '';  
            String accStr = '';
            SObject_Mapping__c childMapping = new SObject_Mapping__c();
            if(parent.childRecords != null){
                for(String childObjectName : parent.childRecords.keySet() ){
                    for(SObject_Mapping__c cm :parentChildMapping.get(recordMappingDetails.get(String.valueOf(parent.record.get('Id'))).Id))
                    {
                        if(cm.Name == childObjectName){
                            childMapping = cm;
                            break;
                        }   
                    }
                    
                    childStr += '"' + childMapping.JSON_Sobject_Name__c +'" : [';
                    for(SyncChild child : parent.childRecords.get(childObjectName)){
                        childStr += '{';
                        childStr += newSerializeSobject1(child.record, childMapping.Field_Mappings__r, childMapping.JSON_Sobject_Name__c);
                        childStr += '},';
                    }
                    childStr = childStr.removeEnd(',');
                    childStr += '],';
                }
                childStr = childStr.removeEnd(',');
            }
            if(parent.sendAccount){
                accStr += '"' + parent.AccountMapping.JSON_Sobject_Name__c +'" : {';
                accStr +=  newSerializeSobject1(parent.AccountRecord, parent.AccountMapping.Field_Mappings__r, parent.AccountMapping.JSON_Sobject_Name__c);
                
                String addressStrChild = '';
                if(parent.AccountMapping.include_billing_address__c  ){
                    addressStrChild += '{' + serializeAddress(parent.AccountRecord,'Billing') + '},';
                }
                if(parent.AccountMapping.include_billing_address__c ) {
                    addressStrChild += '{' +serializeAddress(parent.AccountRecord,'Shipping') +'},';
                }
                addressStrChild = addressStrChild.removeEnd(',');
                if(addressStrChild != '')
                    accStr += ',"addressbook" : [' + addressStrChild +']';
                
                accStr += '}';
            }
            if(parentPart != null){
                jsonContent +=  parentPart;
            }
            
            if(accStr != ''){
                jsonContent += ',';
                jsonContent += accStr;
            }
            
            if(childStr != ''){
                jsonContent += ',';
                jsonContent += childStr; 
            }
            jsonContent += '},';
        }
        jsonContent = jsonContent.removeEnd(',');
        String operation = '';
        jsonString += '{'+ '"Operation" : "'+operation+'", '+parentNode + jsonContent +']' ;
        jsonString += '}';

        return jsonString;
    }
    
    @TestVisible
    private static String serializeAddress(sObject record, String addressType){
        String addStr = '';
        if(addressType == 'Billing'){
            if(record.get('BillingStreet') != null){
                addStr += '"Street" :  "' + String.valueOf(record.get('BillingStreet')) +'" ,' ;
            }
            
            if(record.get('BillingCity') != null){
                addStr += '"City" :  "' + String.valueOf(record.get('BillingCity')) +'",' ;
            }
           
            
            if(record.get('BillingState') != null){
                addStr += '"State" :  "' + String.valueOf(record.get('BillingState')) +'",' ;
            }
            
            if(record.get('Billingpostalcode') != null){
                addStr += '"ZIP" :  "' + String.valueOf(record.get('Billingpostalcode')) +'",' ;
            }
            if(record.get('BillingCountry') != null){
                addStr += '"Country" :  "' + String.valueOf(record.get('BillingCountry')) +'",' ;
            }
            addStr += '"Type" :  "' + addressType +'"' ;
        
        }
        
        if(addressType == 'Shipping'){
            if(record.get('ShippingStreet') != null){
                addStr += '"Street" :  "' + String.valueOf(record.get('ShippingStreet')) +'" ,' ;
            }
            
            if(record.get('ShippingCity') != null){
                addStr += '"City" :  "' + String.valueOf(record.get('ShippingCity')) +'",' ;
            }
            
            if(record.get('ShippingState') != null){
                addStr += '"State" :  "' + String.valueOf(record.get('ShippingState')) +'",' ;
            }
            
            if(record.get('Shippingpostalcode') != null){
                addStr += '"ZIP" :  "' + String.valueOf(record.get('Shippingpostalcode')) +'",' ;
            }
            if(record.get('ShippingCountry') != null){
                addStr += '"Country" :  "' + String.valueOf(record.get('ShippingCountry')) +'",' ;
            }
            addStr += '"Type" :  "' + addressType +'"' ;
            
        }
        
        if(addressType == 'Other'){
            if(record.get('OtherStreet') != null){
                addStr += '"Street" :  "' + String.valueOf(record.get('OtherStreet')) +'" ,' ;
            }
            
            if(record.get('OtherCity') != null){
                addStr += '"City" :  "' + String.valueOf(record.get('OtherCity')) +'",' ;
            }
            
            if(record.get('OtherState') != null){
                addStr += '"State" :  "' + String.valueOf(record.get('OtherState')) +'",' ;
            }
            
            if(record.get('Otherpostalcode') != null){
                addStr += '"ZIP" :  "' + String.valueOf(record.get('Otherpostalcode')) +'",' ;
            }
            if(record.get('OtherCountry') != null){
                addStr += '"Country" :  "' + String.valueOf(record.get('OtherCountry')) +'",' ;
            }
            addStr += '"Type" :  "' + addressType +'"' ;
           
        }
        if(addressType == 'Mailing'){
            if(record.get('MailingStreet') != null){
                addStr += '"Street" :  "' + String.valueOf(record.get('MailingStreet')) +'" ,' ;
            }
            
            if(record.get('MailingCity') != null){
                addStr += '"City" :  "' + String.valueOf(record.get('MailingCity')) +'",' ;
            }
            
            if(record.get('MailingState') != null){
                addStr += '"State" :  "' + String.valueOf(record.get('MailingState')) +'",' ;
            }
            
            if(record.get('Mailingpostalcode') != null){
                addStr += '"ZIP" :  "' + String.valueOf(record.get('Mailingpostalcode')) +'",' ;
            }
            if(record.get('MailingCountry') != null){
                addStr += '"Country" :  "' + String.valueOf(record.get('MailingCountry')) +'",' ;
            }
            addStr += '"Type" :  "' + addressType +'"' ;
            
        }
        return addStr;
    }
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-14-2024 
    * @param sobj 
    * @param lstFieldMapping 
    * @param JSONobjectName 
    * @return String 
    **/
    @TestVisible
    private static String newSerializeSobject1(Sobject sobj , List<Field_Mapping__c> lstFieldMapping,String JSONobjectName){
        //     String singleJSONrec = '{ "'+ JSONobjectName +'" : { ';
        String singleJSONrec ='';
        String strParentFieldJSON =''; 
        String strChildFieldJSON ='';
        for(Field_Mapping__c objFM : lstFieldMapping){
            strParentFieldJSON += String.isEmpty(strParentFieldJSON) ? serializeField(sobj, objFM.SFDC_Field_API_Name__c, objFM.NetSuite_Field_API_Name__c, objFM.Field_Type__c):
            ',' + serializeField(sobj, objFM.SFDC_Field_API_Name__c, objFM.NetSuite_Field_API_Name__c, objFM.Field_Type__c);
        }
        singleJSONrec += strParentFieldJSON;
        
        return singleJSONrec;
    }
    
 
    public static HttpResponse makeCallout(String JSONBody, String sObjectName){
  
        ConnectorConfigurationsClass connectorConfig = ConnectorConfigurationsClass.getInstance();
        Connector_Configurations__c config = connectorConfig.config;
        NS_Sandboxes__c sandboxDet;
        List<NS_Sandboxes__c> sandboxDetList = new List<NS_Sandboxes__c>();
        sandboxDetList = [SELECT Id,End_Point_URL__c,Realm__c,Signature_Method__c,
        (SELECT Id,Object_Name__c,Script_URL__c FROM NS_Sync_Scripts__r WHERE Object_Name__c =: sObjectName)
        FROM NS_Sandboxes__c WHERE Id=: config.Netsuite_Instance__c Limit 1];
        if(!sandboxDetList.isEmpty()){
            sandboxDet = sandboxDetList.get(0);
        }
       
        String endpointURL = sandboxDet?.End_Point_URL__c + sandboxDet?.NS_Sync_Scripts__r?.Script_URL__c ;
         

        if(sandboxDet.NS_Sync_Scripts__r == null || sandboxDet.NS_Sync_Scripts__r.isEmpty()){
            throw new NSSyncRequestProcessingException('NS Script URL for ' + sObjectName + ' is Missing. Please add it under NS Sandbox record which is currently integrated with this sandbox.');
        }
        
        NSOAUTH1Service auth1Service = new NSOAUTH1Service(sandboxDet);
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        auth1Service.setOAUTH1Authorization(req);
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setBody(JSONBody);
        req.setEndpoint(endPointUrl);
        HttpResponse resp = http.send(req);
        return resp;
    }
    
    
    
    /**
    * @description : Method to send serialized response of one field.
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-14-2024 
    * @param objSobject 
    * @param SFDCFieldAPIName 
    * @param NetSuiteFieldAPIName 
    * @param fieldType 
    * @return String 
    **/
    @TestVisible
    private static String serializeField(Sobject objSobject, String SFDCFieldAPIName, String NetSuiteFieldAPIName, String fieldType){ 
        if(SFDCFieldAPIName != null && SFDCFieldAPIName.contains('.')){
            List<String> lstVar = new List<String>();
            lstVar = SFDCFieldAPIName.split('\\.');
            
            string test = '"' + NetSuiteFieldAPIName+'" : "' + String.valueOf(objSobject.getSObject(lstVar[0]).get(lstVar[1]))+'"';
            
            return '"' + NetSuiteFieldAPIName+'" : "' + String.valueOf(objSobject.getSObject(lstVar[0]).get(lstVar[1]))+'"'; 
        }
        
        if(objSobject.get(SFDCFieldAPIName) == null) return '"' + NetSuiteFieldAPIName+'" : ""';
        if(fieldType == 'Checkbox'){
            return '"' + NetSuiteFieldAPIName+'" : "' + Boolean.valueOf(objSobject.get(SFDCFieldAPIName))+'"';
        } else if(fieldType == 'Date'){
            return '"' + NetSuiteFieldAPIName+'" : "' + String.valueOf(objSobject.get(SFDCFieldAPIName)).removeEnd(' 00:00:00')+'"';
            
            
        } else if(fieldType == 'Date/Time'){
            return '"' + NetSuiteFieldAPIName + '" : "' + DateTime.valueOf(objSobject.get(SFDCFieldAPIName))+'"';
        } else if(fieldType == 'Number' || fieldType == 'Percent' || fieldType == 'Currency'){
            return '"' + NetSuiteFieldAPIName + '" : "' + Double.valueOf(objSobject.get(SFDCFieldAPIName))+'"';
        } else if(fieldType == 'Phone' || fieldType == 'Picklist' || fieldType == 'Text' || fieldType == 'Text Area' || fieldType == 'URL' || fieldType == 'Email')
        {            
            return '"' + NetSuiteFieldAPIName + '" : ' + '"' + String.valueOf(objSobject.get(SFDCFieldAPIName)) + '"';
        } else {
            return '"' + NetSuiteFieldAPIName + '" : ' + '"' + String.valueOf(objSobject.get(SFDCFieldAPIName)) + '"';
        }
    }
}