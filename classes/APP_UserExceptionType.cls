public virtual class APP_UserExceptionType
{
    public APP_CustomException exception(String message, Boolean isCritical)
    {
        String className = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));

        Map<String, Object> payload = new Map<String, Object> 
        {
            'message' => message,
            'from' => className,
            'view' => isCritical ? 'error' : 'warning',
            'title' => isCritical ? 'Snag!' : 'Attention'
        };

        return new APP_CustomException(payload);
    }

    public class APP_CustomException extends Exception
    {
        public APP_CustomException(Map<String, Object> exceptionPayload) 
        {
            this(JSON.serialize(exceptionPayload));
        }
    }
}