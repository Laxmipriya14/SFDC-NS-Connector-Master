/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NSSyncRequestBatchService {
 
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-21-2024 
    * @param sourceObjfieldList 
    * @param sourceobjectName 
    * @param sourceRecIdList
    * @return List<SObject> 
    **/
    public String getSourceObjQuery(List<String> sourceObjfieldList, String sourceobjectName,List<Id> sourceRecIdList){
      
        String query = '';
        //sourceObjfieldList.add('Sync_to_NS__c');
        if(!sourceObjfieldList.isEmpty() && !sourceRecIdList.isEmpty()){
            query = 'SELECT {0} FROM {1} WHERE {2}';
            query = String.format(query, new List<Object>{String.join(sourceObjfieldList,','),sourceobjectName,' Id In: sourceRecIdList'}); 
        }

        return query;
    }

    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-21-2024 
    * @param sourceobjectName 
    * @return List<String> 
    **/
    public List<String> getSourceObjFields(String sourceobjectName){
        List<String> sourceObjfieldList = new List<String>(); 
        for(Field_Mapping__c fieldMapping : [SELECT id,SFDC_Field_API_Name__c FROM Field_Mapping__c WHERE SObject_Mapping__r.Name =: sourceobjectName]){ // NOPMD // NOPMD
            sourceObjfieldList.add(fieldMapping.SFDC_Field_API_Name__c);
        }
        return sourceObjfieldList;
    }

}