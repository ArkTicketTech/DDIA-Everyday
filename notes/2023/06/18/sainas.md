P131-P134

#### Dataflow Through Services: REST and RPC

*clients* and servers

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

SOAP: use an XML-based language (WSDL), not human readable, too complex and rely on tool support.
Difficult to integrate if programming language not supported by SOAP vendor
Interoperability is not good
