// Spring Boot Configuration — application properties, @Value, @ConfigurationProperties,
// profiles, @Conditional, caching, scheduling


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// applicationProperties()
// valueAnnotation()
// configurationProperties()
// profiles()
// conditionalBeans()
// caching()
// scheduling()
// scheduling()


// ============================================================
// APPLICATION PROPERTIES
// ============================================================

// application.properties or application.yml — main config file at src/main/resources/
// Spring Boot auto-reads this file on startup — no setup needed

// --- application.properties syntax ---
// server.port=8081
// spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
// spring.datasource.username=postgres
// spring.datasource.password=secret
// spring.jpa.hibernate.ddl-auto=update
// spring.jpa.show-sql=true

// --- application.yml syntax (equivalent, preferred for nested config) ---
// server:
//   port: 8081
// spring:
//   datasource:
//     url: jdbc:postgresql://localhost:5432/mydb
//     username: postgres
//     password: secret
//   jpa:
//     hibernate:
//       ddl-auto: update
//     show-sql: true

// spring.jpa.hibernate.ddl-auto values:
// none        — do nothing to schema on startup (production default)
// validate    — verify schema matches entities, throw if mismatch
// update      — add missing columns/tables, never drops (dev/staging)
// create      — drop and recreate schema on every startup
// create-drop — create on startup, drop on shutdown (testing)

// Environment variables override application.properties automatically
// SPRING_DATASOURCE_URL overrides spring.datasource.url (dots → underscores, uppercase)


// ============================================================
// @VALUE
// ============================================================

// Inject a single property value directly into a field

@Service
public class EmailService {

    @Value("${app.email.sender}")           //Reads app.email.sender from properties
    private String senderAddress;

    @Value("${app.email.max-retries:3}")    //Falls back to 3 if property not found
    private int maxRetries;

    @Value("${APP_API_KEY}")                //Can also read environment variables directly
    private String apiKey;
}

// @Value works on fields, constructor parameters, and setter parameters
// Throws BeanCreationException at startup if property not found and no default provided
// Not suitable for groups of related properties — use @ConfigurationProperties instead


// ============================================================
// @CONFIGURATIONPROPERTIES
// ============================================================

// Bind an entire group of related properties to a typed class
// Preferred over multiple @Value annotations for structured config

// In application.properties:
// app.payment.api-url=https://api.stripe.com
// app.payment.api-key=sk_live_abc123
// app.payment.timeout-seconds=30
// app.payment.retry-limit=3

@ConfigurationProperties(prefix = "app.payment")
@Component  //Or use @EnableConfigurationProperties(PaymentProperties.class) on a @Configuration class
public class PaymentProperties {
    private String apiUrl;
    private String apiKey;
    private int timeoutSeconds;
    private int retryLimit;

    // Getters and setters required (or use Lombok @Data)
}

// Inject like any other bean
@Service
public class PaymentService {
    private final PaymentProperties props;

    public PaymentService(PaymentProperties props) {
        this.props = props;
    }

    public void charge() {
        String url = props.getApiUrl();
    }
}

// Benefits over @Value:
// — Grouped, typed, and refactorable
// — IDE autocompletion with spring-boot-configuration-processor dependency
// — Supports validation annotations (@NotNull, @Min, etc.) on fields


// ============================================================
// PROFILES
// ============================================================

// Profiles let you define different config per environment (dev, staging, prod)
// Active profile is set via: spring.profiles.active=dev

// --- Profile-specific property files ---
// application-dev.properties   — loaded when profile is "dev"
// application-prod.properties  — loaded when profile is "prod"
// These merge with application.properties; profile-specific values override base values

// --- @Profile on beans — register bean only for specific profile ---
@Service
@Profile("dev")
public class MockEmailService implements EmailService {
    //Used in dev; real EmailService used in prod
}

@Service
@Profile("prod")
public class RealEmailService implements EmailService { }

@Service
@Profile("!prod") //Active on any profile except prod
public class DebugLoggingService { }

// --- Setting active profile ---
// application.properties:     spring.profiles.active=dev
// Environment variable:       SPRING_PROFILES_ACTIVE=prod
// JVM argument:               -Dspring.profiles.active=staging
// Programmatically:
SpringApplication app = new SpringApplication(MyApp.class);
app.setAdditionalProfiles("dev");
app.run(args);

// Multiple profiles active at once: spring.profiles.active=dev,mock-email
// @Profile({"dev", "test"}) — bean active on either profile


// ============================================================
// CONDITIONAL BEANS
// ============================================================

// More granular than @Profile — register beans based on arbitrary conditions
// Covered in 01_CoreContainer; listed here for config context

@Bean
@ConditionalOnProperty(name = "feature.notifications.enabled", havingValue = "true", matchIfMissing = false)
public NotificationService notificationService() { return new NotificationService(); }

// matchIfMissing = true  — create bean if property is absent (treat absence as enabled)
// matchIfMissing = false — don't create bean if property is absent (default)

