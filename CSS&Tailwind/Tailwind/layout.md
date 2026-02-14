# TAILWIND LAYOUT - Utility class reference

## CONTAINER

```
container                   /* Fixed-width container with responsive breakpoints */
container mx-auto          /* Container centered horizontally */
```

## DISPLAY

```
block                      /* Display block */
inline-block              /* Display inline-block */
inline                    /* Display inline */
flex                      /* Display flex */
inline-flex               /* Display inline-flex */
grid                      /* Display grid */
inline-grid               /* Display inline-grid */
hidden                    /* Display none */
```

## FLEXBOX - DIRECTION

```
flex-row                  /* Flex direction row (default, left to right) */
flex-row-reverse          /* Flex direction row-reverse (right to left) */
flex-col                  /* Flex direction column (top to bottom) */
flex-col-reverse          /* Flex direction column-reverse (bottom to top) */
```

## FLEXBOX - JUSTIFY CONTENT (main axis)

```
justify-start             /* Justify content flex-start (default) */
justify-end               /* Justify content flex-end */
justify-center            /* Justify content center */
justify-between           /* Justify content space-between */
justify-around            /* Justify content space-around */
justify-evenly            /* Justify content space-evenly */
```

## FLEXBOX - ALIGN ITEMS (cross axis)

```
items-start               /* Align items flex-start */
items-end                 /* Align items flex-end */
items-center              /* Align items center */
items-baseline            /* Align items baseline */
items-stretch             /* Align items stretch (default) */
```

## FLEXBOX - ALIGN CONTENT (wrapped lines)

```
content-start             /* Align content flex-start */
content-end               /* Align content flex-end */
content-center            /* Align content center */
content-between           /* Align content space-between */
content-around            /* Align content space-around */
content-evenly            /* Align content space-evenly */
```

## FLEXBOX - WRAP

```
flex-wrap                 /* Flex wrap */
flex-wrap-reverse         /* Flex wrap-reverse */
flex-nowrap               /* Flex nowrap (default) */
```

## FLEXBOX - ITEM PROPERTIES

```
flex-1                    /* Flex: 1 1 0% (grow and shrink equally) */
flex-auto                 /* Flex: 1 1 auto */
flex-initial              /* Flex: 0 1 auto */
flex-none                 /* Flex: none (don't grow or shrink) */

grow                      /* Flex-grow: 1 */
grow-0                    /* Flex-grow: 0 */
shrink                    /* Flex-shrink: 1 */
shrink-0                  /* Flex-shrink: 0 */
```

## FLEXBOX - ALIGN SELF

```
self-auto                 /* Align self auto */
self-start                /* Align self flex-start */
self-end                  /* Align self flex-end */
self-center               /* Align self center */
self-stretch              /* Align self stretch */
self-baseline             /* Align self baseline */
```

## FLEXBOX - ORDER

```
order-1                   /* Order: 1 */
...                       /* Default: 1-12 */
order-12                  /* Order: 12 */
order-[15]                /* Order: Any number */
order-first               /* Order: -9999 */
order-last                /* Order: 9999 */
order-none                /* Order: 0 */
```

## GRID - TEMPLATE COLUMNS

```
grid-cols-1               /* Grid template columns: 1 column */
...                       /* Default: 1-12 columns */
grid-cols-12              /* Grid template columns: 12 columns */
grid-cols-[15]            /* Grid template columns: Any number of columns */
grid-cols-none            /* Grid template columns: none */
```

## GRID - TEMPLATE ROWS

```
grid-rows-1               /* Grid template rows: 1 row */
...                       /* Default: 1-6 rows */
grid-rows-6               /* Grid template rows: 6 rows */
grid-rows-[10]            /* Grid template rows: Any number of rows */
grid-rows-none            /* Grid template rows: none */
```

## GRID - COLUMN SPAN

```
col-auto                  /* Grid column: auto */
col-span-1                /* Grid column: span 1 */
...                       /* Default: 1-12 */
col-span-12               /* Grid column: span 12 */
col-span-[15]             /* Grid column: span any number */
col-span-full             /* Grid column: 1 / -1 (full width) */
```

## GRID - COLUMN START/END

