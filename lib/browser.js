(function() {
  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory();
    } else if (typeof define === "function" && define.amd) {
      return define([], factory);
    }
  })(function(WebSocket, Events) {
    var WebsocketClient;
    return WebsocketClient = (function() {
      function WebsocketClient(host, subProtocols, autoJSON, debug) {
        this.host = host;
        this.subProtocols = subProtocols != null ? subProtocols : [];
        this.autoJSON = autoJSON != null ? autoJSON : true;
        this.debug = debug != null ? debug : false;
      }

      WebsocketClient.prototype.connect = function() {
        var socket,
          _this = this;
        if (WebSocket != null) {
          this.socket = socket = new WebSocket(host, subProtocols);
        } else if (typeof Ti !== "undefined" && Ti !== null) {
          WebSocket = require("net.iamyellow.tiws");
          this.socket = socket = new WebSocket(host);
        } else {
          throw "No websocket support available";
        }
        socket.addEventListener("error", function(data) {
          if (_this.debug) {
            console.error("[MADLIB-SOCKET] error", data);
          }
          if (typeof _this.onError === "function") {
            return _this.onError(data);
          }
        });
        socket.addEventListener("open", function(data) {
          if (_this.debug) {
            console.log("[MADLIB-SOCKET] open", data);
          }
          _this.emit("open", data);
          if (typeof _this.onOpen === "function") {
            return _this.onOpen(data);
          }
        });
        socket.addEventListener("close", function(data) {
          if (_this.debug) {
            console.log("[MADLIB-SOCKET] close", data);
          }
          _this.emit("close", data);
          if (typeof _this.onClose === "function") {
            return _this.onClose(data);
          }
        });
        return socket.addEventListener("message", function(data) {
          var error, message;
          if (_this.debug) {
            console.log("[MADLIB-SOCKET] message", data);
          }
          if (_this.autoJSON) {
            try {
              message = JSON.parse(data);
            } catch (_error) {
              error = _error;
              if (_this.debug) {
                console.log("[MADLIB-SOCKET] JSON message parse failed", error);
              }
              message = data;
            }
          } else {
            message = data;
          }
          _this.emit("message", message);
          if (typeof _this.onMessage === "function") {
            return _this.onMessage(data);
          }
        });
      };

      WebsocketClient.prototype.send = function(message) {
        if (this.autoJSON != null) {
          message = JSON.stringify(message);
        }
        return this.socket.send(message);
      };

      return WebsocketClient;

    })();
  });

}).call(this);
