public class SelectedChannelAdapter extends APP_AbstractAdapter
{
    // Apelido para o método => classe adapter do método
    public override Map<String, String> configureMethodCatalog()
    {
        return new Map<String, String> {
            'callSaveChannels' => 'SelectedChannelAdapter.CallSaveChannels_ADP'
        };
    }

    // Apelido do método => mapa de parâmetros (nome do parametro => tipo)
    public override Map<String, Object> configureParamsCatalog()
    {
        return new Map<String, Object> {
            'callSaveChannels' => (new Map<String, String> { 'listObjJson' => 'Object' })
        };
    }

    // Classe Adapter para o método e call 
    public class CallSaveChannels_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(Map<String, APP_AbstractAdapter.ParameterMethod> params)
        {
            this.response = new SelectedChannelService().callSaveChannels(
                (List<Object>) params.get('listObjJson').getValue()
            );
        }
    }
}