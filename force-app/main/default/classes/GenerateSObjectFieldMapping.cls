/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class GenerateSObjectFieldMapping {

    /**
    * @description : Insert predefined data in Object Mapping and Field Mapping 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 04-03-2024 
    **/
    @InvocableMethod(label='Create Object Mapping' description='description')
    public static void insertObjectFieldMapping() 
    {
        Map<String,SObject_Mapping__c> objsMap = new Map<String,SObject_Mapping__c>();
        Map<String,SObject_Mapping__c> childObjsMap = new Map<String,SObject_Mapping__c>();
        List<Field_Mapping__c> fieldMapList = new List<Field_Mapping__c>();
        List<Field_Mapping__c> childFieldMapList = new List<Field_Mapping__c>();
        for(Field_Mappings__mdt fieldMdt : [SELECT Id,Label,Field_Type__c,NetSuite_Field_API_Name__c,SFDC_Field_API_Name__c,
                                                   Object_Mapping__r.Id,Object_Mapping__r.Label,Object_Mapping__r.JSON_SObject_Name__c,Object_Mapping__r.Parent_Object_Name__c,Object_Mapping__r.Relationship_Type__c,Object_Mapping__r.Relationship_with_Parent__c 
                                            FROM Field_Mappings__mdt])
        {
            String objName = fieldMdt.Object_Mapping__r.Label;
            String parentObjName = fieldMdt.Object_Mapping__r.Parent_Object_Name__c;
            
            Field_Mapping__c fieldMap = new Field_Mapping__c(Field_Type__c = fieldMdt.Field_Type__c,
                                                             NetSuite_Field_API_Name__c =  fieldMdt.NetSuite_Field_API_Name__c,
                                                             SFDC_Field_API_Name__c =   fieldMdt.Label,
                                                             IsActive__c = true
                                                            );
            SObject_Mapping__c objMappingRef = new SObject_Mapping__c(External_ID__c = fieldMdt.Object_Mapping__r.Id);
            fieldMap.SObject_Mapping__r = objMappingRef;
            
            
            if(String.isNotBlank(parentObjName)){
                childFieldMapList.add(fieldMap);
            }else{
                fieldMapList.add(fieldMap);
            }
            
            if(!objsMap.containsKey(objName))
            {

                SObject_Mapping__c objMapping = new SObject_Mapping__c(External_ID__c = fieldMdt.Object_Mapping__r.Id,
                                                                       Name = fieldMdt.Object_Mapping__r.Label,
                                                                       JSON_SObject_Name__c = fieldMdt.Object_Mapping__r.JSON_SObject_Name__c,
                                                                       IsActive__c = true,
                                                                       Relationship_Type__c = fieldMdt.Object_Mapping__r.Relationship_Type__c,
                                                                       Relationship_with_parent__c = fieldMdt.Object_Mapping__r.Relationship_with_Parent__c
                                                                      );
               
                if(String.isNotBlank(parentObjName)){
                    childObjsMap.put(parentObjName,objMapping);
                    continue;
                }
                objsMap.put(objName,objMapping); 
            }
        }   
        
        if(!objsMap.isEmpty() && !fieldMapList.isEmpty()){
            
            // Insert Sobject mapping records
            insert objsMap.values();
            
            // Insert field mappings
            insert fieldMapList;
        }
        if(!childObjsMap.isEmpty()){
            for(String parentObj : childObjsMap.Keyset()){
                if(objsMap.containsKey(parentObj)){
                     SObject_Mapping__c objMapping = objsMap.get(parentObj);
                     SObject_Mapping__c parentobjMapping = childObjsMap.get(parentObj);
                     parentobjMapping.Parent_SObject_Map__c = objMapping.id;
                }
            }
            insert childObjsMap.values();

            insert childFieldMapList;
        }
    }
}