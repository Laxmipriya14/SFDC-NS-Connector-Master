/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public abstract class TriggerService implements ITriggerService {
    
    public static Set<String> recurseObjSet = new Set<String>();

    public abstract void beforeInsert();
    public abstract void beforeUpdate();
    public abstract void beforeDelete();
    public abstract void afterInsert();
    public abstract void afterUpdate();
    public abstract void afterDelete();
    public abstract void afterUndelete();
    
    /**
    * @description : Bypass all the triggers for classes running through this trigger pattern if 
                     1. Enable Sync field is unchecked on Conncector Configuration object
                     2. Or code is running recursively
                     3. Object is set inactive in SObject Mapping object
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-23-2024 
    * @return virtual 
    **/
    public virtual boolean bypassTrigger(String objName){
        
        //Instance of singleton class to get Connector Configuration data to check whether sync is enabled or not
        ConnectorConfigurationsClass connectorConfig = ConnectorConfigurationsClass.getInstance();

         //Instance of singleton class to get Sobject mapping data to check object is active or not 
        ConnectorSObjectMappingClass sobjMapConfig = ConnectorSObjectMappingClass.getInstance(objname);
        
        if( (connectorConfig.config != null && !connectorConfig.config?.Enable_Sync__c)  || 
            ( sobjMapConfig.sobjMapping != null && !sobjMapConfig.sobjMapping.IsActive__c) ||
            recurseObjSet.contains(objname)
        ){
            return true;
        }
        recurseObjSet.add(objName);
        
        return false;
    }

}