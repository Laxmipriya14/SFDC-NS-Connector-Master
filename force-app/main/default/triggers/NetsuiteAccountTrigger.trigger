/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger NetsuiteAccountTrigger on Account (after insert, after update) {
   
 for(Account a : Trigger.New)
 {
        
  /*if( !NSSyncCommanUtility.avoidRecurssion && !System.isFuture() && !System.isBatch()){
                NSSyncCommanUtility.newSyncDataWithNetSuite(trigger.new, 'Account');
        } */
  
   
   TriggerFactory factory = new TriggerFactory();
   TriggerService service = factory.getTriggerServiceInstance('Account');
   factory.execute(service,'Account');
 }
  
}