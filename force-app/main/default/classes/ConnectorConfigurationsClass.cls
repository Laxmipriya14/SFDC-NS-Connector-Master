/**
 * @description       : Sigleton pattern class to provide connector configuration details which will be accessed using class property.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ConnectorConfigurationsClass {
    //In singleton pattern instantiation to null is required otherwise singleton doesn't work
    private static ConnectorConfigurationsClass connectorConfig = null;
    public Connector_Configurations__c config;
    private ConnectorConfigurationsClass() {
        getConfigurations();
    }


    /**
    * @description : Singleton pattern to instantiate class and its members
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-23-2024 
    * @return ConnectorConfigurationsClass 
    **/
    public static ConnectorConfigurationsClass getInstance(){
        if(connectorConfig == null){
            connectorConfig = new ConnectorConfigurationsClass();
        }
        return connectorConfig;
    }

    /**
    * @description : Fetch Connector_Configurations__c details which will be used to know which actions are allowed and which are not allowed
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-23-2024 
    **/
    public void getConfigurations(){
        List<Connector_Configurations__c> configList = new List<Connector_Configurations__c>([SELECT id,Enable_Sync__c,JSON_Mapping__c,Netsuite_Instance__c,NS_Requests_Delete_Days__c,Schedule_Delete_Job__c,Schedule__c FROM Connector_Configurations__c order by createddate Asc Limit 1]);
        if(!configList.isEmpty()){
            config = configList.get(0);
        }
       
    }

}