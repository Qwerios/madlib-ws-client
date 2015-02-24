# madlib-ws-client
[![Build Status](https://travis-ci.org/Qwerios/madlib-ws-client.svg?branch=master)](https://travis-ci.org/Qwerios/madlib-ws-client)  [![NPM version](https://badge.fury.io/js/madlib-ws-client.png)](http://badge.fury.io/js/madlib-ws-client) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

[![Npm Downloads](https://nodei.co/npm/madlib-ws-client.png?downloads=true&stars=true)](https://nodei.co/npm/madlib-ws-client.png?downloads=true&stars=true)

Platform agnostic WebSocket client implementation


## philosophy
JavaScript is the language of the web. Wouldn't it be nice if we could stop having to rewrite (most) of our code for all those web connected platforms running on JavaScript? That is what madLib hopes to achieve. The focus of madLib is to have the same old boring stuff ready made for multiple platforms. Write your core application logic once using modules and never worry about the basics stuff again. Basics including XHR, XML, JSON, host mappings, settings, storage, etcetera. The idea is to use the tried and proven frameworks where available and use madlib based modules as the missing link.

Currently madLib is focused on supporting the following platforms:

* Web browsers (IE6+, Chrome, Firefox, Opera)
* Appcelerator/Titanium
* PhoneGap
* NodeJS

The NodeJS implementation uses the ws module:

For Titanium I'm relying on TiWS:


## installation
```bash
$ npm install madlib-ws-client --save
```

## usage
The WebSocket client is a very thin wrapper around the browsers native WebSocket support. This module does not polyfill WebSocket support for older browsers (IE8/9).

I wrote this module to hide which platform needed a WebSocket client. My specific need at the time was to write a client API module that would work with both Node.JS and an Appcelerator App.

To not have to mess around with event emitting and listening differences I decided to rely on callbacks for the websocket events. Below is an example to call the websocket echo server using this module.

```javascript
var WebSocket = require( "madlib-ws-client" );
var client    = new WebSocket( "ws://echo.websocket.org/?encoding=text" );
testString    = "Hello world!";

// Setup callbacks
//
client.onOpen = function()
{
    // Once a connection is established we can send the echo test
    //
    client.send( testString );
};

client.onMessage = function( response )
{
    console.log( "Got echo response", response )
};

// Connect to the echo server
//
client.connect();
```
