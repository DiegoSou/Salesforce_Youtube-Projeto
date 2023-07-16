public without sharing class SelectedChannelService {
    
    public class SelectedChannelServiceExcpt extends APP_UserExceptionType {}

    public String callSaveChannels(List<Object> listObjJson)
    {
        // Id Externo => Registro.
        Map<String, Channel__c> channelByYoutubeId = new Map<String, Channel__c>();
 
        // Preenche um novo Channel com cada valor trago pelo parâmetro.
        for(Object obj : listObjJson)
        {
            if(obj == null || obj == '') { continue; }

            Channel__c tempChannel = (Channel__c) JSON.deserialize((String) obj, Channel__c.class);
            channelByYoutubeId.put(tempChannel.ChannelYtbID__c, tempChannel);
        }

        // Verifica se já existem registros registrados com o mesmo "Id Externo".
        List<Channel__c> existingRecords = YoutubeIntegrationSelector.getChannelsByYtbID(channelByYoutubeId.keySet());
        
        // Associa o Id do registro encontrado ao Id do registro que está para ser inserido.
        for(Channel__c item : existingRecords) {
            channelByYoutubeId.get(item.ChannelYtbID__c).Id = item.Id;
        }

        saveChannels(channelByYoutubeId.values());
        return 'saving';
    }

    public String callUpdateChannel(String recordId)
    {
        System.debug('SelectedChannelService - callUpdateChannel: ' + recordId);

        // Seleciona o objeto com o Id
        Channel__c record = YoutubeIntegrationSelector.getChannelsByID(new Set<Id> { Id.valueOf(recordId) })[0];

        // To-do: comparar campo de ultima atualização, ao invés do campo Salesforce
        if(record.LastModifiedDate.addHours(1) > Datetime.now()) { throw new SelectedChannelServiceExcpt().exception('Wait at least 1 hour to request another update.', false); }
        
        // Pega as estatísticas do canal através da request
        HttpResponse response = YoutubeIntegrationRequest.getResultsListByIds(record.ChannelYtbID__c, 'channels');
        if(response.getStatusCode() != 200) { throw new YoutubeIntegrationRequest.YoutubeIntegrationRequestException('Callout request error. Method: ChannelList, Status Code: ' + response.getStatusCode()); }

        YoutubeIntegrationResultWrapper channelData = YoutubeIntegrationResultWrapper.parse(response.getBody());

        // Atualiza o objeto que foi pego no select
        for(YoutubeIntegrationResultWrapper.Item item : channelData.items)
        {
            ChannelDomain channelDomain = new ChannelDomain().constructChannelFromWrapper(item);

            record.View_Counts__c = channelDomain.channelRecord.View_Counts__c;
            record.Subscriber_Counts__c = channelDomain.channelRecord.Subscriber_Counts__c;
            record.Video_Counts__c = channelDomain.channelRecord.Video_Counts__c;
        }

        saveChannels(new List<Channel__c>{ record });
        return 'Record just start update.';
    }
    
    // DML's
    // upsert nos registros
    private void saveChannels(List<Channel__c> channelList)
    {
        String errorString = '';

        Database.UpsertResult[] results = Database.upsert(channelList, true);

        for(Database.UpsertResult upResult : results)
        {
            if(upResult.isSuccess()) { continue; }

            for(Database.Error error : upResult.getErrors())
            {
                errorString += error.getMessage() + '\n';
            }
        }

        if(errorString != '') { throw new SelectedChannelServiceExcpt().exception(errorString, true); }
    }
}