```
col-start-1               /* Grid column start: 1 */
...                       /* Default: 1-13 */
col-start-13              /* Grid column start: 13 */
col-start-[15]            /* Grid column start: Any number */
col-start-auto            /* Grid column start: auto */

col-end-1                 /* Grid column end: 1 */
...                       /* Default: 1-13 */
col-end-13                /* Grid column end: 13 */
col-end-[15]              /* Grid column end: Any number */
col-end-auto              /* Grid column end: auto */
```

## GRID - ROW SPAN

```
row-auto                  /* Grid row: auto */
row-span-1                /* Grid row: span 1 */
...                       /* Default: 1-6 */
row-span-6                /* Grid row: span 6 */
row-span-[10]             /* Grid row: span any number */
row-span-full             /* Grid row: 1 / -1 (full height) */
```

## GRID - ROW START/END

```
row-start-1               /* Grid row start: 1 */
...                       /* Default: 1-7 */
row-start-7               /* Grid row start: 7 */
row-start-[10]            /* Grid row start: Any number */
row-start-auto            /* Grid row start: auto */

row-end-1                 /* Grid row end: 1 */
...                       /* Default: 1-7 */
row-end-7                 /* Grid row end: 7 */
row-end-[10]              /* Grid row end: Any number */
row-end-auto              /* Grid row end: auto */
```

## GRID - GAP

```
gap-0                     /* Gap: 0px */
gap-px                    /* Gap: 1px */
gap-0.5                   /* Gap: 0.125rem (2px) */
...                       /* Uses spacing scale: 0.5, 1, 2, 4, 8...96 */
gap-96                    /* Gap: 24rem (384px) */
gap-[50px]                /* Gap: Any value with px, rem, etc. */

gap-x-4                   /* Column gap: 1rem */
gap-y-2                   /* Row gap: 0.5rem */
```

## POSITION

```
static                    /* Position static (default) */
fixed                     /* Position fixed */
absolute                  /* Position absolute */
relative                  /* Position relative */
sticky                    /* Position sticky */
```

## POSITION VALUES

```
/* All sides */
inset-0                   /* Top, right, bottom, left: 0 */
...                       /* Uses spacing scale: 0, 1, 2, 4...96 */
inset-96                  /* Top, right, bottom, left: 24rem */
inset-[100px]             /* Top, right, bottom, left: Any value */

/* Horizontal/Vertical */
inset-x-4                 /* Left, right: 1rem */
inset-y-8                 /* Top, bottom: 2rem */

/* Individual sides */
top-0                     /* Top: 0 */
...                       /* Uses spacing scale: 0, 1, 2, 4...96 */
top-96                    /* Top: 24rem */
top-[100px]               /* Top: Any value */

/* Same pattern for right, bottom, left */
right-4                   /* Right: 1rem */
bottom-8                  /* Bottom: 2rem */
left-12                   /* Left: 3rem */

/* Percentages */
top-1/2                   /* Top: 50% */
top-1/3                   /* Top: 33.333% */
top-2/3                   /* Top: 66.666% */
top-1/4                   /* Top: 25% */
top-3/4                   /* Top: 75% */
top-full                  /* Top: 100% */
```

## Z-INDEX

```
z-0                       /* Z-index: 0 */
...                       /* Intervals of 10: 0-50 */
z-50                      /* Z-index: 50 */
z-[999]                   /* Z-index: Any number */
z-auto                    /* Z-index: auto */
```

## OVERFLOW

```
overflow-auto             /* Overflow: auto */
overflow-hidden           /* Overflow: hidden */
overflow-visible          /* Overflow: visible */
overflow-scroll           /* Overflow: scroll */

overflow-x-auto           /* Overflow-x: auto */
overflow-y-auto           /* Overflow-y: auto */
overflow-x-hidden         /* Overflow-x: hidden */
overflow-y-hidden         /* Overflow-y: hidden */
```

## OBJECT FIT

```
object-contain            /* Object-fit: contain */
object-cover              /* Object-fit: cover */
object-fill               /* Object-fit: fill */
object-none               /* Object-fit: none */
object-scale-down         /* Object-fit: scale-down */
```

## OBJECT POSITION

```
object-bottom             /* Object-position: bottom */
object-center             /* Object-position: center */
object-top                /* Object-position: top */
object-left               /* Object-position: left */
object-right              /* Object-position: right */
```