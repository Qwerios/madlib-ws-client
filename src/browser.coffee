( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
        )
    else if typeof define is "function" and define.amd
        define( [
        ], factory )

)( ( WebSocket, Events ) ->
    class WebsocketClient

        constructor: ( @host, @subProtocols = [], @autoJSON = true, @debug = false ) ->
            # NOTE: Only webbrowser websocket implementation supports sub-protocols
            # but I'm keeping the class signature the same for all variants

        connect: () ->
            # Check for native websocket support
            #
            if WebSocket?
                # NOTE: Only webbrowser websocket supports sub-protocols
                #
                @socket = socket = new WebSocket( host, subProtocols )

            else if Ti?
                # The TiWS module will need to be installed for this to work in
                # an Appcelatator App
                #
                # Easiest is to use gitTio CLI: http://gitt.io/cli
                #
                # https://github.com/omorandi/tiws
                #
                WebSocket = require( "net.iamyellow.tiws" )
                @socket   = socket = WebSocket.createWS()
                socket.open( host )

            else
                throw "No websocket support available"

            # Setup event listener callbacks
            # There are 3 callback member functions: onError, onOpen and onMessage
            #
            socket.addEventListener( "error", ( data ) =>
                console.error( "[MADLIB-SOCKET] error", data ) if @debug

                @onError( data ) if typeof @onError is "function"
            )

            socket.addEventListener( "open", ( data ) =>
                console.log( "[MADLIB-SOCKET] open", data ) if @debug

                @emit( "open", data )
                @onOpen( data ) if typeof @onOpen is "function"
            )

            socket.addEventListener( "close", ( data ) =>
                console.log( "[MADLIB-SOCKET] close", data ) if @debug

                @emit( "close", data )
                @onClose( data ) if typeof @onClose is "function"
            )

            socket.addEventListener( "message", ( data ) =>
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
                @onMessage( data ) if typeof @onMessage is "function"
            )

        send: ( message ) ->
            message = JSON.stringify( message ) if @autoJSON?
            @socket.send( message )
)
