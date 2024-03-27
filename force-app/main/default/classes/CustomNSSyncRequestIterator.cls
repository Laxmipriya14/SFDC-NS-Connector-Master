/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class CustomNSSyncRequestIterator implements Iterator<NS_Sync_Request__c> {
    List<NS_Sync_Request__c> syncRequestList {get;set;}
    Integer currentIndex {get; set;}
    public CustomNSSyncRequestIterator(List<NS_Sync_Request__c> syncRequestList) {
        this.currentIndex = 0;
        this.syncRequestList = syncRequestList;
    }
    public Boolean hasNext() {
        return this.currentIndex < this.syncRequestList.size();
    }
    public NS_Sync_Request__c next() {
        if(this.currentIndex < this.syncRequestList.size()) {
            return this.syncRequestList[this.currentIndex++];
        } else {
            throw new NoSuchElementException('Iterator has no more elements.');
        }
    }
}