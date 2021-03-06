blackoutPage = ->
  # Create a blank canvas over the page
  divId = "fcc-net-neutrality-blackout"
  headline = "What if because this website didn't pay as much as a major corporation, you couldn't see it?"
  body = "That's what could happen if the FCC doesn't stand up to cable companies and doesn't enshrine Net Neutrality in law."
  internetUtility = "In 2014, the internet is no less important than electricty or your phone.<br/><br/>Tell the FCC.<br/><br/><span id='fcc-superstrong'>Tell them that it's time to classify ISPs as Common Carriers.</span>"
  contact = ""
  social = ""
  socialId = "fccblackout-social"
  html = "<div id='#{divId}'><div id='#{divId}-child'><h1>#{headline}</h1><h2>#{body}</h2><h3>#{internetUtility}</h3><div id='#{socialId}'>#{social}</div></div></div>"
  $("body").prepend(html)
  $("##{divId}").css("height",$(document).height())
  .css("width",$(window).width())
  .css("position","fixed")
  .css("background","#000")
  .css("color","#fff")
  .css("z-index","9999")
  $("##{divId}-child").css("padding","2rem")
  .css("text-align","center")
  $("#fcc-superstrong").css("font-weight","700")
  .css("text-decoration","underline")
  .css("display","block")
  $("##{divId} h3").css("margin","2em")

$ ->
  now = new Date()
  start = new Date(2014,5,15)
  end = new Date(2014,5,16)
  if start < now < end then blackoutPage()



isBool = (str) -> str is true or str is false

isEmpty = (str) -> not str or str.length is 0

isBlank = (str) -> not str or /^\s*$/.test(str)

isNull = (str) ->
  try
    if isEmpty(str) or isBlank(str) or not str?
      unless str is false or str is 0 then return true
  catch
  false

isJson = (str) ->
  if typeof str is 'object' then return true
  try
    JSON.parse(str)
    return true
  catch
  false

isNumber = (n) -> not isNaN(parseFloat(n)) and isFinite(n)

toFloat = (str) ->
  if not isNumber(str) or isNull(str) then return 0
  parseFloat(str)

toInt = (str) ->
  if not isNumber(str) or isNull(str) then return 0
  parseInt(str)

`function toObject(arr) {
    var rv = {};
    for (var i = 0; i < arr.length; ++i)
        if (arr[i] !== undefined) rv[i] = arr[i];
    return rv;
}`

String::toBool = -> this.toString() is 'true'

Boolean::toBool = -> this.toString() is 'true' # In case lazily tested

Object.size = (obj) ->
  size = 0
  size++ for key of obj when obj.hasOwnProperty(key)
  size

delay = (ms,f) -> setTimeout(f,ms)

roundNumber = (number,digits = 0) ->
  multiple = 10 ** digits
  Math.round(number * multiple) / multiple

jQuery.fn.exists = -> jQuery(this).length > 0

byteCount = (s) => encodeURI(s).split(/%..|./).length - 1

`function shuffle(o) { //v1.0
    for (var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}`
debounce: (func, threshold, execAsap) ->
  # Borrowed from http://coffeescriptcookbook.com/chapters/functions/debounce
  # Only run the prototyped function once per interval.
  (args...) ->
    obj = this
    delayed = ->
      func.apply(obj, args) unless execAsap
    if timeout?
      clearTimeout(timeout)
    else if (execAsap)
      func.apply(obj, args)
    timeout = setTimeout(delayed, threshold or 100)