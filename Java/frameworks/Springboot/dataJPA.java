// Spring Boot Data JPA — entities, repositories, queries, transactions, relationships, pagination


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// entities()
// repositories()
// derivedQueryMethods()
// jpqlAndNativeQueries()
// transactions()
// relationships()
// paginationAndSorting()
// databaseMigrations()


// ============================================================
// ENTITIES
// ============================================================

// An entity is a Java class mapped to a database table
// Each instance of the class = one row in the table

@Entity
@Table(name = "orders") //Explicit table name; defaults to class name if omitted
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) //Auto-increment via DB (most common)
    private Long id;

    @Column(nullable = false)
    private String productName;

    @Column(name = "customer_email", nullable = false, unique = true)
    private String customerEmail;

    @Column(columnDefinition = "TEXT") //Overrides default column type
    private String notes;

    @Enumerated(EnumType.STRING) //Stores enum as "PENDING" not 0/1
    private OrderStatus status;

    @CreationTimestamp  //Hibernate sets this automatically on insert
    private LocalDateTime createdAt;

    @UpdateTimestamp    //Hibernate sets this automatically on update
    private LocalDateTime updatedAt;

    // Getters, setters, or use @Data from Lombok
}

public enum OrderStatus { PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED }

// GenerationType options:
// IDENTITY  — relies on DB auto-increment (MySQL, PostgreSQL) — most common
// SEQUENCE  — uses a DB sequence object (PostgreSQL preferred)
// AUTO      — lets Hibernate decide based on DB dialect


// ============================================================
// REPOSITORIES
// ============================================================

// JpaRepository<Entity, ID> gives you full CRUD + pagination out of the box
// No implementation needed — Spring generates it at runtime

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    // Built-in methods available immediately:
    // save(entity)               — insert or update
    // findById(id)               — returns Optional<Order>
    // findAll()                  — returns List<Order>
    // findAll(Pageable pageable) — returns Page<Order>
    // deleteById(id)
    // existsById(id)
    // count()
}

// Optional forces you to handle the "not found" case explicitly
Optional<Order> result = orderRepository.findById(42L);
Order order = result.orElseThrow(() -> new OrderNotFoundException("Order not found"));

// Other repository interfaces:
// CrudRepository      — basic CRUD only, no pagination
// PagingAndSortingRepository — CRUD + pagination, no JPA-specific features
// JpaRepository       — extends both above + adds flush(), deleteInBatch(), etc.


// ============================================================
// DERIVED QUERY METHODS
// ============================================================

// Spring parses method names and generates the SQL automatically
// No @Query needed — the method name IS the query

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByStatus(OrderStatus status);
    // SELECT * FROM orders WHERE status = ?

    List<Order> findByCustomerEmailAndStatus(String email, OrderStatus status);
    // SELECT * FROM orders WHERE customer_email = ? AND status = ?

    List<Order> findByProductNameContainingIgnoreCase(String keyword);
    // SELECT * FROM orders WHERE LOWER(product_name) LIKE LOWER('%keyword%')

    List<Order> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
    // SELECT * FROM orders WHERE created_at BETWEEN ? AND ?

    Optional<Order> findByCustomerEmail(String email);

    boolean existsByCustomerEmail(String email);

    long countByStatus(OrderStatus status);

    List<Order> findTop5ByStatusOrderByCreatedAtDesc(OrderStatus status);
    // SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC LIMIT 5
}

// Keyword reference:
// findBy / getBy / queryBy — SELECT WHERE
// And / Or                 — combine conditions
// Between                  — BETWEEN ? AND ?
// LessThan / GreaterThan   — < / >
// Like / Containing        — LIKE with manual or auto % wrapping
// IgnoreCase               — case-insensitive comparison
// OrderBy + Asc/Desc       — ORDER BY
// Top / First + N          — LIMIT N
// Distinct                 — SELECT DISTINCT
// exists / count / delete  — alternative return types


// ============================================================
// JPQL AND NATIVE QUERIES
// ============================================================

// JPQL — query against entity class and field names, not table/column names
// Native — raw SQL, tied to your specific database

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    // JPQL — uses entity name Order and field name status (not table/column)
    @Query("SELECT o FROM Order o WHERE o.status = :status AND o.customerEmail = :email")
    List<Order> findByStatusAndEmail(@Param("status") OrderStatus status,
                                     @Param("email") String email);

    // JPQL update/delete requires @Modifying
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = :status WHERE o.id = :id")
    int updateStatus(@Param("id") Long id, @Param("status") OrderStatus status);

    // Native SQL — use actual table and column names
    @Query(value = "SELECT * FROM orders WHERE customer_email = :email", nativeQuery = true)
    List<Order> findByEmailNative(@Param("email") String email);
}

// @Param binds method parameter to named placeholder in query (:name syntax)
// Positional parameters also work: ?1, ?2 (index-based, fragile — prefer named)


// ============================================================
// TRANSACTIONS
// ============================================================

// @Transactional wraps a method in a DB transaction
// Rolls back automatically on any RuntimeException

@Service
public class OrderService {

    @Transactional //All DB operations inside run in one transaction
    public Order placeOrder(OrderRequest request) {
        Order order = orderRepository.save(new Order(request));
        inventoryService.deduct(request.getProductId(), request.getQuantity());
        paymentService.charge(request.getCustomerId(), order.getTotal());
        return order; //If any step throws RuntimeException, all changes roll back
    }

    @Transactional(readOnly = true) //Optimization hint: no dirty checking, no flush
    public List<Order> getOrdersByCustomer(String email) {
        return orderRepository.findByCustomerEmail(email);
    }

    @Transactional(rollbackOn = CheckedException.class) //Also roll back on checked exceptions
    public void riskyOperation() { }
}

