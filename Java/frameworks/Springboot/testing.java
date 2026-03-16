// Spring Boot Testing — unit tests, slice tests, integration tests, MockMvc, @MockBean


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// testingOverview()
// unitTests()
// webLayerTests()
// dataLayerTests()
// integrationTests()
// mockingWithMockBean()
// testConfiguration()


// ============================================================
// TESTING OVERVIEW
// ============================================================

// Spring Boot testing is layered — load only what you need for each test type
// Loading the full context for every test is slow; slice tests load only one layer

// Test types by scope (fastest → slowest):
// Unit test          — plain Java, no Spring context, mock all dependencies
// @WebMvcTest        — loads only web layer (controllers, filters, security)
// @DataJpaTest       — loads only JPA layer (repositories, entities, in-memory DB)
// @SpringBootTest    — loads full application context, closest to production

// Dependencies needed in build.gradle or pom.xml:
// spring-boot-starter-test — includes JUnit 5, Mockito, AssertJ, MockMvc, Spring Test


// ============================================================
// UNIT TESTS
// ============================================================

// No Spring context — just instantiate the class and test it directly
// Use Mockito to mock dependencies

class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;         //Mockito creates a fake implementation

    @Mock
    private PaymentService paymentService;

    @InjectMocks
    private OrderService orderService;               //Mockito injects mocks into this

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);           //Initialize @Mock and @InjectMocks
    }

    @Test
    void getOrder_returnsOrder_whenFound() {
        //Arrange
        Order expected = new Order(1L, "Laptop", OrderStatus.PENDING);
        when(orderRepository.findById(1L)).thenReturn(Optional.of(expected)); //Stub the mock

        //Act
        Order result = orderService.getOrder(1L);

        //Assert
        assertThat(result.getProductName()).isEqualTo("Laptop");
        verify(orderRepository).findById(1L);        //Verify mock was called
    }

    @Test
    void getOrder_throwsException_whenNotFound() {
        when(orderRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> orderService.getOrder(99L))
            .isInstanceOf(OrderNotFoundException.class)
            .hasMessageContaining("Order not found");
    }
}

// Mockito key methods:
// when(mock.method()).thenReturn(value)         — stub return value
// when(mock.method()).thenThrow(Exception.class) — stub exception
// verify(mock).method(arg)                      — assert method was called
// verify(mock, times(2)).method(arg)            — assert called N times
// verify(mock, never()).method(arg)             — assert never called
// ArgumentCaptor<T>                             — capture argument passed to mock for assertion


// ============================================================
// WEB LAYER TESTS (@WebMvcTest)
// ============================================================

// Loads only the web layer — controllers, filters, security config, @ControllerAdvice
// Does NOT load services, repositories, or full context
// Services must be mocked with @MockBean

@WebMvcTest(OrderController.class)               //Load only this controller
class OrderControllerTest {

    @Autowired
    private MockMvc mockMvc;                     //Simulates HTTP requests without starting a server

    @MockBean
    private OrderService orderService;           //@MockBean registers mock in Spring context

    @Autowired
    private ObjectMapper objectMapper;           //For serializing request bodies

