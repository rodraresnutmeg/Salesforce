({
    refreshView: function(component, event) {
        $A.get('e.force:refreshView').fire();
    },

    refreshCmp: function(component, event) {
        let lwcCmp = component.find('caseDetailCmp');
        lwcCmp.handleRefresh()
            .then((response) => {
              console.log('here', response);
                return response;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
});