$ ->

  $('.rating a').click (e) ->
    e.preventDefault();
    console.log('point')
    $(this).bind 'ajax:success', (e, data, status, xhr) ->
      console.log('point')
      point = $.parseJSON(xhr.responseText);
      question_id = $(this).data('questionId')
      console.log(point)
      $('#question_rate-id-'+ question_id+ '').html(point)
#    .bind 'ajax:error', (e, xhr, status, error) ->
#    errors = $.parseJSON(xhr.responseText);

  App.cable.subscriptions.create('QuestionChannel', {
    connected: ->
      console.log('connected question')
      this.perform('follow')
    ,
    recieved: ->
      console.log('recieved Question')
  })