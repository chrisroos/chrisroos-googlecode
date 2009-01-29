// Get the URL fragment without the leading hash (#)
var fragment = window.location.hash.replace('#', '');

// Find the first container and use that as the default 'tab'
var firstContainer = $('.tabbed-list .container:first')[0];
var tabToDisplay = ($(firstContainer).attr('id'));

// Move the container ids to the container class so that we are OK to use the fragments without navigating down the page to the element with the Id
$('.tabbed-list .container').each(function() {
  var containerId = $(this).attr('id');
  $(this).attr('id', null);
  $(this).addClass(containerId);
});

// Determine the container that we should be showing
$('.tabbed-list .container').each(function() {
  if (fragment && $(this).hasClass(fragment)) {
    tabToDisplay = fragment;
  }
})

// Hide the non-selected containers
$('.tabbed-list .container').each(function() {
  if ($(this).hasClass(tabToDisplay)) {
    $(this).show();
  } else {
    $(this).hide();
  }
})

// Hide all the headings
$('.tabbed-list .container .heading').each(function() {
  $(this).hide();
})

// Override the anchor click events to display the selected container
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