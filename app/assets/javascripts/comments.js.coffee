$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log('connected')
  ,
    received: (data) ->
      console.log(data)
  })