# TAILWIND RESPONSIVE - Utility class reference

## BREAKPOINT PREFIXES

```
/* Mobile-first approach: unprefixed applies to all screen sizes */
/* Add prefix to apply utility at that breakpoint and above */

/* Default (no prefix) */
text-center               /* Applies to all screen sizes */

/* Breakpoints */
sm:text-center            /* Applies at 640px and above */
md:text-center            /* Applies at 768px and above */
lg:text-center            /* Applies at 1024px and above */
xl:text-center            /* Applies at 1280px and above */
2xl:text-center           /* Applies at 1536px and above */
```

## BREAKPOINT SIZES

```
sm                        /* min-width: 640px */
md                        /* min-width: 768px */
lg                        /* min-width: 1024px */
xl                        /* min-width: 1280px */
2xl                       /* min-width: 1536px */
```

## MOBILE-FIRST EXAMPLE

```
/* Mobile: hidden, Tablet+: block */
hidden md:block

/* Mobile: 1 column, Tablet: 2 columns, Desktop: 3 columns */
grid-cols-1 md:grid-cols-2 lg:grid-cols-3

/* Mobile: text-sm, Tablet+: text-base, Desktop+: text-lg */
text-sm md:text-base lg:text-lg

/* Mobile: padding-4, Desktop+: padding-8 */
p-4 lg:p-8
```

## MAX-WIDTH BREAKPOINTS

```
/* For targeting below a breakpoint, use max-* prefix (less common) */
/* Requires configuration in tailwind.config.js */

max-sm:hidden             /* Hidden below 640px */
max-md:text-sm            /* text-sm below 768px */
```

## CONTAINER

```
container                 /* Max-width based on current breakpoint */

/* Container widths at each breakpoint: */
/* sm: 640px */
/* md: 768px */
/* lg: 1024px */
/* xl: 1280px */
/* 2xl: 1536px */

container mx-auto         /* Centered container */
container px-4            /* Container with horizontal padding */
```

## ORIENTATION

```
/* Portrait vs landscape */
portrait:hidden           /* Hidden when height > width */
landscape:block           /* Block when width > height */
```

## DARK MODE

```
/* Requires dark mode configuration in tailwind.config.js */
dark:bg-gray-800          /* Background gray-800 in dark mode */
dark:text-white           /* Text white in dark mode */
```

## PRINT

```
print:hidden              /* Hidden when printing */
print:text-black          /* Text black when printing */
```

## MOTION PREFERENCE

```
motion-safe:animate-spin  /* Animate only if user allows motion */
motion-reduce:animate-none /* Disable animation if user prefers reduced motion */
```

## COMMON RESPONSIVE PATTERNS

```
/* Hide on mobile, show on tablet+ */
hidden md:block

/* Show on mobile, hide on tablet+ */
block md:hidden

/* Responsive grid columns */
grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4

/* Responsive flex direction */
flex flex-col md:flex-row

/* Responsive text size */
text-sm sm:text-base md:text-lg lg:text-xl

/* Responsive spacing */
p-2 sm:p-4 md:p-6 lg:p-8

/* Responsive width */
w-full md:w-1/2 lg:w-1/3

/* Responsive stacking */
flex flex-col lg:flex-row gap-4
```

## ARBITRARY VARIANTS

```
/* Custom breakpoints with arbitrary values */
min-[320px]:text-sm       /* At min-width 320px */
max-[768px]:hidden        /* Below max-width 768px */
min-[800px]:grid-cols-3   /* At min-width 800px */
```

## COMBINING VARIANTS

```
/* Responsive + State */
md:hover:bg-blue-500      /* Hover background blue-500 at medium screens and above */
lg:focus:ring-2           /* Focus ring-2 at large screens and above */

/* Responsive + Dark Mode */
md:dark:bg-gray-800       /* Dark mode background at medium screens and above */

/* Multiple responsive breakpoints */
text-sm md:text-base lg:text-lg xl:text-xl 2xl:text-2xl
```