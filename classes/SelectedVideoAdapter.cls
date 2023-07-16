public class SelectedVideoAdapter extends APP_AbstractAdapter
{
    // Apelido para o método => classe adapter do método
    public override Map<String, String> configureMethodCatalog() 
    {
        return new Map<String, String> {
            'callSaveVideos' => 'SelectedVideoAdapter.CallSaveVideos_ADP',
            'getExternalVideoId' => 'SelectedVideoAdapter.CallGetExternalVideoId_ADP'
        };
    }

    // Apelido do método => mapa de parâmetros (nome do parâmetro => tipo)
    public override Map<String, Object> configureParamsCatalog() 
    {
        return new Map<String, Object> {
            'callSaveVideos' => (new Map<String, String>{ 'listObjJson' => 'Object' }),
            'getExternalVideoId' => (new Map<String, String>{ 'recordId' => 'String' })
        };
    }

    public class CallSaveVideos_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            adp.setNewResponseToMethod(
                methodName, 
                new SelectedVideoService().callSaveVideos(
                    (List<Object>) params.get('listObjJson')
                )
            );
        }
    }

    public class CallGetExternalVideoId_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(APP_AbstractAdapter adp, String methodName, Map<String,Object> params) 
        {
            adp.setNewResponseToMethod(
                methodName,
                new SelectedVideoService().callGetExternalVideoId(
                    (String) params.get('recordId')
                )
            );
        }
    }
}