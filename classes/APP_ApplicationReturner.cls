public class APP_ApplicationReturner {

    public static String returnToString(String obj)
    {
        return obj;
    }

    public static Decimal returnToDecimal(String obj)
    {
        return Decimal.valueOf(obj);
    }

    public static Boolean returnToBoolean(String obj)
    {
        return Boolean.valueOf(obj);
    }

    public static Date returnToDate(String obj)
    {
        return Date.valueOf(obj);
    }

    public static Datetime returnToDatetime(String obj)
    {
        return Datetime.valueOf(obj);
    }

    public static Integer returnToInteger(String obj)
    {
        return Integer.valueOf(obj);
    }

    public static Object returnToObject(String obj)
    {
        return JSON.deserializeUntyped(obj);
    }
}