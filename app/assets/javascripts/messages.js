$(document).on('turbolinks:load', function(){
  function relordPlayStartTime(){
    if(document.URL.match(/messages/)) {
      $.ajax({
        type: 'GET',
        url: 'messages',
        dataType: 'json'
      })

      .done(function (data) {
        const elaspedTime = data.elasped_time
        const timeHtml = elaspedTime ? '再生時間: ' + elaspedTime : '終了しました'

        $('#play_start_time').html(timeHtml);
      })

      .fail(function(){
        alert('再生時間の表示でエラーが発生しました');
      });
    }
  }

  setInterval(relordPlayStartTime, 1000);
});
