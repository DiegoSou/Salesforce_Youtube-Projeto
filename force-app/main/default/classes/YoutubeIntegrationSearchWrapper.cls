public  class YoutubeIntegrationSearchWrapper 
{
    public List<Item> items;

    public class Item extends YoutubeIntegrationAbstractItem
    {
        public String kind;
        public Snippet snippet;
        public Map<String, String> id;

        public override Boolean getStatictics() { return false; }
        public override Boolean getSnippet() { return true; }
    }

    public class Snippet
    {
        public String title;
        public String channelId;
        public String description;
        public Datetime publishedAt;
        public Map<String, Map<String, String>> thumbnails;
    }

    public static YoutubeIntegrationSearchWrapper parse(String jsonResponse)
    {
        YoutubeIntegrationSearchWrapper wrapper = 
        (YoutubeIntegrationSearchWrapper) JSON.deserialize(
            jsonResponse, 
            YoutubeIntegrationSearchWrapper.class
        );

        return wrapper;
    } 
}

// search response
// "items": [
//     {
//       "kind": "youtube#searchResult",    <=   field verification
//       "etag": "Z45cVrqBqV12RSLdwTnDDcKY6zI",
//       "id": {
//         "kind": "youtube#channel",
//         "channelId": "UCrVh3JlhwUbc2AHMSMOdIqw"
//       },
//       "snippet": {
//         "publishedAt": "2021-12-10T02:51:23Z",
//         "channelId": "UCrVh3JlhwUbc2AHMSMOdIqw",    <=   the channel id
//         "title": "C3C Software",
//         "description": "Canal da empresa C3C Software.",
//         "thumbnails": {
//           "default": {
//             "url": "https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s88-c-k-c0xffffffff-no-rj-mo"
//           },
//           "medium": {
//             "url": "https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s240-c-k-c0xffffffff-no-rj-mo"
//           },
//           "high": {
//             "url": "https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s800-c-k-c0xffffffff-no-rj-mo"
//           }
//         },
//         "channelTitle": "C3C Software",
//         "liveBroadcastContent": "none",
//         "publishTime": "2021-12-10T02:51:23Z"
//       }
//     },
// ]


// video response
// "items": [
//     {
//       "kind": "youtube#searchResult",
//       "etag": "JfpmS8S7rzO0PuXGL4i5lxcn3AE",
//       "id": {
//         "kind": "youtube#video",
//         "videoId": "5BYYkCWZbpc"
//       },
//       "snippet": {
//         "publishedAt": "2022-11-25T19:00:07Z",
//         "channelId": "UCbtlMIfdRVxPXZ1nI8NBN2A",
//         "title": "DEFANTE FALA COM O CANARINHO AO VIVO #shorts",
//         "description": "Vídeo completo: https://youtu.be/biMEVjARwrA #brasil #meme #viral #shorts #defante #canarinho #robertinho #coisanossa ...",
//         "thumbnails": {
//           "default": {
//             "url": "https://i.ytimg.com/vi/5BYYkCWZbpc/default.jpg",
//             "width": 120,
//             "height": 90
//           },
//           "medium": {
//             "url": "https://i.ytimg.com/vi/5BYYkCWZbpc/mqdefault.jpg",
//             "width": 320,
//             "height": 180
//           },
//           "high": {
//             "url": "https://i.ytimg.com/vi/5BYYkCWZbpc/hqdefault.jpg",
//             "width": 480,
//             "height": 360
//           }
//         },
//         "channelTitle": "Coisa Nossa",
//         "liveBroadcastContent": "none",
//         "publishTime": "2022-11-25T19:00:07Z"
//       }
//     },
//     {
//       "kind": "youtube#searchResult",
//       "etag": "Hjsb7fFkDSPCS7j8MKrqNvtpriU",
//       "id": {
//         "kind": "youtube#video",
//         "videoId": "Us4q23rxHzs"
//       },
//       "snippet": {
//         "publishedAt": "2023-01-02T15:00:22Z",
//         "channelId": "UCbtlMIfdRVxPXZ1nI8NBN2A",
//         "title": "Passaram trote pro Coisa Nossa (bandindinhos)",
//         "description": "Vídeo completo: https://youtu.be/R6AvpE1MVtw #brasil #memes #viral #shorts #comedia #humor #igorguimaraes #coisanossa ...",
//         "thumbnails": {
//           "default": {
//             "url": "https://i.ytimg.com/vi/Us4q23rxHzs/default.jpg",
//             "width": 120,
//             "height": 90
//           },
//           "medium": {
//             "url": "https://i.ytimg.com/vi/Us4q23rxHzs/mqdefault.jpg",
//             "width": 320,
//             "height": 180
//           },
//           "high": {
//             "url": "https://i.ytimg.com/vi/Us4q23rxHzs/hqdefault.jpg",
//             "width": 480,
//             "height": 360
//           }
//         },
//         "channelTitle": "Coisa Nossa",
//         "liveBroadcastContent": "none",
//         "publishTime": "2023-01-02T15:00:22Z"
//       }
//     },
// ]