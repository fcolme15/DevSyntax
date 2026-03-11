// Spring Boot Core Container — IoC, DI, Bean lifecycle, component scanning

// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// stereotypeAnnotations()
// beanDeclaration()
// dependencyInjection()
// qualifierAndPrimary()
// scopeAndLifecycle()
// conditionalBeans()
// springApplicationAndContext()


// ============================================================
// STEREOTYPE ANNOTATIONS
// ============================================================

// All four register a class as a Spring-managed bean via component scan
// Semantic distinction helps readability and AOP pointcut targeting

@Component      //Generic managed component, catch-all
@Service        //Business logic layer
@Repository     //Data access layer; also translates SQL exceptions to Spring DataAccessException
@RestController //Web layer; covered in 02_WebMVC

@Service
public class OrderService { }

@Repository
public class OrderRepository { }


// ============================================================
// BEAN DECLARATION
// ============================================================

// @Bean is used inside @Configuration classes to declare beans explicitly
// Use when you don't own the class (third-party libraries) or need manual construction logic

@Configuration
public class AppConfig {

    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        return mapper;
    }
}

// Method name becomes the bean name by default: objectMapper()
@Bean(name = "customName") //Overrides default bean name


// ============================================================
// DEPENDENCY INJECTION
// ============================================================

// --- Constructor injection (preferred) ---
// Spring Boot auto-injects if there is exactly one constructor — no @Autowired needed

@Service
public class OrderService {
    private final PaymentService paymentService;

    public OrderService(PaymentService paymentService) { //No @Autowired needed with single constructor
        this.paymentService = paymentService;
    }
}

// --- Field injection (convenient but harder to unit test) ---
@Autowired
private PaymentService paymentService;

// --- Setter injection (use when dependency is optional) ---
@Autowired(required = false)
public void setPaymentService(PaymentService paymentService) { }

// Constructor injection preferred: fields can be final, dependencies explicit, no Spring context needed in tests


// ============================================================
// @QUALIFIER AND @PRIMARY
// ============================================================

// When multiple beans of the same type exist, Spring can't choose automatically

// @Primary — marks one bean as the default when type is ambiguous
@Bean
@Primary
public NotificationService emailNotificationService() { return new EmailService(); }

@Bean
public NotificationService smsNotificationService() { return new SmsService(); }

// @Qualifier — explicitly names which bean to inject at the injection site
@Autowired
@Qualifier("smsNotificationService") //Value matches bean name (method name or @Bean(name="..."))
private NotificationService notificationService;


// ============================================================
// SCOPE AND LIFECYCLE
// ============================================================

// --- Bean scopes ---
@Scope("singleton")  //Default; one instance per ApplicationContext
@Scope("prototype")  //New instance every time the bean is requested
@Scope("request")    //One instance per HTTP request (web apps only)
@Scope("session")    //One instance per HTTP session (web apps only)

@Service
@Scope("prototype")
public class ReportBuilder { }

// --- Lifecycle hooks ---
// @PostConstruct and @PreDestroy are from jakarta.annotation, not Spring

@PostConstruct
public void init() {
    //Runs after bean is created and all dependencies are injected
}

@PreDestroy
public void cleanup() {
    //Runs before bean is destroyed — NOT called for prototype-scoped beans
}

// Equivalent for @Bean methods:
@Bean(initMethod = "init", destroyMethod = "cleanup")
public SomeService someService() { return new SomeService(); }


// ============================================================
// CONDITIONAL BEANS
// ============================================================

// Register beans only when certain conditions are met

@Bean
@ConditionalOnProperty(name = "feature.email.enabled", havingValue = "true")
public EmailService emailService() { return new EmailService(); }

@ConditionalOnMissingBean  //Bean created only if no other bean of that type exists
@ConditionalOnClass        //Bean created only if a class is on the classpath

// @ConditionalOnMissingBean is the core mechanism behind Spring Boot auto-configuration
// Your explicit @Bean registers first, so Boot sees it and skips its own default


// ============================================================
// SPRINGAPPLICATION AND CONTEXT
// ============================================================

// @SpringBootApplication is shorthand for three annotations:
// @SpringBootConfiguration  — marks this as the root @Configuration class
// @EnableAutoConfiguration  — activates Boot's auto-config based on classpath
// @ComponentScan            — scans this package and all sub-packages for components

@SpringBootApplication
public class MyApp {
    public static void main(String[] args) {
        SpringApplication.run(MyApp.class, args);
    }
}

// Component scan covers the package of the main class and all sub-packages
// Classes outside that tree are invisible to Spring unless @ComponentScan(basePackages="...") is added

// --- Accessing the context manually (rare, mostly tooling/testing) ---
ConfigurableApplicationContext ctx = SpringApplication.run(MyApp.class, args);
OrderService svc = ctx.getBean(OrderService.class); //Prefer injection over getBean() in application code

// --- Run code after context is fully initialized ---
@Component
public class StartupTask implements ApplicationRunner {
    @Override
    public void run(ApplicationArguments args) {
        //Runs once after full context initialization
    }
}

// CommandLineRunner gives raw String[] args; ApplicationRunner gives structured ApplicationArguments