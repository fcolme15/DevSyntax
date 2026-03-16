// Spring Boot Actuator — health checks, metrics, monitoring endpoints, custom indicators
// Add dependency: spring-boot-starter-actuator


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// builtInEndpoints()
// exposingEndpoints()
// securingEndpoints()
// customHealthIndicator()
// customMetrics()
// infoEndpoint()


// ============================================================
// BUILT-IN ENDPOINTS
// ============================================================

// Actuator auto-exposes HTTP endpoints about your running application
// Base path: /actuator (configurable)

// Most useful endpoints:
// GET /actuator/health     — app status + dependency health (DB, Redis, external services)
// GET /actuator/metrics    — available metric names
// GET /actuator/metrics/{name} — specific metric value (e.g. /actuator/metrics/jvm.memory.used)
// GET /actuator/env        — all resolved config properties and their sources
// GET /actuator/beans      — all registered Spring beans and their dependencies
// GET /actuator/mappings   — all URL mappings and their controller methods
// GET /actuator/loggers    — current log levels per package
// POST /actuator/loggers/{name} — change log level at runtime without restart
// GET /actuator/info       — arbitrary app info (version, build, git commit)

// /actuator/health is what cloud platforms and load balancers ping to check if your app is alive
// Kubernetes liveness/readiness probes, AWS ECS health checks, ELB — all use this endpoint


// ============================================================
// EXPOSING ENDPOINTS
// ============================================================

// By default only /actuator/health is exposed over HTTP
// Must explicitly expose others in application.properties

// --- Expose specific endpoints ---
// management.endpoints.web.exposure.include=health,metrics,info,loggers

// --- Expose all endpoints (not recommended in production) ---
// management.endpoints.web.exposure.include=*

// --- Exclude specific endpoints ---
// management.endpoints.web.exposure.exclude=env,beans

// --- Change base path ---
// management.endpoints.web.base-path=/manage
// Endpoints become: /manage/health, /manage/metrics, etc.

// --- Change port (run actuator on separate port from app — common in production) ---
// management.server.port=8081
// App runs on 8080, actuator on 8081 — 8081 kept internal, never exposed to public

// --- Health endpoint detail level ---
// management.endpoint.health.show-details=always     — show full component breakdown
// management.endpoint.health.show-details=never      — show UP/DOWN only (default)
// management.endpoint.health.show-details=when-authorized — show details only to authenticated users


// ============================================================
// SECURING ENDPOINTS
// ============================================================

// Actuator endpoints should never be publicly accessible in production
// Two common approaches: separate port (firewall-level) or Spring Security rules

// --- Secure via SecurityFilterChain (in 04_Security.java) ---
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(auth -> auth
        .requestMatchers("/actuator/health").permitAll()          //Health check public for load balancer
        .requestMatchers("/actuator/**").hasRole("ADMIN")         //All other actuator endpoints need ADMIN
        .anyRequest().authenticated()
    );
    return http.build();
}

// --- Or run actuator on a separate internal port ---
// management.server.port=8081
// Then firewall/security group blocks 8081 from public internet
// Load balancer health check hits internal port directly


// ============================================================
// CUSTOM HEALTH INDICATOR
// ============================================================

// Implement HealthIndicator to add your own component to the /actuator/health response
// Spring auto-detects any bean implementing HealthIndicator

@Component
public class PaymentServiceHealthIndicator implements HealthIndicator {

    private final PaymentService paymentService;

    public PaymentServiceHealthIndicator(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @Override
    public Health health() {
        try {
            boolean reachable = paymentService.ping();            //Check external dependency
            if (reachable) {
                return Health.up()
                    .withDetail("provider", "Stripe")
                    .withDetail("status", "reachable")
                    .build();
            } else {
                return Health.down()
                    .withDetail("provider", "Stripe")
                    .withDetail("reason", "ping failed")
                    .build();
            }
        } catch (Exception e) {
            return Health.down()
                .withException(e)
                .build();
        }
    }
}

// /actuator/health response with custom indicator (show-details=always):
// {
//   "status": "UP",
//   "components": {
//     "db": { "status": "UP" },
//     "paymentService": { "status": "UP", "details": { "provider": "Stripe", "status": "reachable" } }
//   }
// }

// Overall status is DOWN if any component reports DOWN
// Built-in indicators: db (DataSource), redis, diskSpace, ping
// Custom indicators are named after the class with "HealthIndicator" stripped: PaymentServiceHealthIndicator → paymentService


// ============================================================
// CUSTOM METRICS
// ============================================================

// Micrometer is the metrics library Spring Boot uses under the hood
// Inject MeterRegistry to record custom metrics

@Service
public class OrderService {

    private final MeterRegistry meterRegistry;
    private final Counter orderCounter;

    public OrderService(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        this.orderCounter = Counter.builder("orders.created")     //Metric name
            .description("Total number of orders created")
            .tag("type", "standard")                              //Tags let you filter/group metrics
            .register(meterRegistry);
    }

    public Order placeOrder(OrderRequest request) {
        Order order = orderRepository.save(new Order(request));
        orderCounter.increment();                                 //Record the event
        return order;
    }

    public void recordProcessingTime(long milliseconds) {
        meterRegistry.timer("orders.processing.time")            //Timer metric
            .record(milliseconds, TimeUnit.MILLISECONDS);
    }

    public void trackActiveOrders() {
        meterRegistry.gauge("orders.active",                     //Gauge — current value, not cumulative
            orderRepository.countByStatus(OrderStatus.PROCESSING));
    }
}

// Metric types:
// Counter   — monotonically increasing count (orders placed, errors, logins)
// Timer     — duration measurements (request time, processing time)
// Gauge     — current snapshot value (active connections, queue depth, cache size)
// Summary   — distribution of values (request payload sizes)

// Access via: GET /actuator/metrics/orders.created
// {
//   "name": "orders.created",
//   "measurements": [{ "statistic": "COUNT", "value": 42.0 }]
// }


// ============================================================
// INFO ENDPOINT
// ============================================================

// /actuator/info returns arbitrary metadata about your app
// Useful for confirming which version/build is deployed

// --- Static info in application.properties ---
// info.app.name=Order Service
// info.app.version=1.0.0
// info.app.description=Handles order processing

// --- Auto-populated build info (requires Spring Boot build plugin config) ---
// management.info.build.enabled=true
// Adds: build.version, build.artifact, build.time from your build system

// --- Git commit info (requires git-commit-id plugin) ---
// management.info.git.enabled=true
// management.info.git.mode=full
// Adds: git.branch, git.commit.id, git.commit.time

// /actuator/info response:
// {
//   "app": { "name": "Order Service", "version": "1.0.0" },
//   "build": { "version": "1.0.0", "time": "2026-03-16T10:00:00Z" },
//   "git": { "branch": "main", "commit": { "id": "abc1234" } }
// }