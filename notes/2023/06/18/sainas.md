P131-P136

#### Dataflow Through Services: REST and RPC

*clients* and *servers*

The API exposed by the server is known as a *service*

Server can itself be a client to another service: *microservices architecture*

Services are in some way like databases, but the API are predetermined

**Web services**

HTTP is used as protocol

Not only used on the web

- mobile app (native app, or JS web app using Ajax)
- One service to another service within same organization (*middleware*)
- One service to another service owned by different organization, via internet (public API, OAuth)

REST: not a protocol but a design philosophy 
An API designed according to the principles of REST is called RESTful.

SOAP: use an XML-based language (WSDL)

SOAP's Cons:

- WSDL not human readable
- Too complex and rely on tool support. Difficult to integrate if programming language not supported by SOAP vendor
  Interoperability is not good

RESTful APIs' Pros:

- simpler, less code generation
- A definition format Swagger, to describe RESTful APIs

**RPC (remote procedure calls): Problems**

Make a request just as calling a function "location transparency"

Fundamentally flawed, because

- A local function call is predictable: succeeds or fails
  A network request is unpredictable: lost due to network problem, slowness

  You need to anticipate them, e.g. by retrying

- A local function call return result or throws exception (or infinite loop)
  A network request: return without result, not return due to a timeout
  In this case you don't know what happened to the service

- If network request fails, it could be 

  - Request failed
  - Request got through, just responses are lost. 

  Need to build some mechanism to make the retries *idempotence*

- Local function takes about same time, network latency is unpredictable (network, load of the remote service)

- Local function can use references (pointers). Network must encode/decode

- Different programming language, RPC need to translate datatypes
  Ugly because not all languages have the same type. e.g. a number > 2^53 in JS

**RPC (remote procedure calls): Current directions**

It isn't going away. Many frameworks built on it.

New generation: distinguish remote request from local function
*futures (promises)* to encapsulate asynchronous actions that may fail
*service discovery*: finds the IP & port of a particular service

Customer RPC with binary encoding has better performance
But JSON is easier to debug (e.g. command-line tool `curl`, and a vast ecosystem of tools)

REST is the predominant style. RPC mainly focus is between services within same organization, typically same data center
