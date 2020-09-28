({
  getCaseQueues : function(component, event, helper) {
    var self = this;
    var action = component.get('c.getCaseQueues');
    
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state == 'SUCCESS') {
        var returned = response.getReturnValue();
        component.set('v.queues', returned);
      } else if(state == 'ERROR') {
        var errors = response.getErrors();
        var error = '';

        for(var i in errors)
          error += '\u2202 ' + errors[i].message + '\r\n';

        self.setMessage(component, 'danger', 'An Error Occurred', error, null);
      }
    });
    
    $A.enqueueAction(action);
  },

  getTemplates : function(component, event, helper) {
    var self = this;
    var action = component.get('c.getTemplates');

    action.setParams({caseI : component.get('v.recordId')});
    
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state == 'SUCCESS') {
        var returned = response.getReturnValue();

        if (returned.isSuccess) {
          var values = returned.values;
          component.set('v.templateMap', returned.templateMap);

          var options = new Array();

          for(var i in values)
            options.push({ value: values[i].value, label: values[i].label });

          component.set('v.templates', options);
        } else {
          helper.setMessage(component, returned.type, returned.title, returned.message);
        }
      } else if(state == 'ERROR') {
        var errors = response.getErrors();
        var error = '';

        for(var i in errors)
          error += '\u2202 ' + errors[i].message + '\r\n';

        self.setMessage(component, 'danger', 'An Error Occurred', error, null);
      }
    });
      
    $A.enqueueAction(action);
  },

  setMessage : function(component, type, title, message, recordId) {
    // Display toast message to indicate load status
    var toastEvent = $A.get('e.force:showToast');

    // Set Toast Message Params
    toastEvent.setParams({
      'type': type,
      'title': title,
      'message': message,
      'mode': 'sitcky',
      'messageTemplate': message,
      'messageTemplateData': [
        {
          url: '/' + recordId,
          label: 'here',
        }
      ]
    });

    // Show Toast Message
    toastEvent.fire();
  }
})