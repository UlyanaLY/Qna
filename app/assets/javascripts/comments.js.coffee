$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log('connected comments')
      questionId = $('div.question').data('id')
      this.perform('follow', {id: questionId})
    ,
    received: (data) ->
      console.log(data)
      current_user_id = gon.current_user_id
      if (current_user_id != data['user_id'] || !gon.is_user_signed_in)
        if data.the_method == 'created'
          $('div.comments').append(JST["templates/comment"](data))
        else
          $('div.comments div:last-child').remove()
  })