( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "ws"
            require "events"
        )
    else if typeof define is "function" and define.amd
        define( [
            "ws"
            "events"
        ], factory )

)( ( WebSocket, Events ) ->
    class WebsocketClient extends Events.EventEmitter

        constructor: ( @host, @subProtocols = [], @autoJSON = true, @debug = false ) ->
            # NOTE: Only webbrowser websocket implementation supports sub-protocols
            # but I'm keeping the class signature the same for all variants

        connect: () ->
            @socket = socket = new WebSocket( @host )

            # Setup event listeners and callbacks
            # NodeJS implementation is is dual with both event emitter and
            # 3 callback member functions: onError, onOpen and onMessage
            #
            socket.on( "error", ( data ) =>
                console.error( "[MADLIB-SOCKET] error", data ) if @debug

                @emit( "error", data )
                @onError( data ) if typeof @onError is "function"
            )

            socket.on( "open", ( data ) =>
                console.log( "[MADLIB-SOCKET] open", data ) if @debug

                @emit( "open", data )
                @onOpen( data ) if typeof @onOpen is "function"
            )

            socket.on( "message", ( data ) =>
                console.log( "[MADLIB-SOCKET] message", data ) if @debug

                if @autoJSON
                    try
                        message = JSON.parse( data )
                    catch error
                        console.log( "[MADLIB-SOCKET] JSON message parse failed", error ) if @debug
                        message = data

                else
                    message = data

                @emit( "message", message )
                @onMessage( message ) if typeof @onMessage is "function"
            )

        send: ( message ) ->
            message = JSON.stringify( message ) if @autoJSON?
            @socket.send( message )
)