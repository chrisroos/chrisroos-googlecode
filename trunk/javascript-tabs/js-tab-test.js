var Tabs = {
  init : function() {
    this.tabContainers = $('.tabbed-list .container');
    this.tabContainerHeadings = $('.tabbed-list .container .heading');
    this.tabLinks = $('.tabbed-list .contents a');
    var firstContainer = this.tabContainers[0];
    this.defaultContainerToDisplay = ($(firstContainer).attr('id'));
    this.setupContainers();
    this.hideContainerHeadings();
  },
  setupContainers : function() {
    this.tabContainers.each(function() {
      var containerId = $(this).attr('id');
      $(this).attr('id', null);
      $(this).addClass(containerId);
    });
  },
  containerToDisplay : function() {
    var fragment = window.location.hash.replace('#', '');
    var selectedContainer = null;
    this.tabContainers.each(function() {
      if (fragment && $(this).hasClass(fragment)) {
        selectedContainer = fragment;
      }
    })
    if (selectedContainer) { return selectedContainer; };
    return this.defaultContainerToDisplay;
  },
  hideContainerHeadings : function() {
    this.tabContainerHeadings.each(function() {
      $(this).hide();
    })
  },
  displaySelectedContainer : function() {
    var containerToDisplay = this.containerToDisplay();
    this.tabContainers.each(function() {
      if ($(this).hasClass(containerToDisplay)) {
        $(this).show();
      } else {
        $(this).hide();
      }
    })
  }
}

Tabs.init();
Tabs.displaySelectedContainer();

/* I can't get this to work when defined as a function in my 'Tabs' object - I think I'm being naive in my understanding of what 'this' points to.
$('.tabbed-list .contents a').each(function() {
  $(this).click(function() { 
    var tabToDisplay = $(this).attr('href').replace('#', '');
    $('.tabbed-list .container').each(function() {
      if ($(this).hasClass(tabToDisplay)) {
        $(this).show();
      } else {
        $(this).hide();
      }
    })
  })
})
*/