public class APP_CallService 
{
    @AuraEnabled
    public static String callService(String className, String methodName, String paramsNameTypeValueJson)
    {
        // get instance Service Class Adapter
        Type classType = Type.forName(className);

        // Casting to call execute
        APP_AbstractAdapter serviceAdapter = ((APP_AbstractAdapter) classType.newInstance());

        try
        {
            // execute method
            serviceAdapter.executeMethod(methodName, paramsNameTypeValueJson);
            
            // get JSON method response
            return serviceAdapter.getMethodResponse(methodName);
        }
        catch (Exception e)
        {
            // debug for administrators
            System.debug(e.getMessage());

            // user is allowed to view, the call service component notify the error
            if(e instanceof APP_UserExceptionType.APP_CustomException) { throw  e; }
            
            // the json response is passed as null
            return null;
        }
    }
}