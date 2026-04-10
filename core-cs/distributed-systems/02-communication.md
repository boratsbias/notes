# Communication

Communication is the mechanism by which processes in a distributed system exchange information. The design of communication protocols and middleware shapes what is easy or hard to build.

## Remote Procedure Call (RPC)

RPC makes a remote function call look like a local one. The caller does not need to know that the callee is on another machine.

**Components:**
- **Stub (proxy):** client-side code that marshals arguments into a message and sends it.
- **Skeleton:** server-side code that unmarshals the message, calls the actual function, and sends the result back.
- **Transport:** the underlying network mechanism (TCP, UDP).

**RPC lifecycle:**

```
Client:   call f(args) -> stub serializes args -> send over network
Server:   receive -> skeleton deserializes -> call f(args) -> serialize result -> send back
Client:   deserialize result -> return to caller
```

**Challenges:** what happens if the network fails? The caller cannot tell whether:
- The request was lost (function was not called).
- The reply was lost (function was called once, result lost).
- The server crashed after calling the function.

**Semantics:**
- **At-most-once:** do not retry; accept possible non-delivery.
- **At-least-once:** retry on timeout; server must be idempotent.
- **Exactly-once:** deduplicate retries; hardest to achieve.

**Modern RPC frameworks:**

| Framework | Language | Serialization | Notes |
|-----------|---------|--------------|-------|
| gRPC | Multi | Protocol Buffers | HTTP/2, streaming |
| Thrift | Multi | Thrift binary | Apache; Facebook origin |
| JSON-RPC | Multi | JSON | Simple; verbose |
| tRPC | TypeScript | TypeScript types | Type-safe |

## gRPC

Google's open-source RPC framework. Uses Protocol Buffers for serialization; HTTP/2 as the transport.

**Advantages:** strongly typed interfaces (`.proto` schema); efficient binary serialization; bidirectional streaming; multiplexed requests over one TCP connection.

**Service definition:**

```proto
service UserService {
  rpc GetUser (GetUserRequest) returns (User);
  rpc ListUsers (ListUsersRequest) returns (stream User);
}

message User {
  string id = 1;
  string name = 2;
  string email = 3;
}
```

## Message Queues and Publish-Subscribe

**Message queue:** a buffer between producer and consumer. Decouples them in time and space. Producer puts messages in the queue; consumer retrieves them.

**Properties:** persistence (messages survive crashes), ordering (FIFO or priority), delivery guarantee (at-least-once, exactly-once), backpressure.

**Publish-Subscribe (pub/sub):** producers publish messages to topics; consumers subscribe to topics; the broker delivers messages to all subscribers. One-to-many communication.

**Apache Kafka:**
- Distributed event streaming platform.
- Topics are divided into partitions (parallelism and ordering unit).
- Messages within a partition are ordered; no ordering guarantee across partitions.
- Retention: messages are stored for a configurable period (days, weeks); consumers can replay.
- Consumer groups: multiple consumers in a group share partitions (each partition assigned to one consumer); scales consumption linearly.
- Replication: each partition has a leader and replicas; producers write to leader; followers replicate.
- Use cases: event sourcing, stream processing, log aggregation, activity tracking.

**RabbitMQ:** traditional message broker. Implements AMQP. Flexible routing (direct, topic, fanout, headers exchanges).

**AWS SQS:** managed queue. Standard (at-least-once, best-effort ordering) or FIFO (exactly-once, ordered).

## HTTP and REST

The dominant application-layer protocol for web services. Stateless; each request carries all necessary information.

**RESTful API conventions:**
- Resources are nouns: `/users`, `/orders/123`.
- HTTP methods express operations: GET (read), POST (create), PUT (replace), PATCH (update), DELETE (remove).
- Status codes indicate outcome.
- Stateless: no server-side session; authentication via tokens in headers.

**Limitations for distributed systems:**
- Request-response only (no server push without workarounds).
- Synchronous (client blocks waiting for response).
- Verbose (HTTP/1.1 headers; mitigated by HTTP/2 and HTTP/3).

## WebSocket

Full-duplex communication over a single TCP connection. Starts with an HTTP upgrade request.

**Use cases:** real-time applications (chat, collaborative editing, live dashboards, games).

**Compared to HTTP polling:** persistent connection; server can push data; lower latency; less overhead.

## Service Mesh

Infrastructure layer that handles communication between microservices without requiring each service to implement it.

**Features:** service discovery, load balancing, TLS mutual authentication, retries, circuit breaking, distributed tracing, traffic shaping (canary deployments, A/B testing).

**Sidecar proxy pattern:** a proxy (Envoy) runs alongside each service and intercepts all network traffic.

**Examples:** Istio (uses Envoy proxies), Linkerd, Consul Connect, AWS App Mesh.

## Serialization

Converting in-memory data structures to bytes for transmission or storage.

**JSON:** human-readable; language-independent; no schema by default; relatively verbose.

**Protocol Buffers (protobuf):** binary; requires `.proto` schema; compact; fast; strongly typed; backward/forward compatible with field numbers.

**Apache Avro:** binary; schema included in the message or in a schema registry; good for Kafka.

**MessagePack:** binary JSON; more compact than JSON; no schema.

**Serialization performance (approximate):** protobuf > MessagePack > JSON for size and speed.

## Backpressure

When a consumer is slower than a producer, the queue grows. Backpressure is the mechanism by which a consumer signals to a producer to slow down.

**TCP flow control:** the receiver's window size limits how fast the sender can transmit.

**Application-level:** explicit demand signals (Reactive Streams, gRPC flow control, Kafka consumer lag monitoring).

Without backpressure, a fast producer will exhaust memory and crash the system.
