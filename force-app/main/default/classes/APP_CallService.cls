public class APP_CallService {
    public class APP_CallServiceException extends Exception{}

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
            throw new APP_CallServiceException(e.getMessage());
        }
    }
}