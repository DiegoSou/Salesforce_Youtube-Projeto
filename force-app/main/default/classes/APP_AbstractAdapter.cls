public abstract class APP_AbstractAdapter 
{
    public class APP_AbstractAdapterException extends Exception {}

    // catálogo de métodos
    private Map<String, String> methodNameCatalog 
    {
        get 
        {
            return this.methodNameCatalog != null ? methodNameCatalog : new Map<String, String>();
        }
        private set;
    }
    private void setMethodCatalog()
    {
        this.methodNameCatalog = this.configureMethodCatalog();
    }

    // catálogo de parâmetros
    private Map<String, Object> methodParamsCatalog
    {
        get
        {
            return this.methodParamsCatalog != null ? methodParamsCatalog : new Map<String, Object>();
        }
        private set;
    }
    private void setParamsCatalog()
    {
        this.methodParamsCatalog = this.configureParamsCatalog();
    }

    // catálogo de respostas
    private Map<String, Object> methodResponseCatalog = new Map<String, Object>();

    private void setNewResponseToMethod(String methodName, Object methodResponse)
    {
        this.methodResponseCatalog.put(methodName, methodResponse);
    }
    public String getMethodResponse(String methodName)
    {
        return this.methodResponseCatalog.get(methodName) != null ? JSON.serialize(this.methodResponseCatalog.get(methodName)) : '';
    }

    // ** MÉTODOS **
    // configura catálogo de métodos
    public abstract Map<String, String> configureMethodCatalog();
    public abstract Map<String, Object> configureParamsCatalog();

    // execute
    public void executeMethod(String methodName, String params)
    {
        this.setMethodCatalog();
        this.setParamsCatalog();

        if(!this.methodNameCatalog.containsKey(methodName)) { throw new APP_AbstractAdapterException('Método não existe ou não informado: ' + methodName); }
        
        // "searchChannels : [{ 'name' : 'channelId', 'type' : 'String', 'value' : '12345' }]"
        // parâmetros definidos na adapter
        Map<String, String> paramsCatalog = (Map<String, String>) methodParamsCatalog.get(methodName);

        // parâmetros que vem do front-end
        List<ParameterMethod> myParams = (List<ParameterMethod>) JSON.deserialize(params, List<APP_AbstractAdapter.ParameterMethod>.class);
        Map<String, ParameterMethod> paramMethodByName = new Map<String, ParameterMethod>();

        for(ParameterMethod param : myParams)
        {
            if(paramsCatalog.get(param.name) == null) { throw new APP_AbstractAdapterException('Parâmetro não existe ou não foi informado: ' + param.name); }
            if(paramsCatalog.get(param.name) != param.type) { throw new APP_AbstractAdapterException('Tipo incorreto do parâmetro: ' + param.type); }

            paramMethodByName.put(param.name, param);
        }

        methodParamsCatalog.put(methodName, paramMethodByName);

        Object appCall = Type.forName(this.methodNameCatalog.get(methodName)).newInstance();
        ((CallerMethod) appCall).callMethod((Map<String, ParameterMethod>) methodParamsCatalog.get(methodName));

        this.setNewResponseToMethod(
            methodName, 
            ((CallerMethod) appCall).response
        ); 
    }

    // ** CLASSES **
    // Contrato de classe para rodar determinado método
    public abstract class CallerMethod
    {
        public abstract void callMethod(Map<String, ParameterMethod> params);
        public Object response;
    }

    public class ParameterMethod
    {
        public String name;
        public String type;
        public String value;

        public Object getValue(){
            switch on type {
                when 'String' 
                {
                    return (Object) APP_ApplicationReturner.returnToString(value);
                }
                when 'Integer'
                {
                    return (Object) APP_ApplicationReturner.returnToInteger(value);    
                }
                when 'Date'
                {
                    return (Object) APP_ApplicationReturner.returnToDate(value);
                }
                when 'Datetime'
                {
                    return (Object) APP_ApplicationReturner.returnToDatetime(value);
                }
                when 'Decimal'
                {
                    return (Object) APP_ApplicationReturner.returnToDecimal(value);
                }
                when 'Boolean'
                {
                    return (Object) APP_ApplicationReturner.returnToBoolean(value);
                }
                when 'Object'
                {
                    return (Object) APP_ApplicationReturner.returnToObject(value);
                }
                when else 
                {
                    throw new APP_AbstractAdapterException('Tipo do parâmetro inválido, verifique a chamada do método');     
                }
            }
        }
    }
}