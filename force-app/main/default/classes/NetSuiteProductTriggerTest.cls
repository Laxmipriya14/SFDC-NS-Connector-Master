@isTest
public class NetSuiteProductTriggerTest {

    @isTest
    public static void testTriggerLogic() {
        
        NS_Sandboxes__c inst = new NS_Sandboxes__c();
        inst.Name = 'demo sandbox';
        inst.End_Point_URL__c = 'https://td2345/restlet.api';
        insert inst;
        
        Connector_Configurations__c config = new Connector_Configurations__c();
        config.Enable_Sync__c = true;
        config.Netsuite_Instance__c = inst.id;
        insert config;
        
        SObject_Mapping__c sobj = new SObject_Mapping__c();
        sobj.IsActive__c = true;
        sobj.JSON_Sobject_Name__c = 'Item';
        sobj.Name = 'Product2';
        insert sobj;
       
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        Product2 newProduct = new Product2(Name = 'New Product', IsActive = true);
        insert newProduct;
        
        testProduct.IsActive = false;
        update testProduct;
        
        delete testProduct;
    }
}