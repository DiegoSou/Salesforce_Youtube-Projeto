import { LightningElement, track, api } from 'lwc';

export default class VideoSearchTab extends LightningElement 
{
    @api recordId;
    @track videoList;

    get isNotEmpty()
    {
        return Array.isArray(this.videoList) && this.videoList.length > 0;
    }

    searchVideos()
    {
        let searchResultsComp = this.template.querySelector('c-video-search-results');
        let searchParam = this.template.querySelector('input').value;

        if(searchParam.replaceAll(' ', '') != '')
        {
            searchResultsComp.search(this.recordId, searchParam);
        }
    }

    handleSearchResult(event)
    {
        this.videoList = event.detail;
        console.log(JSON.stringify(this.videoList));
    }

    clearSearch()
    {
        let searchParam = this.template.querySelector('input');
        searchParam.value = '';
    }
}
