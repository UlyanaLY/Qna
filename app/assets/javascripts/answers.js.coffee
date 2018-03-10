$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()


  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append('<p>'+answer.body+'</p>')
    $('.answer_error').remove()

  .bind 'ajax:error', (e, xhr, status, error) ->
    console.log(xhr.responseText)
    errors = $.parseJSON(xhr.responseText);
    $.each errors, (index, value) ->
      $('.answers').append('<p class="answer_error">'+value+'</p>')



    