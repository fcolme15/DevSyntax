// Spring Boot WebSockets — full-duplex real-time communication between client and server
// Covers raw WebSocket, STOMP messaging protocol, and broadcasting


// ============================================================
// OVERVIEW — TABLE OF CONTENTS
// ============================================================
// webSocketOverview()
// rawWebSocket()
// stompConfiguration()
// stompController()
// sendingToClients()
// webSocketSecurity()


// ============================================================
// WEBSOCKET OVERVIEW
// ============================================================

// HTTP:      client sends request → server responds → connection closes (one direction at a time)
// WebSocket: client and server establish one persistent connection → either side can send at any time

// Use cases: live chat, real-time notifications, collaborative editing, live dashboards, game state

// Two approaches in Spring:
// 1. Raw WebSocket — low level, manual message handling, no protocol on top
// 2. STOMP over WebSocket — messaging protocol layered on top, topics/subscriptions, cleaner for most apps

// STOMP (Simple Text Oriented Messaging Protocol) is almost always the right choice
// Raw WebSocket is only needed when you need full control over the binary/text framing


// ============================================================
// RAW WEBSOCKET
// ============================================================

// Handler processes incoming messages and manages connection lifecycle

public class RawSocketHandler extends TextWebSocketHandler {

    private final List<WebSocketSession> sessions = new CopyOnWriteArrayList<>(); //Thread-safe session store

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        sessions.add(session);
        System.out.println("Connected: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        //Echo back to sender
        session.sendMessage(new TextMessage("Echo: " + payload));
        //Or broadcast to all sessions
        for (WebSocketSession s : sessions) {
            if (s.isOpen()) s.sendMessage(new TextMessage(payload));
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        sessions.remove(session);
    }
}

// Register the handler at a path
@Configuration
@EnableWebSocket
public class RawWebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new RawSocketHandler(), "/ws/raw")
                .setAllowedOrigins("*");              //CORS for WebSocket connections
    }
}

// Client connects to: ws://localhost:8080/ws/raw
// wss:// for secure (TLS) connections


// ============================================================
// STOMP CONFIGURATION
// ============================================================

// STOMP adds pub/sub messaging on top of WebSocket
// Clients subscribe to topics; server broadcasts to topics; Spring routes messages

@Configuration
@EnableWebSocketMessageBroker
public class StompWebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/topic", "/queue");
        // /topic — broadcast to all subscribers (pub/sub, one-to-many)
        // /queue — send to a specific user (point-to-point, one-to-one)

        registry.setApplicationDestinationPrefixes("/app");
        // /app prefix routes messages to @MessageMapping methods in controllers
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")                   //WebSocket handshake endpoint
                .setAllowedOriginPatterns("*")
                .withSockJS();                        //SockJS fallback for browsers that don't support WebSocket
    }
}

// Message flow:
// Client sends to /app/chat → @MessageMapping("/chat") handles it → broadcasts to /topic/messages
// Client subscribes to /topic/messages → receives all messages sent to that topic


// ============================================================
// STOMP CONTROLLER
// ============================================================

// @MessageMapping handles messages sent from clients (like @PostMapping but for WebSocket)
// @SendTo broadcasts the return value to a topic

@Controller
public class ChatController {

    // Client sends to /app/chat, return value broadcast to /topic/messages
    @MessageMapping("/chat")
    @SendTo("/topic/messages")
    public ChatMessage handleMessage(ChatMessage message) {
        message.setTimestamp(LocalDateTime.now());
        return message; //Spring serializes to JSON and broadcasts to all /topic/messages subscribers
    }

    // Client sends to /app/private, return value sent only to sender
    @MessageMapping("/private")
    @SendToUser("/queue/reply")                       //Sends only to the user who sent the message
    public ChatMessage handlePrivate(ChatMessage message, Principal principal) {
        return message;
    }
}

public class ChatMessage {
    private String sender;
    private String content;
    private LocalDateTime timestamp;
    // Getters and setters
}


// ============================================================
// SENDING TO CLIENTS (SERVER-INITIATED)
// ============================================================

// SimpMessagingTemplate lets you push messages from anywhere in your app — not just in response to a client message
// Inject it into any service/controller to broadcast at any time

@Service
public class NotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    public NotificationService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    // Broadcast to all subscribers of a topic
    public void broadcastOrderUpdate(Order order) {
        messagingTemplate.convertAndSend("/topic/orders", order);
    }

    // Send to a specific user only (user must be authenticated)
    public void sendToUser(String userId, Order order) {
        messagingTemplate.convertAndSendToUser(userId, "/queue/orders", order);
        // Delivered to /user/{userId}/queue/orders — only that user's session receives it
    }
}

// SimpMessagingTemplate can be called from:
// — A @Service triggered by a business event (order placed, payment received)
// — A @Scheduled method for periodic updates
// — A JPA entity lifecycle callback
// This is the key difference from REST: the server pushes data without the client asking


// ============================================================
// WEBSOCKET SECURITY
// ============================================================

// WebSocket connections are established via an HTTP handshake — JWT can be sent at connect time

// --- Option 1: Pass token as query parameter during handshake (simple, less secure) ---
// Client connects to: ws://localhost:8080/ws?token=eyJhbGci...
// Interceptor extracts and validates the token at connection time

@Configuration
public class WebSocketAuthConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(new ChannelInterceptor() {
            @Override
            public Message<?> preSend(Message<?> message, MessageChannel channel) {
                StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);

                if (StompCommand.CONNECT.equals(accessor.getCommand())) {
                    String token = accessor.getFirstNativeHeader("Authorization"); //Read from STOMP header
                    if (token != null && token.startsWith("Bearer ")) {
                        // Validate token and set authentication
                        // accessor.setUser(authenticatedPrincipal);
                    }
                }
                return message;
            }
        });
    }
}

// --- Option 2: Use Spring Security's HTTP security to protect the /ws handshake endpoint ---
// In SecurityFilterChain:
// .requestMatchers("/ws/**").authenticated()
// The HTTP upgrade request is authenticated like any other HTTP request
// Once connected, Spring propagates the security context into the WebSocket session

// Principal is available in @MessageMapping methods:
@MessageMapping("/chat")
public ChatMessage handle(ChatMessage msg, Principal principal) {
    String userId = principal.getName(); //The authenticated user's identifier
    return msg;
}