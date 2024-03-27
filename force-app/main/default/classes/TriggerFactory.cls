/**
 * @description       : Factory class to provide instace for a classes at runtime.
 *                      The advantage of using this factory pattern is that it delegates the creation of an object to another class and provides a good level of abstraction.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TriggerFactory {

    
    /**
    * @description : Return the instance of the service class based on trigger object
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-29-2024 
    * @param objName 
    * @return TriggerService 
    **/
    public TriggerService getTriggerServiceInstance(String objName){
        system.debug('objName = '+objName);
        String className = '';
        TriggerService service;
        className = getClassName(objName);
        if(String.isNotBlank(className)){
            Type t = Type.forName(className);
            service = (TriggerService)t.newInstance();
        }
        return service;
    }   

    /**
    * @description : Return the class name based on trigger object for which instance needed to be created
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-29-2024 
    * @param objName 
    * @return String 
    **/
    private String getClassName(String objName){
        NSConnectorTriggerConfig__mdt triggerConfig = NSConnectorTriggerConfig__mdt.getInstance(objName.removeEnd('__c'));
        if(triggerConfig!= null && String.isNotBlank(triggerConfig.Class_Name__c)){
            return triggerConfig.Class_Name__c;
        }
        return 'NSTriggerServiceImpl';
    }
    
    /**
    * @description : Executes logic of the trigger object class instance for the current tigger context  
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 02-29-2024 
    * @param service 
    **/
    public void execute(TriggerService service,String objName)
    {
        if(service != null &&  !service?.bypassTrigger(objName)){
            switch on Trigger.operationType {
                when BEFORE_INSERT {
                    service.beforeInsert();
       
                }
                when BEFORE_UPDATE {
                    service.beforeUpdate();
                }
                when BEFORE_DELETE {
                    service.beforeDelete();
                }
                when AFTER_INSERT {
                    service.afterInsert();
                }
                when AFTER_UPDATE{
                    service.afterUpdate();
                }
                when AFTER_DELETE {
                    service.afterDelete();
                }
                when else {
                    service.afterUndelete();
                }
            }
        }
    }
}