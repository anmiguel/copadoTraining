/************************************************************************************************************
* @className    FW_DML
* @project      PROSEGUR - C1ST
* @author       Antonio Benitez
* @date         19/04/2022
* @description  Utility class to manage security in DMLs, managing Field Level Security
************************************************************************************************************/

public with sharing class AntonioTest {
    
    public static void benchmarkInsert() {
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<50; i++){
            Account acc = new Account();
            acc.Name = 'Test Account';
            acc.AccountNumber = 'Account Number';
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
        Long dt1 = Datetime.now().getTime();
        accList = FW_DML.insertRecords(accList);
        Long dt2 = Datetime.now().getTime();
        System.debug(dt2-dt1);
        delete accList;
    }


    public static void benchmarkStandardInsert() {
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<50; i++){
            Account acc = new Account();
            acc.Name = 'Test Account';
            acc.AccountNumber = 'Account Number';
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
        Long dt1 = Datetime.now().getTime();
        insert accList;
        Long dt2 = Datetime.now().getTime();
        System.debug(dt2-dt1);
        delete accList;
    }

    public static void benchmark1Insert() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Agriculture';
        acc.Description = 'Account description';    
        
        Long dt1 = Datetime.now().getTime();
        acc = (Account) FW_DML.insertRecords(acc);
        Long dt2 = Datetime.now().getTime();
        System.debug(dt2-dt1);
        delete acc;
    }


    public static void benchmarkStandard1Insert() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Agriculture';
        acc.Description = 'Account description';    
        
        Long dt1 = Datetime.now().getTime();
        insert acc;
        Long dt2 = Datetime.now().getTime();
        System.debug(dt2-dt1);
        delete acc;
    }
    
    
    /************************************************************************************************************
	* @methodName   insertTest
    * @author		ABD
    * @date         19/04/2022
	* @description  testtestest
	************************************************************************************************************/
    public static sObject insertTest() {
        Account acc = new Account();
        acc.Name = 'Antonio';
        return FW_DML.insertRecords(acc);
    }

    /************************************************************************************************************
	* @methodName   insertTest
    * @author		ABD
    * @date         19/04/2022
	* @description  testtestest
	************************************************************************************************************/
    public static void updateTest() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Antonio' WITH SECURITY_ENFORCED LIMIT 1];
        acc.Name = 'Antonio2';
        FW_DML.updateRecords(acc);
    }

    /************************************************************************************************************
	* @methodName   insertTest
    * @author		ABD
    * @date         19/04/2022
	* @description  testtestest
	************************************************************************************************************/
    public static void upsertTest() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Antonio2' WITH SECURITY_ENFORCED LIMIT 1];
        acc.Name = 'Antonio3';
        FW_DML.upsertRecords(acc);
    }
}