import { LightningElement, track, api } from 'lwc';

export default class VideoSearchTab extends LightningElement 
{
    @api recordId;
    @track emptyResults = true;

    // Call search results method from searchResultsCmp
    searchVideos()
    {
        let searchResultsComp = this.template.querySelector('c-video-search-results');
        let searchParam = this.template.querySelector('input').value;

        if(searchParam.replaceAll(' ', '') != '')
        {
            searchResultsComp.search(this.recordId, searchParam);
        }
    }

    // Call save results method from searchResultsCmp
    handleSaveResults()
    {
        this.emptyResults = true;

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
    setIsNotEmpty()
    {
        this.emptyResults = false;
    }
}