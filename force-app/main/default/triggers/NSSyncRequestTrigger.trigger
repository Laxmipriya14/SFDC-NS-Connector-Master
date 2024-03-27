/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger NSSyncRequestTrigger on NS_Sync_Request__c (after insert) {
    TriggerFactory factory = new TriggerFactory();
    TriggerService service = factory.getTriggerServiceInstance('NS_Sync_Request__c');
    factory.execute(service,'NS_Sync_Request__c');
}