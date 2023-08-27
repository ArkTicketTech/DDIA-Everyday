# Chapter 20 Caching

For a cache to be cost-effective, the proportion of requests that can be served directly from it (hit ratio) should be high. The hit ratio depends on several factors, such as the universe of cachable objects (the fewer, the better), the likelihood of accessing the same objects repeatedly (the higher, the better), and the size of the cache (the larger, the better).

## 20.1 Policies
A cache can also have an expiration policy that dictates when an object should be evicted, e.g., a TTL. 

## 20.2 Local cache
The simplest way to implement a cache is to co-locate it with the client.

## 20.3 External cache
An external cache is a service dedicated to caching objects, typically in memory.

# Chapter 21 Microservices
## 21.1 Caveats
### Tech stack
While nothing forbids each microservice to use a different tech stack, doing so makes it more difficult for a developer to move from one team to another.

### Communication
Remote calls are expensive and introduce non-determinism.

### Coupling
Microservices should be loosely coupled so that a change in one service doesn’t require changing others.

### Resource provisioning
To support a large number of independent services, it should be simple to provision new machines, data stores, and other commodity resources
