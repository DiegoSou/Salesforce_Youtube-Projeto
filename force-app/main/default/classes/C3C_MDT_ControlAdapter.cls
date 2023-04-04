public class C3C_MDT_ControlAdapter extends APP_AbstractAdapter
{
    // Apelido para o método => classe adapter do método
    public override Map<String,String> configureMethodCatalog() 
    {
        return new Map<String,String> {
            'getMetadatas' => 'C3C_MDT_ControlAdapter.Metadatas_ADP',
            'getColumns' => 'C3C_MDT_ControlAdapter.Columns_ADP',
            'saveMetadatas' => 'C3C_MDT_ControlAdapter.Save_ADP'
        };
    }

    // Apelido do método => mapa de parâmetros (nome parâmetro => tipo)
    public override Map<String,Object> configureParamsCatalog() 
    {
        return new Map<String, Object> {
            'getMetadatas' => (new Map<String,String> { 'mdtlabel' => 'String' }),
            'getColumns' => (new Map<String,String> { 'mdtlabel' => 'String' }),
            'saveMetadatas' => (new Map<String, String> { 'mdtlabel' => 'String', 'listjson' => 'String' })
        };
    }

    // Classe adapter para o método e call
    public class Metadatas_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            adp.setNewResponseToMethod(
                methodName, 
                new C3C_MDT_ControlService().metadatas((String) params.get('mdtlabel'))
            );
        }
    }

    public class Columns_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            adp.setNewResponseToMethod(
                methodName, 
                new C3C_MDT_ControlService().columns((String) params.get('mdtlabel'))
            );
        }
    }

    // metodo void
    public class Save_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            new C3C_MDT_ControlService().save(
                (String) params.get('mdtlabel'), 
                (String) params.get('listjson')
            );
        }
    }
}