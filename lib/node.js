(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory(require("ws"), require("events"));
    } else if (typeof define === "function" && define.amd) {
      return define(["ws", "events"], factory);
    }
  })(function(WebSocket, Events) {
    var WebsocketClient;
    return WebsocketClient = (function(_super) {
      __extends(WebsocketClient, _super);

      function WebsocketClient(host, subProtocols, autoJSON, debug) {
        this.host = host;
        this.subProtocols = subProtocols != null ? subProtocols : [];
        this.autoJSON = autoJSON != null ? autoJSON : true;
        this.debug = debug != null ? debug : false;
      }

      WebsocketClient.prototype.connect = function() {
        var socket,
          _this = this;
        this.socket = socket = new WebSocket(this.host);
        socket.on("error", function(data) {
          if (_this.debug) {
            console.error("[MADLIB-SOCKET] error", data);
          }
          _this.emit("error", data);
          if (typeof _this.onError === "function") {
            return _this.onError(data);
          }
        });
        socket.on("open", function(data) {
          if (_this.debug) {
            console.log("[MADLIB-SOCKET] open", data);
          }
          _this.emit("open", data);
          if (typeof _this.onOpen === "function") {
            return _this.onOpen(data);
          }
        });
        return socket.on("message", function(data) {
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
            return _this.onMessage(message);
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

    })(Events.EventEmitter);
  });

}).call(this);
