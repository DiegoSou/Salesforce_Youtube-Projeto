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
        public override void callMethod(Map<String,APP_AbstractAdapter.ParameterMethod> params) 
        {
            this.response = new C3C_MDT_ControlService().metadatas(
                (String) params.get('mdtlabel').getValue()
            );
        }
    }

    public class Columns_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(Map<String,APP_AbstractAdapter.ParameterMethod> params) 
        {
            this.response = new C3C_MDT_ControlService().columns(
                (String) params.get('mdtlabel').getValue()
            );
        }
    }

    public class Save_ADP extends APP_AbstractAdapter.CallerMethod
    {
        public override void callMethod(Map<String,APP_AbstractAdapter.ParameterMethod> params) 
        {
            new C3C_MDT_ControlService().save(
                (String) params.get('mdtlabel').getValue(),
                (String) params.get('listjson').getValue()
            );

            this.response = 'yup';
        }
    }
}



// public virtual without sharing class C3C_MDT_ControlAdapter extends C3C_APP_ServiceApplicationAdapter
// {
//     public override Map<String,String> getMapServiceMethodToClassMethod() 
//     {
//         return new Map<String, String> {
//             'getMetadatas' => 'C3C_MDT_ControlAdapter.ADP_Metadatas',
//             'getColumns' => 'C3C_MDT_ControlAdapter.ADP_Columns',
//             'saveMetadatas' => 'C3C_MDT_ControlAdapter.ADP_Save'
//         };
//     }

//     public class ADP_Metadatas extends ClassMethod
//     {
//         public override void callMethod()
//         {
//             Map<String, String> mapParams = C3C_APP_ApplicationContext.getBody();

//             C3C_APP_ApplicationContext.setResponse(instanceC3C_MDT_IControlService.metadatas(mapParams.get('mdtlabel')));
//         }
//     }

//     public class ADP_Columns extends ClassMethod
//     {
//         public override void callMethod()
//         {
//             Map<String, String> mapParams = C3C_APP_ApplicationContext.getBody();

//             C3C_APP_ApplicationContext.setResponse(instanceC3C_MDT_IControlService.columns(mapParams.get('mdtlabel')));
//         }
//     }

//     public class ADP_Save extends ClassMethod
//     {
//         public override void callMethod()
//         {
//             Map<String, String> mapParams = C3C_APP_ApplicationContext.getBody();

//             instanceC3C_MDT_IControlService.save(mapParams.get('mdtlabel'), mapParams.get('listjson'));
//         }
//     }

//     // Instancias
//     private static C3C_MDT_IControlService instanceC3C_MDT_IControlService
//     {
//         get 
//         {
//             if(instanceC3C_MDT_IControlService == null)
//                 instanceC3C_MDT_IControlService = (C3C_MDT_IControlService) C3C_DIContainer_Injector.getInstance('C3C_MDT_ControlService');

//             return instanceC3C_MDT_IControlService;
//         }
//         set;
//     }
// }