/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public Interface ITriggerService {
    void beforeInsert();
    void beforeUpdate(); 
    void beforeDelete();
    void afterInsert();
    void afterUpdate();
    void afterDelete();
    void afterUndelete();
}