@isTest
private class NetsuiteAccountTriggerTest {

    @isTest
    static void testTriggerLogic() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Test.startTest();
        Account newAccount = new Account(Name = 'New Test Account');
        insert newAccount;
        Test.stopTest();

    }
}