var Tabs = {
  init : function() {
    this.tabContainers = $('.tabbed-list .container');
    this.tabContainerHeadings = $('.tabbed-list .container .heading');
    this.tabLinks = $('.tabbed-list .contents a');
    var firstContainer = this.tabContainers[0];
    this.defaultContainerToDisplay = ($(firstContainer).attr('id'));
    this.setupContainers();
    this.hideContainerHeadings();
    this.setupLinks();
    this.displaySelectedContainer();
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
  displaySelectedContainer : function(container) {
    if (!container) { container = this.containerToDisplay() }
    this.tabContainers.each(function() {
      if ($(this).hasClass(container)) {
        $(this).show();
      } else {
        $(this).hide();
      }
    })
  },
  setupLinks : function() {
    var tabs = this;
    this.tabLinks.each(function() {
      $(this).click(function() { 
        var hash = this.href.split('#')[1];
        tabs.displaySelectedContainer(hash);
      })
    })
  }
}

$(document).ready(function() { Tabs.init() });