public without sharing class SelectedVideoService 
{
    public class SelectedVideoServiceExcpt extends APP_UserExceptionType {}

    public String callSaveVideos(List<Object> listObjJson)
    {
        // Id Externo => Registro.
        Map<String, Video__c> videoByYoutubeId = new Map<String, Video__c>();

        // Preenche um novo video com cada valor trago pelo parâmetro
        for(Object obj : listObjJson)
        {
            if(obj == null || obj == '') { continue; }

            Video__c tempVideo = (Video__c) JSON.deserialize((String) obj, Video__c.class);
            videoByYoutubeId.put(tempVideo.VideoYtbId__c, tempVideo);

            System.debug(tempVideo.Channel__c);
        }

        // Verifica se já existem registros registrados com o mesmo "Id Externo"
        List<Video__c> existingRecords = YoutubeIntegrationSelector.getVideosByYtbID(videoByYoutubeId.keySet());

        // Associa o Id do registro encontrado com o Id do registro que está para ser inserido.
        for(Video__c item : existingRecords) {
            videoByYoutubeId.get(item.VideoYtbId__c).Id = item.Id;
        }

        saveVideos(videoByYoutubeId.values());
        return 'saving';
    }

    public String callGetExternalVideoId(String recordId) 
    {
        Set<Id> ids = new Set<Id> { Id.valueOf(recordId) };

        return YoutubeIntegrationSelector.getVideosByID(ids)[0].VideoYtbId__c;
    }

    // DML's
    // upsert nos registros
    private void saveVideos(List<Video__c> videoList)
    {
        String errorString = '';

        Database.UpsertResult[] results = Database.upsert(videoList, true);

        for(Database.UpsertResult upResult : results)
        {
            if(upResult.isSuccess()) { continue; }

            for(Database.Error error : upResult.getErrors())
            {
                errorString += error.getMessage() + '\n';
            }
        }

        if(errorString != '') { throw new SelectedVideoServiceExcpt().exception(errorString, true); }
    }
}