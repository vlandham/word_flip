

MAPPING = {
  "H" : "H",
  "I" : "I",
  "O" : "O",
  "M" : "W",
  "N" : "N",
  "S" : "S",
  "W" : "M",
  "X" : "X",
  "Z" : "Z",
  " " : " "
}

translate_word = (word) ->
  word_array = word.split('').reverse()
  new_array = word_array.map (d) -> if MAPPING[d] then MAPPING[d] else "*"
  new_array.join("")



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
  translated = translate_word(word)
  if translated.indexOf("*") == -1
    $(lookup_word).html("<a target='_blank' href='https://www.google.com/search?q=#{word}'>lookup #{word}</a>")
    $(lookup_flipped).html("<a target='_blank' href='https://www.google.com/search?q=#{translated}'>lookup #{translated}</a>")
  else
    $(lookup_word).html("")
    $(lookup_flipped).html("")



ready = (error, data, data2, data3) ->
  
  all_data = data.concat(data2)
  # all_data = all_data.concat(data3)
  console.log(all_data)
  ddd = {}
  all_data = all_data.filter (d) -> 
    if ddd[d.original]
      return false
    else
      ddd[d.original] = 1
      return true
  data = all_data.filter (d) -> d.original.length > 1

  data.sort (a,b) -> b.original.length - a.original.length
 
  words = d3.select(".flippable_words").selectAll(".dword")
    .data(data)
  words.enter()
    .append("p")
    .attr("class", "dword")
    .text((d) -> d.original)
    .on "click", (d) ->
       $("#word_input").val(d.original)
       flip(d.original)
       $('html, body').animate({ scrollTop: 0 }, 0);
    # .each((d) -> console.log(d.original))

$ ->

  $("#word_input").focus().select()

  flip("MOM")
  $('#word_input').on 'input', () ->
    word = $(this).val().toUpperCase()
    flip(word)

  queue()
    .defer(d3.csv, "data/flipped_words.csv")
    .defer(d3.csv, "data/flipped_words_word_list.csv")
    # .defer(d3.csv, "data/flipped_words_count_1_2.csv")
    .await(ready)
