_resultBg = $( "<img>" ).attr src: "img/common/balloon.png"
$( ".result" ).css
  "background-image": "url(#{ _resultBg.attr "src" })"