@Bean
@ConditionalOnMissingBean(DataSource.class) //Only if no DataSource bean already exists
public DataSource defaultDataSource() { return new EmbeddedDatabaseBuilder().build(); }

// Common @Conditional variants:
// @ConditionalOnProperty     — property exists and/or has a specific value
// @ConditionalOnMissingBean  — no bean of that type is already registered
// @ConditionalOnClass        — class is present on the classpath
// @ConditionalOnExpression   — arbitrary SpEL expression is true


// ============================================================
// CACHING
// ============================================================

// Spring's caching abstraction sits in front of method calls
// If the result is already cached, the method body is skipped entirely
// Requires @EnableCaching on a @Configuration class

@SpringBootApplication
@EnableCaching
public class MyApp { }

// Default cache provider is ConcurrentHashMap (in-memory, no TTL)
// For production use Redis or Caffeine (add dependency + configure bean)

// --- @Cacheable — cache the return value on first call, return cached on subsequent calls ---
@Service
public class ProductService {

    @Cacheable("products")                          //Cache name is "products"
    public Product getProduct(Long id) {
        return productRepository.findById(id).orElseThrow(); //Only runs on cache miss
    }

    @Cacheable(value = "products", key = "#id")     //Explicit cache key (default is method params)
    public Product getProductExplicit(Long id) { }

    @Cacheable(value = "products", condition = "#id > 0") //Only cache if condition is true
    public Product getProductConditional(Long id) { }
}

// Cache key is derived from method parameters by default
// Different parameter values = different cache entries
// Same parameter value = cache hit, method body skipped

// --- @CacheEvict — remove entry from cache ---
@CacheEvict(value = "products", key = "#id")        //Remove specific entry
public void updateProduct(Long id, Product product) { }

@CacheEvict(value = "products", allEntries = true)  //Clear entire cache
public void clearProductCache() { }

// --- @CachePut — always run the method AND update the cache ---
@CachePut(value = "products", key = "#product.id")  //Updates cache after every call
public Product saveProduct(Product product) {
    return productRepository.save(product);
}

// @Cacheable vs @CachePut:
// @Cacheable — skip method if cache hit (read optimization)
// @CachePut  — always run method, always update cache (write-through)

// --- Redis cache configuration (production) ---
// Add dependency: spring-boot-starter-data-redis
// application.properties:
// spring.cache.type=redis
// spring.data.redis.host=localhost
// spring.data.redis.port=6379
// spring.cache.redis.time-to-live=600000  — TTL in milliseconds (10 minutes)

// --- Caffeine cache configuration (in-memory with TTL, good for single-instance apps) ---
// Add dependency: com.github.ben-manes.caffeine:caffeine
// spring.cache.type=caffeine
// spring.cache.caffeine.spec=maximumSize=500,expireAfterWrite=10m


// ============================================================
// SCHEDULING
// ============================================================

// Run methods on a timer automatically — no external job scheduler needed
// Requires @EnableScheduling on a @Configuration class

@SpringBootApplication
@EnableScheduling
public class MyApp { }

// --- @Scheduled — marks a method to run on a schedule ---
@Component
public class ScheduledTasks {

    // Fixed rate — runs every N milliseconds regardless of how long the method takes
    @Scheduled(fixedRate = 60000)               //Every 60 seconds
    public void syncInventory() { }

    // Fixed delay — waits N milliseconds AFTER the previous execution finishes
    @Scheduled(fixedDelay = 30000)              //30 seconds after last run completes
    public void processQueue() { }

    // Initial delay — wait before first execution
    @Scheduled(fixedRate = 60000, initialDelay = 10000) //Start after 10s, then every 60s
    public void warmCache() { }

    // Cron expression — precise schedule control
    @Scheduled(cron = "0 0 * * * *")            //Every hour on the hour
    public void generateHourlyReport() { }

    @Scheduled(cron = "0 30 9 * * MON-FRI")     //9:30am every weekday
    public void sendDailyDigest() { }

    @Scheduled(cron = "0 0 0 1 * *")            //Midnight on the 1st of every month
    public void monthlyCleanup() { }
}

// Cron format: second minute hour day-of-month month day-of-week
// *   — every value
// */5 — every 5 units (e.g. every 5 minutes)
// 1-5 — range
// MON,WED,FRI — specific values

// --- Cron with timezone ---
@Scheduled(cron = "0 0 9 * * *", zone = "America/New_York") //9am Eastern
public void morningTask() { }

// --- Externalize schedule to properties (avoid hardcoding) ---
@Scheduled(cron = "${app.tasks.report.cron:0 0 * * * *}") //Default to hourly if not set
public void configuredTask() { }

// @Scheduled methods must return void and take no parameters
// Scheduled tasks run in a single thread by default — long tasks block others
// To run tasks concurrently, configure a TaskScheduler bean:

@Bean
public TaskScheduler taskScheduler() {
    ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
    scheduler.setPoolSize(5);                   //Up to 5 tasks can run concurrently
    scheduler.setThreadNamePrefix("scheduler-");
    return scheduler;
}