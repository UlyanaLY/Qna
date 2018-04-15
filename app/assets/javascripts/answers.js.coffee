$ ->
  $(document).on "click",'.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $(document).on 'ajax:success', 'form.new_answer', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append('<p>'+answer.body+'</p>')
    $('.answer_error').remove()

  $(document).on 'ajax:error', 'form.new_answer', (e, xhr, status, error) ->
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

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log('connected answers')
      questionId = $('div.question').data('id')
      this.perform('follow', { id: questionId })

    ,
    received: (data) ->
      current_user_id = gon.current_user_id
      console.log(current_user_id)
      console.log(data.data.user_id)
      console.log(current_user_id != data.data.user_id)
      if (current_user_id != data.data.user_id)
        if data.data.created
          console.log('JST TEMPLATE')
          $('div.answers').append(JST["templates/answer"](data))
        else
          $('div.answers div:last-child').replaceWith(JST["templates/answer"](data))
  })