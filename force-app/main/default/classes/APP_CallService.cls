public class APP_CallService 
{
    @AuraEnabled
    public static String callService(String className, String methodName, String paramsNameValueJson)
    {
        // get instance Service Class Adapter
        Type classType = Type.forName(className);

        // Casting to call execute
        APP_AbstractAdapter serviceAdapter = ((APP_AbstractAdapter) classType.newInstance());

        // execute method
        serviceAdapter.executeMethod(methodName, paramsNameValueJson);
        
        // get JSON method response
        return JSON.serialize(serviceAdapter.getMethodResponse(methodName));
    }
}