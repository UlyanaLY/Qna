$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log('connected comments')
      questionId = $('div.question').data('id')
      this.perform('follow', {id: questionId})
    ,
    received: (data) ->
      console.log(data['commentable_type'] )
      current_user_id = gon.current_user_id
      if (current_user_id != data['user_id'] || !gon.is_user_signed_in)
        if data['commentable_type'] == 'question'
          questionContainer = $('div.question-container').find('div.comments')
          console.log(questionContainer)
          if data.the_method == 'created'
            questionContainer.append(JST["templates/comment"](data))
          else
            $('div.question-container > div.comments div:last-child').remove()

        else if data['commentable_type'] == 'answer'
          answerId = data.commentable_id
          if data.the_method == 'created'
            answerContainer = $('div.answer-container-'+answerId+'').find('div.comments')
            answerContainer.append(JST["templates/comment"](data))
            console.log('hello!')
          else if data.the_method == 'destroyed'
            console.log($('div.answer-container-'+answerId+'> div.comments div:last-child'))
            $('div.answer-container-'+answerId+'> div.comments div:last-child').remove()
  })