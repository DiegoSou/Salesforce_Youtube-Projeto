public virtual class APP_AbstractAdapter 
{
    public class APP_AbstractAdapterException extends Exception {}
    
    // * MÉTODOS 
    // configurações
    public virtual Map<String, String> configureMethodCatalog() { return new Map<String, String>(); } // configura catálogo de nomes
    public virtual Map<String, Object> configureParamsCatalog() { return new Map<String, Object>(); } // configura catálogo de parâmetros

    // catálogo de nomes
    private Map<String, String> methodNameCatalog {get; private set;}
    public Map<String, String> getMethodNameCatalog() { if(methodNameCatalog == null) { setMethodNameCatalog(); } return methodNameCatalog; }
    public void setMethodNameCatalog() { this.methodNameCatalog = this.configureMethodCatalog(); }

    // catálogo de parâmetros
    private Map<String, Object> methodParamsCatalog {get; private set;}
    public Map<String, Object> getMethodParamsCatalog() { if(methodParamsCatalog == null) { setMethodParamsCatalog(); } return methodParamsCatalog; }
    public void setMethodParamsCatalog() { this.methodParamsCatalog = this.configureParamsCatalog(); }

    // catálogo de respostas (preenche ao executar o determinado método)
    private Map<String, Object> methodResponseCatalog = new Map<String, Object>();

    public Object getMethodResponse(String methodName) { if(methodResponseCatalog.get(methodName) == null) { setNewResponseToMethod(methodName, 'non-response'); } return methodResponseCatalog.get(methodName); }
    public void setNewResponseToMethod(String methodName, Object resp) { this.methodResponseCatalog.put(methodName, resp); }

    // * EXECUTE
    public void executeMethod(String methodName, String params)
    {
        try
        {
            // parâmetros que vem do front-end 
            Map<String, Object> paramByName = (Map<String, Object>) JSON.deserializeUntyped(params);

            // verifica método
            if(!getMethodNameCatalog().containsKey(methodName)) { throw new APP_AbstractAdapterException('Método não existe ou não informado: ' + methodName); }
            
            // verifica parâmetros
            for(String paramKey : ((Map<String, String>) getMethodParamsCatalog().get(methodName)).keySet())
                if(!paramByName.containsKey(paramKey)) { throw new APP_AbstractAdapterException('Parâmetro exigido não foi informado: ' + methodName + '(' + paramKey + ')'); }
    
            ((CallerMethod) Type.forName(getMethodNameCatalog().get(methodName)).newInstance()).callMethod(this, methodName, paramByName); 
        } 
        catch (Exception e) 
        {
            System.debug(e.getStackTraceString() + ' | ' + e.getMessage() + ' | Line - ' + e.getLineNumber());
            if(e instanceof APP_UserExceptionType.APP_CustomException) { throw e; }

            throw new APP_UserExceptionType().exception('Ocorreu um erro inesperado, contate um administrador.', true); 
        }
    }

    // * CLASSES
    // classe que chama método da service e define resposta
    public abstract class CallerMethod { public abstract void callMethod(APP_AbstractAdapter adp, String methodName, Map<String, Object> params); }
}