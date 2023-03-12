public class VideoDomain 
{
   public Video__c videoRecord{get; set;}

   public VideoDomain constructVideoFromWrapper(YoutubeIntegrationAbstractItem item)
   {
       Video__c video = new Video__c();

       if(item.getSnippet())
       {
           // search result
           System.debug('Video Domain - construct from snippet');
           YoutubeIntegrationSearchWrapper.Item searchItem = (YoutubeIntegrationSearchWrapper.Item) item;

           video.VideoYtbId__c = searchItem.id.get('videoId');
           video.Title__c = searchItem.snippet.title;
           video.Video_URL__c = 'https://youtube.com/video/' + searchItem.id.get('videoId');
           video.Publish_Date__c = searchItem.snippet.publishedAt.format() ;
           video.Description__c = searchItem.snippet.description;
           video.Thumbnail__c = searchItem.snippet.thumbnails.get('default').get('url');
       }

       if(item.getStatictics())
       {
           // result statistics
           System.debug('Video Domain - construct from statistics');
       }

       this.videoRecord = video;

       return this;
   }
}