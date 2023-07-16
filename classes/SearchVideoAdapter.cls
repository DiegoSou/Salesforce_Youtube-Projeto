public class SearchVideoAdapter extends APP_AbstractAdapter
{
    // Apelido para o método => classe adapter do método
    public override Map<String, String> configureMethodCatalog()
    {
        return new Map<String, String> {
            'searchVideos' => 'SearchVideoAdapter.SearchVideos_ADP'
        };
    }

    // Apelido do método => mapa de parâmetros (nome do parâmetro => tipo)
    public override Map<String, Object> configureParamsCatalog()
    {
        return new Map<String, Object> {
            'searchVideos' => (new Map<String, String> { 'searchParam' => 'String', 'channelId' => 'String' })
        };
    }

    // Classe adapter para o método e call
    public class SearchVideos_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String, Object> params)
        {
            adp.setNewResponseToMethod(
                methodName,
                new SearchVideoService().searchVideos(
                    (String) params.get('searchParam'),
                    (String) params.get('channelId')
                )
            );
        }
    }
}