$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create("ApplicationCable::NotificationsChannel", {
    received(data) {
      $('.notification_count').html(parseInt($('.notification_count').text()) + 1)
      $('.notification_count').addClass('has-new-chats')
    }
  })
})