public class SearchChannelAdapter extends APP_AbstractAdapter
{
    // Apelido para o método => classe adapter do método
    public override Map<String, String> configureMethodCatalog()
    {
        return new Map<String, String> {
            'searchChannels' => 'SearchChannelAdapter.SearchChannels_ADP'
        };
    }

    // Apelido do método => mapa de parâmetros (nome do parametro => tipo)
    public override Map<String, Object> configureParamsCatalog()
    {
        return new Map<String, Object> {
            'searchChannels' => (new Map<String, String> { 'searchParam' => 'String', 'maxResults' => 'String' })
        };
    }

    // Classe Adapter para o método e call 
    public class SearchChannels_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            adp.setNewResponseToMethod(
                methodName, 
                new SearchChannelService().searchChannels(
                    (String) params.get('searchParam'),
                    (String) params.get('maxResults')
                )
            );
        }
    }
}