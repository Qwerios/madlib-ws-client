chai         = require "chai"
WebSocket    = require "../../lib/node"

# We'll rely on the timeout to fail the test(s)
#
describe( "WebSocket-callbacks", () ->
    describe( "#echo", () ->
        it( "Test string should be returned", ( done ) ->
            # Create an websocket client
            #
            client     = new WebSocket( "ws://echo.websocket.org/?encoding=text" )
            testString = "Hello world!"

            # Setup callbacks
            #
            client.onOpen = () ->
                client.send( testString )

            client.onMessage = ( response ) ->
                chai.expect( response ).to.eql( testString )
                done()

            # Connect to the echo server
            #
            client.connect()
        )
    )
)