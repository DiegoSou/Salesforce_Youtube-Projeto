import { LightningElement, track, api } from 'lwc';

export default class VideoSearchTab extends LightningElement 
{
    @api recordId;
    @track lastParam;
    @track emptyResults = true;

    // Call search results method from searchResultsCmp
    searchVideos()
    {
        let searchResultsComp = this.template.querySelector('c-video-search-results');
        let searchParam = this.template.querySelector('input').value;

        if(searchParam.replaceAll(' ', '') != '' && searchParam != this.lastParam)
        {
            searchResultsComp.search(this.recordId, searchParam);

            this.lastParam = searchParam;
            this.emptyResults = true;
        }
    }

    // Call save results method from searchResultsCmp
    handleSaveResults()
    {
        let searchResultsComp = this.template.querySelector('c-video-search-results');
        searchResultsComp.save();
    }

    // Clear param
    clearSearch()
    {
        let searchParam = this.template.querySelector('input');
        searchParam.value = '';
    }

    // Handle event if has results on search
    setEmpty(event)
    {
        this.emptyResults = event.detail.isEmpty;
    }
}