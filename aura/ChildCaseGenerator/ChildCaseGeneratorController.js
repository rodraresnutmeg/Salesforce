({
	init : function(component, event, helper) {
    // Instantiate Case sObject
    component.set('v.case', {sobjectType: 'Case', ParentId: component.get('v.recordId')});

    helper.getCaseQueues(component, event, helper);
    helper.getTemplates(component, event, helper);
  },

  setData : function(component, event, helper) {
    var template = component.get('v.selectedTemplate');

    if(template == null || template == '' || template == undefined)
      return;

    component.set('v.case.Subject', component.get('v.templateMap')[component.get('v.selectedTemplate')].subject);
    component.set('v.case.Description', component.get('v.templateMap')[component.get('v.selectedTemplate')].description);
  },

  createCase : function(component, event, helper) {
    var action = component.get('c.saveCase');
    action.setParams({c: component.get('v.case'), caseString: component.get('v.caseString')});

    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state == 'SUCCESS') {
        var returned = response.getReturnValue();
        helper.setMessage(component, returned.type, returned.title, returned.message, returned.recordId);
        $A.get('e.force:refreshView').fire();
      } else if(state == 'ERROR') {
        var errors = response.getErrors();
        var error = '';
        for(var i in errors)
          error += '\u2202 ' + errors[i].message + '\r\n';
        
        helper.setMessage(component, 'danger', 'An Error Occurred', error, null);
      }
    });

    $A.enqueueAction(action);
  } 
})