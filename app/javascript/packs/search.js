
$(document).on('turbolinks:load', function() {
  var typingTimer;
  var doneTypingInterval = 2000; // wait for 3 seconds after user stops typing

  $('#search-input').on('keyup', function() {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
  });

  $('#search-input').on('keydown', function() {
    clearTimeout(typingTimer);
  });

  function doneTyping() {
    var query = $('#search-input').val();
    var authenticityToken = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      type: 'POST',
      url: '/searches',
      data: { query: query },
      headers: { 'X-CSRF-Token': authenticityToken },
      success: function(response) {
        console.log(response);
        // Make an additional AJAX request to the analytics action
        $.ajax({
          type: 'GET',
          url: '/articles/analytics',
          success: function(response) {
            // Update the search chart with the new data
            var searchChart = new Chart($('#search-chart'), {
              type: 'line',
              data: {
                labels: Object.keys(response.search_data),
                datasets: [{
                  label: 'Searches per Day',
                  data: Object.values(response.search_data),
                  backgroundColor: 'rgba(0, 123, 255, 0.1)',
                  borderColor: 'rgba(0, 123, 255, 1)',
                  borderWidth: 1
                }]
              }
            });

            // Update the most searched terms table with the new data
            var mostSearchedTableBody = $('#most-searched-terms tbody');
            mostSearchedTableBody.empty();
            $.each(response.user_search_data, function(query, count) {
              var row = $('<tr>').appendTo(mostSearchedTableBody);
              $('<td>').text(query).appendTo(row);
              $('<td>').text(count).appendTo(row);
            });
          },
          error: function(xhr) {
            console.log(xhr.responseText);
          }
        });
      },
      error: function(xhr) {
        console.log(xhr.responseText);
      }
    });
  }

  $('#search-form').on('submit', function(e) {
    e.preventDefault();
    var query = $('#search-input').val();
    var searchButton = $('#search-submit');
    var originalButtonText = searchButton.val();
    
    // Change the button text to "Searching..."
    searchButton.val("Searching...");
    searchButton.prop('disabled', true);

    $.get('/search', { query: query }, function(data) {
      $('#search-results').html(data);

      // Revert the button text to the original value
      searchButton.val(originalButtonText);
      searchButton.prop('disabled', false);
    });
  });
});