// Default behavior: rollback on RuntimeException and Error, commit on checked exceptions
// @Transactional on a class applies to all public methods in that class
// Transactions are proxy-based — calling a @Transactional method from within the same class bypasses the proxy


// ============================================================
// RELATIONSHIPS
// ============================================================

// --- @OneToMany / @ManyToOne (most common) ---

@Entity
public class Customer {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Order> orders = new ArrayList<>();
    // mappedBy = field name on the owning side (Order.customer)
    // cascade = ALL propagates save/delete to child orders
    // orphanRemoval = true deletes Order if removed from this list
}

@Entity
public class Order {

    @ManyToOne(fetch = FetchType.LAZY) //Don't load Customer until accessed
    @JoinColumn(name = "customer_id")  //Foreign key column in orders table
    private Customer customer;
}

// --- @OneToOne ---
@Entity
public class UserProfile {

    @OneToOne
    @JoinColumn(name = "user_id", unique = true)
    private User user;
}

// --- @ManyToMany ---
@Entity
public class Product {

    @ManyToMany
    @JoinTable(
        name = "product_tags",
        joinColumns = @JoinColumn(name = "product_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<Tag> tags = new ArrayList<>();
}

// Fetch types:
// FetchType.LAZY  — load related entity only when accessed (default for collections)
// FetchType.EAGER — load related entity immediately with parent (default for @ManyToOne/@OneToOne)
// Prefer LAZY everywhere; use JOIN FETCH in queries when you know you need the related data


// ============================================================
// PAGINATION AND SORTING
// ============================================================

// Pageable is passed in from the controller, Page<T> is returned

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    Page<Order> findByStatus(OrderStatus status, Pageable pageable);
}

@Service
public class OrderService {

    public Page<Order> getOrders(OrderStatus status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return orderRepository.findByStatus(status, pageable);
    }
}

@RestController
public class OrderController {

    @GetMapping
    public Page<Order> list(
        @RequestParam OrderStatus status,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "20") int size
    ) {
        return orderService.getOrders(status, page, size);
    }
}

// Page<T> response contains:
// content       — the list of items for this page
// totalElements — total record count across all pages
// totalPages    — total page count
// number        — current page index (0-based)
// size          — page size requested

// Sort.by("field").ascending() / .descending()
// Sort.by("status").ascending().and(Sort.by("createdAt").descending()) — multi-field sort


// ============================================================
// DATABASE MIGRATIONS — FLYWAY AND LIQUIBASE
// ============================================================

// Schema migrations version-control your database structure alongside your code
// Required in production — ddl-auto=update is unsafe for real deployments
// Both tools run pending migrations automatically on app startup

// --- FLYWAY ---
// Add dependency: spring-boot-starter-flyway (or flyway-core)
// Spring Boot auto-configures Flyway — no setup needed beyond dependency + migration files

// Migration files live at: src/main/resources/db/migration/
// Naming convention: V{version}__{description}.sql
// V1__create_orders_table.sql
// V2__add_customer_id_to_orders.sql
// V3__create_customers_table.sql

// Example migration file — V1__create_orders_table.sql:
// CREATE TABLE orders (
//     id         BIGSERIAL PRIMARY KEY,
//     product_name VARCHAR(100) NOT NULL,
//     status       VARCHAR(20)  NOT NULL,
//     created_at   TIMESTAMP    NOT NULL DEFAULT NOW()
// );

// Example migration file — V2__add_customer_email.sql:
// ALTER TABLE orders ADD COLUMN customer_email VARCHAR(255);
// UPDATE orders SET customer_email = 'unknown@example.com' WHERE customer_email IS NULL;
// ALTER TABLE orders ALTER COLUMN customer_email SET NOT NULL;

// Flyway tracks which migrations have run in a flyway_schema_history table
// On startup: compares applied migrations against files, runs any that are new
// Never modifies already-applied migrations — only runs new ones

// application.properties for Flyway:
// spring.flyway.enabled=true                    — enabled by default when dependency present
// spring.flyway.locations=classpath:db/migration — default location
// spring.flyway.baseline-on-migrate=true         — use when adding Flyway to existing DB
// spring.jpa.hibernate.ddl-auto=validate         — let Flyway manage schema, Hibernate only validates

// --- LIQUIBASE ---
// Add dependency: spring-boot-starter-liquibase (or liquibase-core)
// Uses a changelog file instead of numbered SQL files — supports XML, YAML, JSON, or SQL format

// Master changelog at: src/main/resources/db/changelog/db.changelog-master.yaml
//
// databaseChangeLog:
//   - include:
//       file: db/changelog/changes/001-create-orders-table.yaml
//   - include:
//       file: db/changelog/changes/002-add-customer-email.yaml

// Individual changeset — 001-create-orders-table.yaml:
// databaseChangeLog:
//   - changeSet:
//       id: 001
//       author: francisco
//       changes:
//         - createTable:
//             tableName: orders
//             columns:
//               - column:
//                   name: id
//                   type: BIGINT
//                   autoIncrement: true
//                   constraints:
//                     primaryKey: true
//               - column:
//                   name: product_name
//                   type: VARCHAR(100)
//                   constraints:
//                     nullable: false

// application.properties for Liquibase:
// spring.liquibase.enabled=true
// spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.yaml

// --- Flyway vs Liquibase ---
// Flyway   — SQL files only, simpler mental model, less setup, most common choice
// Liquibase — YAML/XML/JSON changesets, supports rollback natively, more complex but more powerful
// For most apps Flyway is the right default — simpler and SQL is already familiar

// --- Using with profiles (run different migrations per environment) ---
// spring.flyway.locations=classpath:db/migration,classpath:db/migration/{spring.profiles.active}
// Base migrations in db/migration/, environment-specific seed data in db/migration/dev/ etc.