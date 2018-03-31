$ ->
  $(document).on "click",'.edit-answer-link', (e) ->
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
      questionId = $('div.question').data('id')
      this.perform('follow', { id: questionId })

    ,
    received: (data) ->
      current_user_id = gon.current_user_id
      console.log(current_user_id)
      console.log(data.data.user_id)
      console.log(data.data.is_user_signed_in?)
      if (current_user_id != data['user_id'] || !gon.is_user_signed_in)
        if data.data.created
          $('div.answers').append(JST["templates/answer"](data))
        else
          $('div.answers div:last-child').replaceWith(JST["templates/answer"](data))
  })