    @Test
    void getOrder_returns200_whenFound() throws Exception {
        Order order = new Order(1L, "Laptop", OrderStatus.PENDING);
        when(orderService.getOrder(1L)).thenReturn(order);

        mockMvc.perform(get("/api/orders/1")
                .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.productName").value("Laptop"))
            .andExpect(jsonPath("$.status").value("PENDING"));
    }

    @Test
    void createOrder_returns201_withValidBody() throws Exception {
        OrderRequest request = new OrderRequest("Laptop", 1, "user@example.com");
        Order saved = new Order(1L, "Laptop", OrderStatus.PENDING);
        when(orderService.createOrder(any())).thenReturn(saved);

        mockMvc.perform(post("/api/orders")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id").value(1));
    }

    @Test
    void getOrder_returns404_whenNotFound() throws Exception {
        when(orderService.getOrder(99L)).thenThrow(new OrderNotFoundException("Order not found"));

        mockMvc.perform(get("/api/orders/99"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }
}

// MockMvc fluent API:
// perform(get("/path"))                  — execute GET request
// perform(post("/path").content(...))    — execute POST with body
// .header("Authorization", "Bearer ...") — add request header
// .param("status", "PENDING")           — add query parameter
// andExpect(status().isOk())            — assert HTTP status
// andExpect(jsonPath("$.field").value()) — assert JSON response field
// andExpect(content().json("{}"))        — assert full JSON response
// andDo(print())                         — print request/response to console (debugging)

// jsonPath uses Jayway JsonPath syntax:
// $.field          — top-level field
// $.nested.field   — nested field
// $.array[0].field — array element field
// $.array.length() — array length


// ============================================================
// DATA LAYER TESTS (@DataJpaTest)
// ============================================================

// Loads only JPA layer — entities, repositories, Hibernate
// Uses in-memory H2 database by default — no real Postgres needed
// Transactions are rolled back after each test automatically

@DataJpaTest
class OrderRepositoryTest {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private TestEntityManager entityManager;     //Helper for setting up test data

    @Test
    void findByStatus_returnsMatchingOrders() {
        //Arrange — persist test data
        entityManager.persist(new Order("Laptop", "a@test.com", OrderStatus.PENDING));
        entityManager.persist(new Order("Phone", "b@test.com", OrderStatus.SHIPPED));
        entityManager.flush();                   //Force write to DB before querying

        //Act
        List<Order> results = orderRepository.findByStatus(OrderStatus.PENDING);

        //Assert
        assertThat(results).hasSize(1);
        assertThat(results.get(0).getProductName()).isEqualTo("Laptop");
    }

    @Test
    void existsByCustomerEmail_returnsTrue_whenExists() {
        entityManager.persist(new Order("Laptop", "existing@test.com", OrderStatus.PENDING));
        entityManager.flush();

        assertThat(orderRepository.existsByCustomerEmail("existing@test.com")).isTrue();
        assertThat(orderRepository.existsByCustomerEmail("missing@test.com")).isFalse();
    }
}

// TestEntityManager wraps EntityManager with test-friendly methods
// Use it to insert test data directly rather than going through the repository
// @DataJpaTest replaces the datasource with H2 automatically — no config needed
// To test against real Postgres: @DataJpaTest @AutoConfigureTestDatabase(replace = NONE)


// ============================================================
// INTEGRATION TESTS (@SpringBootTest)
// ============================================================

// Loads full application context — everything wired together as in production
// Use for end-to-end tests through all layers
// Slowest — use sparingly for critical paths only

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class OrderIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;       //Real HTTP client that hits the running server

    @Autowired
    private OrderRepository orderRepository;     //Access DB directly for setup/assertions

    @Test
    void createAndRetrieveOrder_endToEnd() {
        //Arrange
        OrderRequest request = new OrderRequest("Laptop", 1, "user@test.com");

        //Act — real HTTP POST
        ResponseEntity<Order> createResponse = restTemplate.postForEntity(
            "/api/orders", request, Order.class);

        //Assert HTTP response
        assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        Long id = createResponse.getBody().getId();

        //Assert persisted in DB
        assertThat(orderRepository.findById(id)).isPresent();

        //Act — real HTTP GET
        ResponseEntity<Order> getResponse = restTemplate.getForEntity(
            "/api/orders/" + id, Order.class);

        assertThat(getResponse.getBody().getProductName()).isEqualTo("Laptop");
    }
}

// WebEnvironment options:
// RANDOM_PORT    — starts server on random port, use TestRestTemplate (most common)
// DEFINED_PORT   — starts on port from application.properties
// MOCK           — mock servlet environment, use MockMvc (no real HTTP)
// NONE           — no web environment, for testing non-web components

// TestRestTemplate vs MockMvc:
// TestRestTemplate — real HTTP calls through the full stack including serialization
// MockMvc          — simulated HTTP, faster, more control over assertions


// ============================================================
// MOCKING WITH @MOCKBEAN
// ============================================================

// @MockBean registers a Mockito mock in the Spring context, replacing the real bean
// Use in @WebMvcTest and @SpringBootTest when you want to isolate a layer

@WebMvcTest(OrderController.class)
class OrderControllerTest {

    @MockBean
    private OrderService orderService;           //Replaces real OrderService bean in context

    @MockBean
    private EmailService emailService;           //Any bean can be replaced
}

// @MockBean vs @Mock:
// @Mock        — plain Mockito, no Spring context, use in unit tests
// @MockBean    — Spring-aware, replaces the real bean in context, use in slice/integration tests

// @SpyBean — like @MockBean but wraps the real bean; real methods called unless stubbed
@SpyBean
private OrderService orderService;               //Real OrderService, but can stub specific methods
// doReturn(value).when(orderService).specificMethod(); //Stub one method, rest are real


// ============================================================
// TEST CONFIGURATION
// ============================================================

// application-test.properties — loaded automatically when spring.profiles.active=test
// Override datasource, disable external services, set feature flags for tests

// src/test/resources/application-test.properties:
// spring.datasource.url=jdbc:h2:mem:testdb
// spring.jpa.hibernate.ddl-auto=create-drop
// feature.email.enabled=false

// --- @TestConfiguration — define beans only for tests ---
@TestConfiguration
public class TestConfig {

    @Bean
    public EmailService mockEmailService() {
        return new NoOpEmailService();           //Swap real impl for a no-op in tests
    }
}

// Import into a test class:
@SpringBootTest
@Import(TestConfig.class)
class SomeIntegrationTest { }

// --- @ActiveProfiles — activate a specific profile for a test class ---
@SpringBootTest
@ActiveProfiles("test")
class OrderIntegrationTest { }

// --- @Sql — run SQL scripts before/after tests ---
@Test
@Sql("/test-data/orders.sql")                   //Insert test data before this test
@Sql(scripts = "/test-data/cleanup.sql",
     executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD) //Cleanup after
void someTest() { }