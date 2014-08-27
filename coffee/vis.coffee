

drawText = (context, canvas, word) ->
  context.clearRect(0, 0, canvas.width, canvas.height)
  context.fillStyle = "#777"
  context.font = "16px Arial"
  context.fillText(word, 100, 100)


# $('#word_input').on 'input', () ->
#   word = $(this).val().toUpperCase()
#   console.log(word)
#   canvas = document.getElementById("normal_canvas")
#   context = canvas.getContext("2d")
#   drawText(context, canvas, word)
#   fcanvas = document.getElementById("flipped_canvas")
#   fcontext = fcanvas.getContext("2d")
#   fcontext.rotate(Math.PI*2/(3*6))
#   drawText(fcontext, fcanvas, word)

flip = (word) ->
  $("#word").text(word)
  $("#fword").text(word)

$ ->

  $("#word_input").focus().select()

  flip("MOM")
  $('#word_input').on 'input', () ->
    word = $(this).val().toUpperCase()
    flip(word)
