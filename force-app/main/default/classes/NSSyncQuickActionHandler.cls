/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 03-21-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class NSSyncQuickActionHandler {
    
    @InvocableMethod(label='Insert NS Sync Request Record' description='Inserts the NS Sync Request when NS Sync quick action is clicked')
    public static List<outputParams> createNSSyncRequest(List<inputParams> lstRecordDetails) {
        List<outputParams> resultList = new List<outputParams>();
        String NetSuiteId = ''; 
        String NSSyncStatus = ''; 
        Boolean NSToggleSync = false;
        outputParams output = new outputParams();
        
        try {
            inputParams record = lstRecordDetails.get(0);
            Id sRecordId = record.recordId;
            Boolean usrSyncConfrm = record.userSyncConfirmation;
            String sObjectType = '';
            if(sRecordId != null){
                sObjectType = String.valueOf(sRecordId.getSObjectType());
            }
            if( String.isNotBlank(sObjectType))
            {
                String 	q =  'SELECT Id,Netsuite_ID__c,Toggle_Sync_to_NS__c,NS_Sync_Error__c        	';
                q += '    FROM ' + sObjectType + '    	';
                q += '    WHERE Id = : sRecordId 	    ';
                List<sObject> sObj = Database.query(q);
                
                if(sObj.size() > 0){
                    SObject modifyRecord = sObj[0];
                    
                    for(sObject obj: sObj) {
                        NetSuiteId = (String)obj.get('Netsuite_ID__c');
                        NSSyncStatus = (String)obj.get('NS_Sync_Error__c');
                        NSToggleSync = (Boolean)obj.get('Toggle_Sync_to_NS__c');
                    }
                    if(String.isBlank(NetSuiteId) || usrSyncConfrm){
                        modifyRecord.put('Toggle_Sync_to_NS__c',!NSToggleSync);
                        update modifyRecord;
                        output.isCreaateSuccess = true;
                    } else{
                        output.isCreaateSuccess = false;
                        output.errorMessage = ('Netsuite Id is aleady present on the record.  Do you want sync again, if Yes click on Continue otherwise close the popup');
                        output.usrResync = true;
                    }
                }
            }
        }catch (Exception e) {
            // Catch any exceptions and handle them
            output.isCreaateSuccess = false;
            output.errorMessage = ('An error occurred: ' + e.getMessage());
        }
        if(output != null){
            resultList.add(output);
        }
        return resultList;
    }
    public class inputParams {
        @InvocableVariable
        public String recordId;
        
        @InvocableVariable
        public Boolean userSyncConfirmation;
        
    }
    
    public class outputParams {
        @InvocableVariable 
        public String errorMessage;
        
        @InvocableVariable 
        public Boolean isCreaateSuccess;
        
        @InvocableVariable 
        public Boolean usrResync;
    }
}