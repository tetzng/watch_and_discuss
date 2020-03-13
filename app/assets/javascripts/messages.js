window.addEventListener('turbolinks:load',function(){
  const path = location.pathname ;
  const interval = 60000;

  if ( path.match(/message/)) {
    setInterval('location.reload()',interval);
  }
});
