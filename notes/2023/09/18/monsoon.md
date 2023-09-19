### load balancing
### service discovery
### health check
A passive health check is performed by the load balancer as it routes incoming requests to the servers downstream.

## 18.1 DNS load balancing
A simple way to implement a load balancer is with DNS. 

## 18.2 Transport layer load balancing
A more flexible load-balancing solution can be implemented with a load balancer that operates at the TCP level of the network stack (aka L4 load balancer7) through which all the traffic between clients and servers flows.

## 18.3 Application layer load balancing
An application layer load balancer (aka L7 load balancer15) is an HTTP reverse proxy that distributes requests over a pool of servers.

A L7 load balancer can be used as the backend of a L4 load balancer that load-balances requests received from the internet.
