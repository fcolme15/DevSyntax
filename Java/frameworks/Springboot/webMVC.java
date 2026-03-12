// Spring Boot Web MVC — REST controllers, request mapping, request/response handling,
// validation, exception handling, filters, interceptors


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// restController()
// requestMapping()
// requestData()
// responseHandling()
// validation()
// exceptionHandling()
// filtersAndInterceptors()


// ============================================================
// REST CONTROLLER
// ============================================================

// @RestController = @Controller + @ResponseBody
// Every method return value is written directly to the HTTP response body as JSON (via Jackson)

@RestController
@RequestMapping("/api/orders") //Base path for all methods in this controller
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) { //Constructor injection; no @Autowired needed
        this.orderService = orderService;
    }
}


// ============================================================
// REQUEST MAPPING
// ============================================================

// Map HTTP methods to handler methods

@GetMapping("/")                  //GET    — retrieve
@PostMapping("/")                 //POST   — create
@PutMapping("/{id}")              //PUT    — full replace
@PatchMapping("/{id}")            //PATCH  — partial update
@DeleteMapping("/{id}")           //DELETE — remove

// Explicit equivalent (rarely used directly):
@RequestMapping(value = "/{id}", method = RequestMethod.GET)

// --- Examples ---

@GetMapping("/{id}")
public Order getOrder(@PathVariable Long id) {
    return orderService.findById(id);
}

@PostMapping
public Order createOrder(@RequestBody Order order) {
    return orderService.save(order);
}

@DeleteMapping("/{id}")
@ResponseStatus(HttpStatus.NO_CONTENT) //Returns 204 instead of default 200
public void deleteOrder(@PathVariable Long id) {
    orderService.delete(id);
}


// ============================================================
// REQUEST DATA
// ============================================================

// --- @PathVariable — extract from URL path ---
@GetMapping("/{id}")
public Order getById(@PathVariable Long id) { } // /api/orders/42 → id = 42

// --- @RequestParam — extract from query string ---
@GetMapping
public List<Order> getOrders(
    @RequestParam String status,                        // /api/orders?status=PENDING (required by default)
    @RequestParam(required = false) String customerId,  //Optional param
    @RequestParam(defaultValue = "10") int limit        //Falls back to 10 if not provided
) { }

// --- @RequestBody — deserialize JSON body into object (uses Jackson) ---
@PostMapping
public Order create(@RequestBody Order order) { }

// --- @RequestHeader — extract a specific header ---
@GetMapping("/info")
public String info(@RequestHeader("X-Request-ID") String requestId) { }

// --- @CookieValue — extract a cookie ---
@GetMapping("/session")
public String session(@CookieValue("sessionId") String sessionId) { }


// ============================================================
// RESPONSE HANDLING
// ============================================================

// Returning an object directly: Spring serializes it to JSON with 200 OK
@GetMapping("/{id}")
public Order getOrder(@PathVariable Long id) {
    return orderService.findById(id);
}

// ResponseEntity — full control over status code, headers, and body
@GetMapping("/{id}")
public ResponseEntity<Order> getOrder(@PathVariable Long id) {
    Order order = orderService.findById(id);
    if (order == null) {
        return ResponseEntity.notFound().build();             //404 with no body
    }
    return ResponseEntity.ok(order);                         //200 with body
}

// ResponseEntity with custom headers
@PostMapping
public ResponseEntity<Order> createOrder(@RequestBody Order order) {
    Order saved = orderService.save(order);
    URI location = URI.create("/api/orders/" + saved.getId());
    return ResponseEntity.created(location).body(saved);     //201 with Location header
}

// Common ResponseEntity builder methods:
// ResponseEntity.ok(body)               — 200
// ResponseEntity.created(uri).body(...) — 201
// ResponseEntity.noContent().build()    — 204
// ResponseEntity.badRequest().build()   — 400
// ResponseEntity.notFound().build()     — 404
// ResponseEntity.status(418).body(...)  — any custom status


// ============================================================
// VALIDATION
// ============================================================

// Add spring-boot-starter-validation dependency to use Bean Validation (Jakarta)
// @Valid on @RequestBody triggers validation of annotated fields

public class OrderRequest {
    @NotNull
    @Size(min = 1, max = 100)
    private String productName;

    @Min(1)
    private int quantity;

    @Email
    private String customerEmail;

    @NotBlank          //Not null AND not empty/whitespace
    private String address;
}

//Run @Valid on the @RequestBody parameter to run validation before method executes
@PostMapping
public Order create(@Valid @RequestBody OrderRequest request) { //Throws MethodArgumentNotValidException if invalid
    return orderService.save(request);
}

// Common validation annotations:
// @NotNull      — field must not be null
// @NotBlank     — string must not be null or whitespace
// @Size         — string/collection length bounds
// @Min / @Max   — numeric bounds
// @Email        — valid email format
// @Pattern      — regex match


// ============================================================
// EXCEPTION HANDLING
// ============================================================

// --- @ExceptionHandler — handle exceptions within a single controller ---
@ExceptionHandler(OrderNotFoundException.class)
public ResponseEntity<String> handleNotFound(OrderNotFoundException ex) {
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
}

// --- @ControllerAdvice — global exception handler across all controllers ---
@RestControllerAdvice  //@ControllerAdvice + @ResponseBody
public class GlobalExceptionHandler {

    @ExceptionHandler(OrderNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(OrderNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse("NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class) //Triggered by @Valid failures
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
            .map(e -> e.getField() + ": " + e.getDefaultMessage())
            .collect(Collectors.joining(", "));
        return ResponseEntity.badRequest().body(new ErrorResponse("VALIDATION_ERROR", message));
    }

    @ExceptionHandler(Exception.class) //Catch-all fallback
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(new ErrorResponse("INTERNAL_ERROR", "An unexpected error occurred"));
    }
}

// ErrorResponse is a plain class you define:
public class ErrorResponse {
    private String code;
    private String message;
    public ErrorResponse(String code, String message) { ... }
}


// ============================================================
// FILTERS AND INTERCEPTORS
// ============================================================

// Filters — servlet-level, run before Spring processes the request
// Interceptors — Spring-level, run after filters but before controller methods

// --- Filter (lower level, sees raw HttpServletRequest) ---
@Component
public class RequestLoggingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        System.out.println("Incoming: " + req.getMethod() + " " + req.getRequestURI());
        chain.doFilter(request, response); //Must call this to continue the chain
    }
}

// --- Interceptor (higher level, has access to handler method info) ---
@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        //Return false to abort request processing; return true to continue
        String token = request.getHeader("Authorization");
        if (token == null) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) {
        //Runs after controller method, before view rendering
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {
        //Runs after response is sent — good for cleanup/logging
    }
}

// Interceptors must be registered:
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
            .addPathPatterns("/api/**")       //Apply to these paths
            .excludePathPatterns("/api/auth/**"); //Exclude these paths
    }
}