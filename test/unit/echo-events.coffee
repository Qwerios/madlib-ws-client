chai         = require "chai"
WebSocket    = require "../../lib/node"

# We'll rely on the timeout to fail the test(s)
#
describe( "WebSocket-events", () ->
    describe( "#echo", () ->
        it( "Test string should be returned", ( done ) ->
            # Create an websocket client
            #
            client     = new WebSocket( "ws://echo.websocket.org/?encoding=text" )
            testString = "Hello world!"

            # Setup event listeners
            #
            client.on( "open", () ->
                client.send( testString )
            )

            client.on( "message", ( response ) ->
                chai.expect( response ).to.eql( testString )
                done()
            )

            # Connect to the echo server
            #
            client.connect()
        )
    )
)