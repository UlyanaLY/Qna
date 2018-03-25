$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    console.log(status);
    $('.answers').append('<p>'+answer.body+'</p>')
    $('.answer_error').remove()

  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);
    $.each errors, (index, value) ->
      $('.answers').append('<p class="answer_error">'+value+'</p>')

  $('.rating a').click (e) ->
    e.preventDefault();
    $(this).bind 'ajax:success', (e, data, status, xhr) ->
      point = $.parseJSON(xhr.responseText);
      answer_id = $(this).data('answerId')
      $('#answer_rate-id-'+ answer_id+ '').html(point)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);


