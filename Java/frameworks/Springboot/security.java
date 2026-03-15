// Spring Boot Security — securing endpoints, JWT validation from external provider,
// method-level security, CORS, extracting claims
// Scoped to token CONSUMPTION only — token generation and user management handled by external provider (e.g. AWS Cognito, Firebase)


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// securityFilterChain()
// jwtDecoder()
// corsConfiguration()
// methodLevelSecurity()
// extractingClaims()
// securityContext()


// ============================================================
// SECURITY FILTER CHAIN
// ============================================================

// SecurityFilterChain defines which endpoints are protected and how requests are authenticated
// Replaces the old WebSecurityConfigurerAdapter (deprecated in Spring Security 5.7+)

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())                          //Disable CSRF for stateless REST APIs
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)) //No server-side sessions; JWT is stateless
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()     //No auth required
                .requestMatchers("/api/admin/**").hasRole("ADMIN") //ADMIN role required
                .requestMatchers(HttpMethod.GET, "/api/orders/**").hasAnyRole("USER", "ADMIN")
                .anyRequest().authenticated()                      //Everything else requires valid token
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.decoder(jwtDecoder()))             //Validate incoming JWTs automatically
            );

        return http.build();
    }
}

// Flow: request arrives → Spring Security filter checks Authorization header
// → validates JWT signature against provider's public keys → grants or denies access
// Your app never issues tokens — it only validates them


// ============================================================
// JWT DECODER
// ============================================================

// JwtDecoder validates incoming tokens against your external provider's public keys
// Spring fetches the public keys automatically from the provider's JWKS URI

@Configuration
public class SecurityConfig {

    // --- AWS Cognito ---
    @Bean
    public JwtDecoder jwtDecoder() {
        String jwksUri = "https://cognito-idp.{region}.amazonaws.com/{userPoolId}/.well-known/jwks.json";
        return NimbusJwtDecoder.withJwkSetUri(jwksUri).build();
    }

    // --- Firebase ---
    @Bean
    public JwtDecoder jwtDecoder() {
        String jwksUri = "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";
        return NimbusJwtDecoder.withJwkSetUri(jwksUri).build();
    }
}

// JWKS (JSON Web Key Set) URI is the provider's public endpoint that exposes their signing keys
// Spring fetches and caches these keys; tokens are validated against them locally — no round trip per request
// If the token signature doesn't match, Spring rejects the request with 401 before it hits your controller

// --- Configuring via application.properties instead ---
// spring.security.oauth2.resourceserver.jwt.jwk-set-uri=https://cognito-idp.{region}.amazonaws.com/{userPoolId}/.well-known/jwks.json
// Spring Boot auto-configures a JwtDecoder from this property — no @Bean needed if using defaults


// ============================================================
// CORS CONFIGURATION
// ============================================================

// CORS (Cross-Origin Resource Sharing) — controls which frontend origins can call your API
// Required when your frontend (e.g. React on localhost:3000) calls your API on a different origin

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            // ... rest of config
        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(List.of(
            "https://myapp.com",
            "http://localhost:3000"           //Allow local dev frontend
        ));
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        config.setAllowedHeaders(List.of("Authorization", "Content-Type"));
        config.setAllowCredentials(true);     //Required if frontend sends cookies or Authorization header

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config); //Apply to all paths
        return source;
    }
}

// CORS is enforced by the browser, not the server — the server just declares its policy
// OPTIONS preflight request is sent by browser before POST/PUT; Spring handles it automatically
// setAllowCredentials(true) requires explicit origins — cannot use wildcard "*" with credentials


// ============================================================
// METHOD-LEVEL SECURITY
// ============================================================

// Fine-grained access control directly on service or controller methods
// Requires @EnableMethodSecurity on a @Configuration class

@Configuration
@EnableWebSecurity
@EnableMethodSecurity //Enables @PreAuthorize, @PostAuthorize, @Secured
public class SecurityConfig { }

// --- @PreAuthorize — evaluated before method executes ---
@Service
public class OrderService {

    @PreAuthorize("hasRole('ADMIN')")
    public void deleteAllOrders() { }

    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public List<Order> getAllOrders() { }

    // Access method parameters in the expression
    @PreAuthorize("#userId == authentication.principal.subject")
    public Order getOrder(String userId, Long orderId) { }
    // #userId refers to the method parameter; authentication.principal is the JWT

    @PreAuthorize("hasAuthority('SCOPE_orders:read')") //Check OAuth2 scope from token
    public List<Order> listOrders() { }
}

// --- @PostAuthorize — evaluated after method executes, can inspect return value ---
@PostAuthorize("returnObject.customerEmail == authentication.principal.subject")
public Order getOrderById(Long id) {
    return orderRepository.findById(id).orElseThrow();
    //Method runs, then Spring checks if the returned order belongs to the requesting user
}

// SpEL (Spring Expression Language) is used inside @PreAuthorize strings:
// hasRole('X')              — checks ROLE_X in authorities
// hasAuthority('X')         — checks exact authority string X (use for scopes/permissions)
// authentication.principal  — the JWT object
// #paramName                — references a method parameter by name


// ============================================================
// EXTRACTING CLAIMS
// ============================================================

// Claims are the payload fields inside the JWT (sub, email, custom attributes, roles, etc.)
// Spring parses the JWT and makes claims available via the Jwt object

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    // Inject the JWT directly into a method parameter
    @GetMapping("/me")
    public List<Order> getMyOrders(@AuthenticationPrincipal Jwt jwt) {
        String userId = jwt.getSubject();                          //Standard "sub" claim
        String email  = jwt.getClaimAsString("email");            //Any claim by name
        List<String> roles = jwt.getClaimAsStringList("cognito:groups"); //Cognito-specific groups claim
        return orderService.findByUserId(userId);
    }
}

// Common standard JWT claims:
// sub       — subject; unique user identifier from the provider
// email     — user's email (if included by provider)
// iss       — issuer; URL of the auth provider
// exp       — expiration timestamp; Spring validates this automatically
// iat       — issued-at timestamp

// Provider-specific claims:
// Cognito:  cognito:groups, cognito:username
// Firebase: user_id, firebase.sign_in_provider

// jwt.getClaims()           — returns Map<String, Object> of all claims
// jwt.getClaimAsString("x") — single string claim
// jwt.getClaimAsStringList  — claim that is a JSON array of strings


// ============================================================
// SECURITY CONTEXT
// ============================================================

// SecurityContextHolder stores the authenticated user's info for the duration of a request
// Accessible anywhere in the call stack without passing the user around manually

public class AuditService {

    public String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Jwt jwt = (Jwt) auth.getPrincipal();
        return jwt.getSubject();
    }
}

// SecurityContextHolder is thread-local — each request thread has its own context
// Cleared automatically after the request completes
// In async methods (@Async), context is NOT automatically propagated — must configure explicitly:
// SecurityContextHolder.setStrategyName(SecurityContextHolder.MODE_INHERITABLETHREADLOCAL)

// Prefer @AuthenticationPrincipal Jwt jwt in controller parameters over SecurityContextHolder
// Use SecurityContextHolder in service/utility classes that don't have access to method parameters