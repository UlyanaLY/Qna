$ ->
  $('.rating a').click (e) ->
    e.preventDefault();
    $(this).bind 'ajax:success', (e, data, status, xhr) ->
      point = $.parseJSON(xhr.responseText);
      question_id = $(this).data('questionId')
      $('#question_rate-id-'+ question_id+ '').html(point)
    .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);

