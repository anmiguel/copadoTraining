@isTest
public with sharing class FW_DMLTest {

    /* 20220420-TODO: Complete this tests with negative cases using a profile with FLS restrictions */

    @testSetup
    private static void getAccountList(){
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account();
            acc.Name = 'Test Account '+i;
            acc.AccountNumber = 'InitialLoadForFW_DMLTest';
            acc.Site = 'Site';
            acc.AnnualRevenue = 912555;
            acc.Jigsaw = 'Jigsaw';
            acc.Description = 'Description'; 
            acc.NumberOfEmployees = 999;
            acc.Fax = '697697697'; 
            acc.Industry = 'Agriculture';
            acc.Ownership = 'Public'; 
            acc.Phone = '666666666';
            acc.Rating = 'Hot';
            acc.Sic = 'Sic'; 
            acc.SicDesc = 'SicDesc';
            acc.Type = 'Competitor';
            acc.Website = 'http://www.test.com'; 
            accList.add(acc);
        }

        insert accList;
    }

    @isTest
    public static void insertRecordsOK(){
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        List<Account> accsResult;
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account();
            acc.Name = 'Test Account '+i;
            acc.AccountNumber = 'Account Number';
            acc.Site = 'Site';
            accList.add(acc);
        }
        Test.startTest();
            System.runAs(adminUser){
                accsResult = FW_DML.insertRecords(accList);
            }
        Test.stopTest();
        System.assertEquals(5, accsResult.size(), 'The list has not the correct size');
        for(Account acc: accsResult){
            System.assertNotEquals(null, acc.Id, 'This record has not Id');
        }
    }

    @isTest
    public static void insertRecordsKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account();
            accList.add(acc);
        }

        try{
            Test.startTest();
            System.runAs(adminUser){
                FW_DML.insertRecords(accList);
            }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }

        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void insertRecordOK(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Account accResult;
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.AccountNumber = 'Account Number';
        acc.Site = 'Site';
        
        Test.startTest();
            System.runAs(adminUser){
                accResult = (Account) FW_DML.insertRecords(acc);
            }
        Test.stopTest();
        System.assertNotEquals(null, accResult.Id, 'This record has not Id');
        
    }

    @isTest
    public static void insertRecordKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        Account acc = new Account();

        try{
            Test.startTest();
                System.runAs(adminUser){
                    FW_DML.insertRecords(acc);
                }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }
        
        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void databaseInsertRecordsOK(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        List<Database.SaveResult> accsResult;
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account();
            acc.Name = 'Test Account '+i;
            acc.AccountNumber = 'Account Number';
            acc.Site = 'Site';
            accList.add(acc);
        }
        Test.startTest();
            System.runAs(adminUser){
                accsResult = FW_DML.databaseInsertRecords(accList, false);
            }
        Test.stopTest();
        System.assertEquals(5, accsResult.size(), 'The list has not the correct size');
        for(Database.SaveResult acc: accsResult){
            System.assertNotEquals(null, acc.Id, 'This record has not Id');
        }
    }

    @isTest
    public static void databaseInsertRecordsKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account();
            accList.add(acc);
        }

        try{
            Test.startTest();
            System.runAs(adminUser){
                FW_DML.databaseInsertRecords(accList, true);
            }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }

        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void updateRecordsOK(){
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        List<Account> accsResult;
        List<Account> accList = [SELECT Id, Description FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.Description = 'ModifiedDescription';
        }
        
        Test.startTest();
            System.runAs(adminUser){
                accsResult = FW_DML.updateRecords(accList);
            }
        Test.stopTest();
        System.assertEquals(5, accsResult.size(), 'The list has not the correct size');
        for(Account acc: accsResult){
            System.assertEquals('ModifiedDescription', acc.Description, 'This record has not been updated');
        }
    }

    @isTest
    public static void updateRecordsKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        List<Account> accList = [SELECT Id, Description, BillingGeocodeAccuracy FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.BillingGeocodeAccuracy = 'FakeBillingGeocodeAccuracyValue';
        }

        try{
            Test.startTest();
            System.runAs(adminUser){
                FW_DML.updateRecords(accList);
            }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }

        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void updateRecordOK(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Account accResult;
        Account acc = [SELECT Id, Description FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest' LIMIT 1];

        acc.Description = 'ModifiedDescription';
        
        Test.startTest();
            System.runAs(adminUser){
                accResult = (Account) FW_DML.updateRecords(acc);
            }
        Test.stopTest();
        System.assertNotEquals(null, accResult.Id, 'This record has not Id');
        
    }

    @isTest
    public static void updateRecordKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        Account acc = new Account();

        try{
            Test.startTest();
                System.runAs(adminUser){
                    FW_DML.updateRecords(acc);
                }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }
        
        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void databaseUpdateRecordsOK(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        List<Database.SaveResult> accsResult;
        List<Account> accList = [SELECT Id, Description FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.Description = 'ModifiedDescription';
        }
        
        Test.startTest();
            System.runAs(adminUser){
                accsResult = FW_DML.databaseUpdateRecords(accList, false);
            }
        Test.stopTest();
        System.assertEquals(5, accsResult.size(), 'The list has not the correct size');
        for(Database.SaveResult acc: accsResult){
            System.assertNotEquals(null, acc.Id, 'This record has not Id');
        }
    }

    @isTest
    public static void databaseUpdateRecordsKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        List<Account> accList = [SELECT Id, Description, BillingGeocodeAccuracy FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.BillingGeocodeAccuracy = 'FakeBillingGeocodeAccuracyValue';
        }

        try{
            Test.startTest();
            System.runAs(adminUser){
                FW_DML.databaseUpdateRecords(accList, true);
            }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }

        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void upsertRecordsOK(){
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        List<Account> accsResult;
        List<Account> accList = [SELECT Id, Description FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.Description = 'ModifiedDescription';
        }
        
        Test.startTest();
            System.runAs(adminUser){
                accsResult = FW_DML.upsertRecords(accList);
            }
        Test.stopTest();
        System.assertEquals(5, accsResult.size(), 'The list has not the correct size');
        for(Account acc: accsResult){
            System.assertEquals('ModifiedDescription', acc.Description, 'This record has not been updated');
        }
    }

    @isTest
    public static void upsertRecordsKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        List<Account> accList = [SELECT Id, Description, BillingGeocodeAccuracy FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.BillingGeocodeAccuracy = 'FakeBillingGeocodeAccuracyValue';
        }

        try{
            Test.startTest();
            System.runAs(adminUser){
                FW_DML.upsertRecords(accList);
            }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }

        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void upsertRecordOK(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Account accResult;
        Account acc = [SELECT Id, Description FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest' LIMIT 1];

        acc.Description = 'ModifiedDescription';
        
        Test.startTest();
            System.runAs(adminUser){
                accResult = (Account) FW_DML.upsertRecords(acc);
            }
        Test.stopTest();
        System.assertNotEquals(null, accResult.Id, 'This record has not Id');
        
    }

    @isTest
    public static void upsertRecordKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        Account acc = new Account();

        try{
            Test.startTest();
                System.runAs(adminUser){
                    FW_DML.upsertRecords(acc);
                }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }
        
        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }

    @isTest
    public static void databaseUpsertRecordsOK(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        List<Database.UpsertResult> accsResult;
        List<Account> accList = [SELECT Id, Description FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.Description = 'ModifiedDescription';
        }
        
        Test.startTest();
            System.runAs(adminUser){
                accsResult = FW_DML.databaseUpsertRecords(accList, false);
            }
        Test.stopTest();
        System.assertEquals(5, accsResult.size(), 'The list has not the correct size');
        for(Database.UpsertResult acc: accsResult){
            System.assertNotEquals(null, acc.Id, 'This record has not Id');
        }
    }

    @isTest
    public static void databaseUpsertRecordsKO(){
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' OR Profile.Name = 'Administrador del sistema' LIMIT 1];
        Boolean fwDmlExceptionOccurred = false;
        List<Account> accList = [SELECT Id, Description, BillingGeocodeAccuracy FROM Account WHERE AccountNumber = 'InitialLoadForFW_DMLTest'];

        for(Account acc: accList){
            acc.BillingGeocodeAccuracy = 'FakeBillingGeocodeAccuracyValue';
        }

        try{
            Test.startTest();
            System.runAs(adminUser){
                FW_DML.databaseUpsertRecords(accList, true);
            }
            Test.stopTest();
        } catch (FW_DML.FW_DMLException ex) {
            fwDmlExceptionOccurred = true;
        }

        System.assert(fwDmlExceptionOccurred, 'FW_DMLException has not been thrown');
    }
}