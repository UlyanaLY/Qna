$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.rating a').click (e) ->
    e.preventDefault();
    $(this).bind 'ajax:success', (e, data, status, xhr) ->
      point = $.parseJSON(xhr.responseText);
      answer_id = $(this).data('answerId')
      $('#answer_rate-id-'+ answer_id+ '').html(point)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log('connected llllllll')
      questionId = $('div.question').data('id')
      if(questionId)
        console.log('connected answers')
        this.perform('follow', { id: questionId })
    ,
    received: (data) ->
      current_user_id = gon.current_user_id
      console.log(data)
      if (current_user_id != data['user_id'] || !gon.is_user_signed_in)
        $('div.answers').append(JST["templates/answer"](data))
  })