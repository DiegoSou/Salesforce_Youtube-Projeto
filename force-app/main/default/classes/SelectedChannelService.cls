public without sharing class SelectedChannelService {
    
    public class SelectedChannelServiceException extends Exception{}

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
        for(Channel__c item : existingRecords)
        {
            channelByYoutubeId.get(item.ChannelYtbID__c).Id = item.Id;
        }

        try 
        {
            saveChannels(channelByYoutubeId.values());
            return 'success';
        } 
        catch(Exception e)
        {
            System.debug(e.getMessage());
            return e.getMessage();
        }
    }
    
    private void saveChannels(List<Channel__c> channelList)
    {
        String errorString = '';

        Database.UpsertResult[] results = Database.upsert(channelList, true);

        for(Database.UpsertResult ur : results)
        {
            if(ur.isSuccess()) { continue; }

            for(Database.Error error : ur.getErrors())
            {
                errorString += error.getMessage() + '\n';
            }
        }

        if(errorString != '') { throw new SelectedChannelServiceException(errorString); }
    }
}