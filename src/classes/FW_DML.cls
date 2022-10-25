/************************************************************************************************************
* @className    FW_DML
* @project      PROSEGUR - C1ST
* @author       Antonio Benitez
* @date         19/04/2022
* @description  Utility class to manage security in DMLs, managing Field Level Security
*
* @public
*       1. insertRecords. Method to insert a list of records securely
*       2. insertRecords. Method to insert a record securely
*       3. databaseInsertRecords. Method to insert a list of records securely
*       4. updateRecords. Method to update a list of records securely
*       5. updateRecords. Method to update a record securely
*       6. databaseUpdateRecords. Method to update a list of records securely
*       7. upsertRecords. Method to upsert a list of records securely
*       8. upsertRecords. Method to update a record securely
*       9. databaseUpsertRecords. Method to update a list of records securely
*
* @private
*		1. secureInsert
*		2. secureDatabaseInsert
*		3. secureUpdate
*		4. secureDatabaseUpdate
*		5. secureUpsert
*		6. secureDatabasseUpsert
*
************************************************************************************************************/
public with sharing class FW_DML {
    
    /************************************************************************************************************
	* @methodName   insertRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to insert a list of records securely
	* @param		recordsToInsert List<sObject>
	* @return		List<sObject>
	************************************************************************************************************/
	public static List<sObject> insertRecords(List<sObject> recordsToInsert) {
		try{
			return secureInsert(recordsToInsert);
		} catch (Exception ex) {
            FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}

    /************************************************************************************************************
	* @methodName   insertRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to insert a record securely
	* @param		recordToInsert sObject
	* @return		sObject
	************************************************************************************************************/
	public static sObject insertRecords(sObject recordToInsert) {
		try{
			return secureInsert(new List<sObject>{recordToInsert})?.get(0);
		} catch (Exception ex) {
            FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}

	/************************************************************************************************************
	* @methodName   secureInsert
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to insert a list of records securely using DML statement 
	* @param		recordsToInsert List<sObject>
	* @return		List<sObject>
	************************************************************************************************************/
	private static List<sObject> secureInsert(List<sObject> recordsToInsert) {
		SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, recordsToInsert);
		if (securityDecision.getRemovedFields().isEmpty()) {
			insert securityDecision.getRecords();
			return securityDecision.getRecords();
		} else {
			throw new FW_DMLException(('An insert has been prevented due to not having permissions in the following fields: '+securityDecision.getRemovedFields()).left(512));
		}
	}

	/************************************************************************************************************
	* @methodName   databaseInsertRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to insert a list of records securely
	* @param		recordsToInsert List<sObject>
	* @param		allOrNone Boolean. It specifies whether the operation allows partial success
	* @return		List<Database.SaveResult>
	************************************************************************************************************/
	public static List<Database.SaveResult> databaseInsertRecords(List<sObject> recordsToInsert, Boolean allOrNone) {
		try{
			return secureDatabaseInsert(recordsToInsert, allOrNone);
		} catch (Exception ex) {
            FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}

	/************************************************************************************************************
	* @methodName   secureDatabaseInsert
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to insert a list of records securely using Database class 
	* @param		recordsToInsert List<sObject>
	* @param		allOrNone Boolean. It specifies whether the operation allows partial success
	* @return		List<Database.SaveResult>
	************************************************************************************************************/
	private static List<Database.SaveResult> secureDatabaseInsert(List<sObject> recordsToInsert, Boolean allOrNone) {
		SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, recordsToInsert);
		if (securityDecision.getRemovedFields().isEmpty()) {
			return Database.insert(securityDecision.getRecords(), allOrNone);
		} else {
			throw new FW_DMLException(('A Database.insert has been prevented due to not having permissions in the following fields: '+securityDecision.getRemovedFields()).left(512));
		}
	}

    /************************************************************************************************************
	* @methodName   updateRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to update a list of records securely
	* @param		recordsToUpdate List<sObject>
	* @return		List<sObject>
	************************************************************************************************************/
	public static List<sObject> updateRecords(List<sObject> recordsToUpdate) {
		try{
			return secureUpdate(recordsToUpdate);
		} catch (Exception ex) {
			FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}	
	}

    /************************************************************************************************************
	* @methodName   updateRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to update a record securely
	* @param		recordToUpdate sObject
	* @return		ListsObject
	************************************************************************************************************/
	public static sObject updateRecords(sObject recordToUpdate) {
		try{
			return secureUpdate(new List<sObject>{recordToUpdate})?.get(0);
		} catch (Exception ex) {
			FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}	
	}

	/************************************************************************************************************
	* @methodName   secureUpdate
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to update a list of records securely using DML statement 
	* @param		recordsToUpdate List<sObject>
	* @return		List<sObject>
	************************************************************************************************************/
	private static List<sObject> secureUpdate(List<sObject> recordsToUpdate) {
		SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE, recordsToUpdate);
		if (securityDecision.getRemovedFields().isEmpty()) {
			update securityDecision.getRecords();
			return securityDecision.getRecords();
		} else {
			throw new FW_DMLException(('An update has been prevented due to not having permissions in the following fields: '+securityDecision.getRemovedFields()).left(512));
		}
	}

	/************************************************************************************************************
	* @methodName   databaseUpdateRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to update a list of records securely
	* @param		recordsToUpdate List<sObject>
	* @param		allOrNone Boolean. It specifies whether the operation allows partial success
	* @return		List<Database.SaveResult>
	************************************************************************************************************/
	public static List<Database.SaveResult> databaseUpdateRecords(List<sObject> recordsToUpdate, Boolean allOrNone) {
		try{
			return secureDatabaseUpdate(recordsToUpdate, allOrNone);
		} catch (Exception ex) {
            FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}

	/************************************************************************************************************
	* @methodName   secureDatabaseUpdate
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to update a list of records securely using Database class 
	* @param		recordsToUpdate List<sObject>
	* @param		allOrNone Boolean. It specifies whether the operation allows partial success
	* @return		List<Database.SaveResult>
	************************************************************************************************************/
	private static List<Database.SaveResult> secureDatabaseUpdate(List<sObject> recordsToUpdate, Boolean allOrNone) {
		SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, recordsToUpdate);
		if (securityDecision.getRemovedFields().isEmpty()) {
			return Database.update(securityDecision.getRecords(), allOrNone);
		} else {
			throw new FW_DMLException(('A Database.update has been prevented due to not having permissions in the following fields: '+securityDecision.getRemovedFields()).left(512));
		}
	}

    /************************************************************************************************************
	* @methodName   upsertRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to upsert a list of records securely
	* @param		recordsToUpsert List<sObject>
	* @return		List<sObject>
	************************************************************************************************************/
	public static List<sObject> upsertRecords(List<sObject> recordsToUpsert) {
		try{
			return secureUpsert(recordsToUpsert);
		} catch (Exception ex) {
			FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}
	
    /************************************************************************************************************
	* @methodName   upsertRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to update a record securely
	* @param		recordToUpsert sObject
	* @return		ListsObject
	************************************************************************************************************/
	public static sObject upsertRecords(sObject recordToUpsert) {
		try{
			return secureUpsert(new List<sObject>{recordToUpsert})?.get(0);
		} catch (Exception ex) {
			FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}

	/************************************************************************************************************
	* @methodName   secureUpsert
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to upsert a list of records securely using DML statement 
	* @param		recordsToUpsert List<sObject>
	* @return		List<sObject>
	************************************************************************************************************/
	private static List<sObject> secureUpsert(List<sObject> recordsToUpsert) {
		SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPSERTABLE, recordsToUpsert);
		if (securityDecision.getRemovedFields().isEmpty()) {
			upsert securityDecision.getRecords();
			return securityDecision.getRecords();
		} else {
			throw new FW_DMLException(('An upsert has been prevented due to not having permissions in the following fields: '+securityDecision.getRemovedFields()).left(512));
		}
	}

	/************************************************************************************************************
	* @methodName   databaseUpsertRecords
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to upsert a list of records securely
	* @param		recordsToUpsert List<sObject>
	* @param		allOrNone Boolean. It specifies whether the operation allows partial success
	* @return		List<Database.UpsertResult>
	************************************************************************************************************/
	public static List<Database.UpsertResult> databaseUpsertRecords(List<sObject> recordsToUpsert, Boolean allOrNone) {
		try{
			return secureDatabaseUpsert(recordsToUpsert, allOrNone);
		} catch (Exception ex) {
            FW_errorHandler.insertError(ex);
			throw new FW_DMLException(ex.getMessage());
		}
	}

	/************************************************************************************************************
	* @methodName   secureDatabaseUpsert
    * @author		ABD
    * @date         19/04/2022
	* @description  Method to upsert a list of records securely using Database class 
	* @param		recordsToUpsert List<sObject>
	* @param		allOrNone Boolean. It specifies whether the operation allows partial success
	* @return		List<Database.UpsertResult>
	************************************************************************************************************/
	private static List<Database.UpsertResult> secureDatabaseUpsert(List<sObject> recordsToUpsert, Boolean allOrNone) {
		SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, recordsToUpsert);
		if (securityDecision.getRemovedFields().isEmpty()) {
			return Database.upsert(securityDecision.getRecords(), allOrNone);
		} else {
			throw new FW_DMLException(('A Database.upsert has been prevented due to not having permissions in the following fields: '+securityDecision.getRemovedFields()).left(512));
		}
	}

    /************************************************************************************************************
    * @className    FW_DMLException
    * @author       Antonio Benitez
    * @date         19/04/2022
    * @description  FW_DMLException implemntation
	************************************************************************************************************/
    public class FW_DMLException extends Exception {}
}