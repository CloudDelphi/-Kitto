function kittoInit()
{
  // Not used yet.
  Ext.override(Ext.Panel, {
    hideTbar: function() {
      this.tbar.setVisibilityMode(Ext.Element.DISPLAY);
      if (this.tbar.isVisible())
        this.tbar.fadeOut();
      //this.tbar.hide();
      //this.syncSize();
      //if (this.ownerCt)
      //  this.ownerCt.doLayout();
    },

    showTbar: function() {
      this.tbar.setVisibilityMode(Ext.Element.DISPLAY);
      if (!this.tbar.isVisible())
        this.tbar.fadeIn();
      //this.tbar.show();
      //this.syncSize();
      //if (this.ownerCt)
      //    this.ownerCt.doLayout();
    }
  });

  Ext.override(Ext.Component, {
    getTopOwner: function() {
      var o = this.ownerCt;
      if (!o)
        return this;
      else
        return o.getTopOwner();
    },
    
    getFormPanelOptimalSize: function() {
      var s;
      if (this.items)
      {
        for (var i = 0; i < this.items.getCount(); i++)
        {
          var item = this.items.get(i);
          if (item instanceof Ext.form.FormPanel)
            s = item.getOptimalSize();
          else
            s = item.getFormPanelOptimalSize();
          if (s)
            break;
        }
      }
      return s;
    }
  });

  Ext.override(Ext.form.FormPanel, {
    getOptimalSize: function() {
      var s = new Object;
      s.x = 0;
      s.y = 0;
      for (var i = 0; i < this.items.getCount(); i++)
      {
        var item = this.items.get(i);
        var w = 0;
        var h = 0;
        
        if (item instanceof Ext.Container && item.items && item.initialConfig.layout == "column")
        {
          for (var j = 0; j < item.items.getCount(); j++)
            w += item.items.get(j).getWidth();
          w += 24;
        }
        else
        {
          w = item.getEl().getRight() - this.getEl().getLeft();
        }
        h = item.getEl().getBottom() - this.getEl().getTop();
        if (w > s.x)
          s.x = w;
        if (h > s.y)
          s.y = h;
      }    
      s.y += this.fbar.getEl().getHeight();
      return s;
    }
  });

  Ext.override(Ext.Window, {
    setOptimalSize: function(extraWidth, extraHeight) {
      s = this.getFormPanelOptimalSize();
      if (s)
        // Add space for borders and caption bar.
        // TODO: Calculate them automatically.
        this.setSize(s.x + 50 + extraWidth, s.y + extraHeight);
    }
  });

  // Used by TKExtForceCamelCaps.
  String.prototype.capitalize = function(){
    return this.replace( /(^|\s)([a-z])/g , function(m,p1,p2){ return p1+p2.toUpperCase(); } );
  };

  // Additional form vtypes.
  var
    codice_fiscale_re = /^[a-zA-Z]{6}[0-9]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9]{2}([a-zA-Z]{1}[0-9]{3})[a-zA-Z]{1}$/,
    partita_iva_re = /^[0-9]{11}$/,
    alpha_space_re = /^[a-zA-Z_ ]+$/;
    phone_number_re = /^\+[0-9]+\-[0-9]+$/
  Ext.apply(Ext.form.VTypes, {
    codice_fiscale: function(val, field) {
      return codice_fiscale_re.test(val) || partita_iva_re.test(val);
    },
    codice_fiscaleText: 'Codice Fiscale non formalmente corretto.',
    codice_fiscaleMask: /[a-zA-Z0-9]/i,
    
    alpha_space: function(val, field) {
      return alpha_space_re.test(val);
    },
    alpha_spaceText: 'This field only accepts letters and spaces.',
    alpha_spaceMask: /[a-z ]/i,

    phone_number: function(val, field) {
      return phone_number_re.test(val);
    },
    phone_numberText: 'Invalid phone number.',
    phone_numberMask: /[a-z0-9\-\+]/
  });

  // Additional formats and renderers.
  Ext.apply(Ext.util.Format, {
    checkboxRenderer: function(val) {
      return String.format('<div class="x-grid3-check-col{0}"></div>', val ? "-on" : '');
    }
  });
}