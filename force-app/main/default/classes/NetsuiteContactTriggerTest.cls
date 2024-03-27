@isTest
private class NetsuiteContactTriggerTest {

    @isTest
    static void testTriggerLogic() {
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;

        Test.startTest();
        Contact newContact = new Contact(FirstName = 'New', LastName = 'Contact');
        insert newContact;
        Test.stopTest();

    }
}