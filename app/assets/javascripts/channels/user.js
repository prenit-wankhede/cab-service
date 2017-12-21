App.userSubscription = App.cable.subscriptions.create({channel: "UserChannel"}, {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    App.userSubscription.unsubscribe()
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    alert("received data from websocket: " + JSON.stringify(data))
  }
});
