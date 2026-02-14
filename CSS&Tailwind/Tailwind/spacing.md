# TAILWIND SPACING - Utility class reference

## NOTES

```
/* Margin creates space OUTSIDE element (pushes other elements away) */
/* Padding creates space INSIDE element (between border and content) */
/* Space-between adds margin between child elements (not first/last) */
/* Negative margins pull elements in opposite direction */
/* mx-auto centers block elements horizontally (requires width set) */
```

## SPACING SCALE

```
0       = 0px
px      = 1px
0.5     = 0.125rem (2px)
1       = 0.25rem (4px)
...     /* Increments: 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 11, 12 */
12      = 3rem (48px)
...     /* Then: 14, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80 */
96      = 24rem (384px)
```

## MARGIN - ALL SIDES

```
m-0                       /* Margin: 0 */
m-px                      /* Margin: 1px */
m-0.5                     /* Margin: 0.125rem (2px) */
...                       /* Uses spacing scale: 0.5, 1, 2, 4...96 */
m-96                      /* Margin: 24rem (384px) */
m-[50px]                  /* Margin: Any value */
m-auto                    /* Margin: auto */
```

## MARGIN - INDIVIDUAL SIDES

```
/* Same pattern for mt (top), mr (right), mb (bottom), ml (left) */
mt-0                      /* Margin-top: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
mt-96                     /* Margin-top: 24rem */
mt-[50px]                 /* Margin-top: Any value */

/* Examples for other sides */
mr-4                      /* Margin-right: 1rem */
mb-8                      /* Margin-bottom: 2rem */
ml-12                     /* Margin-left: 3rem */
```

## MARGIN - HORIZONTAL/VERTICAL

```
mx-0                      /* Margin left and right: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
mx-96                     /* Margin left and right: 24rem */
mx-[50px]                 /* Margin left and right: Any value */
mx-auto                   /* Margin left and right: auto (centers element) */

my-0                      /* Margin top and bottom: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
my-96                     /* Margin top and bottom: 24rem */
my-[50px]                 /* Margin top and bottom: Any value */
```

## MARGIN - NEGATIVE (pulls element)

```
/* Negative versions of all margin utilities */
-m-4                      /* Margin: -1rem (all sides) */
-mt-4                     /* Margin-top: -1rem */
-mr-4                     /* Margin-right: -1rem */
-mb-4                     /* Margin-bottom: -1rem */
-ml-4                     /* Margin-left: -1rem */
-mx-4                     /* Margin left and right: -1rem */
-my-4                     /* Margin top and bottom: -1rem */
-m-[50px]                 /* Margin: Any negative value */
```

## PADDING - ALL SIDES

```
p-0                       /* Padding: 0 */
p-px                      /* Padding: 1px */
p-0.5                     /* Padding: 0.125rem (2px) */
...                       /* Uses spacing scale: 0.5, 1, 2, 4...96 */
p-96                      /* Padding: 24rem (384px) */
p-[50px]                  /* Padding: Any value */
```

## PADDING - INDIVIDUAL SIDES

```
/* Same pattern for pt (top), pr (right), pb (bottom), pl (left) */
pt-0                      /* Padding-top: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
pt-96                     /* Padding-top: 24rem */
pt-[50px]                 /* Padding-top: Any value */

/* Examples for other sides */
pr-4                      /* Padding-right: 1rem */
pb-8                      /* Padding-bottom: 2rem */
pl-12                     /* Padding-left: 3rem */
```

## PADDING - HORIZONTAL/VERTICAL

```
px-0                      /* Padding left and right: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
px-96                     /* Padding left and right: 24rem */
px-[50px]                 /* Padding left and right: Any value */

py-0                      /* Padding top and bottom: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
py-96                     /* Padding top and bottom: 24rem */
py-[50px]                 /* Padding top and bottom: Any value */
```

## SPACE BETWEEN - Gap between children

```
space-x-0                 /* Horizontal space between children: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
space-x-96                /* Horizontal space between children: 24rem */
space-x-[50px]            /* Horizontal space between children: Any value */
space-x-reverse           /* Reverse horizontal space direction */

space-y-0                 /* Vertical space between children: 0 */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
space-y-96                /* Vertical space between children: 24rem */
space-y-[50px]            /* Vertical space between children: Any value */
space-y-reverse           /* Reverse vertical space direction */
```

