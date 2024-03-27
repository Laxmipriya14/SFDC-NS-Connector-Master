/**
 * @description       : igleton pattern class to provide Sobject mapping configured for connector app with details which will be accessed using class property.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ConnectorSObjectMappingClass {
    private static ConnectorSObjectMappingClass sobjMappingConfig = null;
    public SObject_Mapping__c sobjMapping;
    private ConnectorSObjectMappingClass(String objname) {
        getSObjectMapping(objname);
    }
    

    /**
    * @description : Singleton pattern to instantiate class and its members
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-06-2024 
    * @param objname 
    * @return ConnectorSObjectMappingClass 
    **/
    public static ConnectorSObjectMappingClass getInstance(String objname){
        if(sobjMappingConfig == null){
            sobjMappingConfig = new ConnectorSObjectMappingClass(objname);
        }
        return sobjMappingConfig;
    }

   
    /**
    * @description : Fetch SObject_Mapping__c details which will be used to know whether trigger should run for object or not to create NS Sync Request // NOPMD
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-06-2024 
    * @param objname 
    **/
    public void getSObjectMapping(String objname){
        sobjMapping = [SELECT id,IsActive__c FROM SObject_Mapping__c WHERE Name=:objname order by createddate Asc Limit 1];
    }
}