trigger NetSuiteProductTrigger on Product2 (after insert, after update,after delete) 
{
    /*if(!NSSyncCommanUtility.avoidRecurssion && Trigger.IsDelete){
    
    NSSyncCommanUtility.newSyncDataWithNetSuite(trigger.new, 'Product2');
    }
    if(!NSSyncCommanUtility.avoidRecurssion){
    if(!NewAvoidRecursion.skipTrigger){
        if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
            NSSyncCommanUtility.newSyncDataWithNetSuite(trigger.new, 'Product2');
                
            }
            
        } 
    }*/
    
   TriggerFactory factory = new TriggerFactory();
   TriggerService service = factory.getTriggerServiceInstance('Product2');
   factory.execute(service,'Product2');
}