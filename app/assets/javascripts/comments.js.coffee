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
        if data['commentable_type'] == 'question'
          questionContainer = $('div.question-container').find('div.comments')
          console.log(data.the_method)
          if data.the_method == 'created'
            questionContainer.append(JST["templates/comment"](data))
            $('#comment_body').val('')
            $('.notice').html('Comment was successfully created.')

            console.log(data.the_method)
          else
            console.log(data.the_method)
            commentId = data.comment_id
            commentableId = data.commentable_id
            $( "#comment-id-#{commentableId}-#{commentId}").remove()
            $('.notice').html('Comment was successfully deleted.')
          $(".notice").addClass( "alert fade in alert-success ")

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