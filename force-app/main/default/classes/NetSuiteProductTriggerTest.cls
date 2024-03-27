@isTest
private class NetSuiteProductTriggerTest {

    @isTest
    static void testTriggerLogic() {
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        Test.startTest();
        Product2 newProduct = new Product2(Name = 'New Product', IsActive = true);
        insert newProduct;
        Test.stopTest();

        Test.startTest();
        testProduct.IsActive = false;
        update testProduct;
        Test.stopTest();

        Test.startTest();
        delete testProduct;
        Test.stopTest();
    }
}