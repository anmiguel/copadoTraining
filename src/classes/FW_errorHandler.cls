/*-----------------------------------------------------------------------------------------------------------//
* Class Name    : FW_errorHandler
* Project       : PROSEGUR - Framework
* Author        : DGS (PROSEGUR)
* Date          : 04/10/2021
* Description   : Class to save the error.
* @Public 
*               1. insertError.    				calls method to catch the exception
* @Private
*               1. errorSaveDataBase.           Insert in BBDD the error.
*-----------------------------------------------------------------------------------------------------------*/

public class FW_errorHandler {
    
     /*********************************************************************************************************
    * @Method          :   insertError
    * @Author          :   DGS (PROSEGUR)
    * @Created         :   04/10/2021
    * @Description     :   calls method to catch the exception.
    * @params   	   :   Exception. Error to catch.
    * @Returns         :   NA (void method).
    **********************************************************************************************************/
    public static void insertError(Exception e ) {
		errorSaveDataBase(e, false) ;              
    }

    /*********************************************************************************************************
    * @Method          :   errorSaveDataBase
    * @Author          :   DGS (PROSEGUR)
    * @Created         :   04/10/2021
    * @Description     :   calls method to catch the exception.
    * @params   	   :   Exception. Error to catch.
    * 				   :   Boolean. True, access to testing part.   
    * @Returns         :   NA (void method).
    **********************************************************************************************************/
    @TestVisible      
    private static void errorSaveDataBase (Exception except, boolean testing ){
        
        //------------ VARs --------------
        Boolean retCorrectInsert = true;
        String methodName = except.getStackTraceString()?.substringBefore(':')?.substringAfterLast('.');
        String className = except.getStackTraceString()?.substringBefore(':')?.substringBetween('.');
        String appCode = className?.substringBefore('_');

        
        try{
            if(Test.isRunningTest() && testing){
                throw new DMLException('FW_cls_errorHandler_test');
            }                
            insert new FW_logError__c(FW_aplicationCode__c = appCode, FW_errorDate__c = System.now(), FW_errorUser__c = Userinfo.getName(),
                                            FW_class__c = className, FW_method__c = methodName,
                                            FW_errorMessage__c = except.getMessage(), FW_StackTrace__c = except.getStackTraceString());                
            System.debug('Error insertado.');
        }
        catch(Exception e){
            System.debug('Error insertado.');
            insert new FW_logError__c(FW_aplicationCode__c = 'FW', FW_errorDate__c = DateTime.now(), FW_errorUser__c = UserInfo.getName(), 
                                                FW_class__c = e.getStackTraceString().substringBefore(':').substringBetween('.'), FW_method__c = e.getStackTraceString().substringBefore(':').substringAfterLast('.'), 
                                                FW_errorMessage__c = e.getMessage(), FW_StackTrace__c = '');     
        }       
        
    }
    
    
}