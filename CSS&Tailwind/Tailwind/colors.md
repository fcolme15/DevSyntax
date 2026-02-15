# TAILWIND COLORS - Utility class reference

## COLOR PALETTE

```
/* Each color has shades: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 */
/* 50 = lightest, 950 = darkest */

/* Colors */
red-500
orange-500
yellow-500
green-500
cyan-500
sky-500
blue-500
violet-500
purple-500
pink-500
```

## TEXT COLOR

```
text-inherit              /* Color: inherit */
text-current              /* Color: currentColor */
text-transparent          /* Color: transparent */
text-black                /* Color: rgb(0 0 0) */
text-white                /* Color: rgb(255 255 255) */

/* Color palette */
text-slate-50             /* Lightest */
...                       /* 100, 200, 300, 400, 500, 600, 700, 800, 900 */
text-slate-950            /* Darkest */

/* Same pattern for all colors: gray, zinc, neutral, stone, red, orange, etc. */
text-red-500              /* Example */
text-blue-600             /* Example */

/* Arbitrary color */
text-[#1da1f2]            /* Any hex value */
text-[rgb(255,0,0)]       /* Any rgb value */
```

## BACKGROUND COLOR

```
bg-inherit                /* Background-color: inherit */
bg-current                /* Background-color: currentColor */
bg-transparent            /* Background-color: transparent */
bg-black                  /* Background-color: rgb(0 0 0) */
bg-white                  /* Background-color: rgb(255 255 255) */

/* Color palette - same pattern as text color */
bg-slate-50               /* Lightest */
...                       /* 100, 200, 300, 400, 500, 600, 700, 800, 900 */
bg-slate-950              /* Darkest */

bg-red-500                /* Example */
bg-blue-600               /* Example */

/* Arbitrary color */
bg-[#1da1f2]              /* Any hex value */
bg-[rgb(255,0,0)]         /* Any rgb value */
```

## BORDER COLOR

```
border-inherit            /* Border-color: inherit */
border-current            /* Border-color: currentColor */
border-transparent        /* Border-color: transparent */
border-black              /* Border-color: rgb(0 0 0) */
border-white              /* Border-color: rgb(255 255 255) */

/* Color palette - same pattern */
border-slate-50           /* Lightest */
...                       /* 100, 200, 300, 400, 500, 600, 700, 800, 900 */
border-slate-950          /* Darkest */

/* Individual sides */
border-x-red-500          /* Border left and right color */
border-y-blue-500         /* Border top and bottom color */
border-t-green-500        /* Border top color */
border-r-red-500          /* Border right color */
border-b-blue-500         /* Border bottom color */
border-l-yellow-500       /* Border left color */

/* Arbitrary color */
border-[#1da1f2]          /* Any hex value */
```

## OUTLINE COLOR

```
outline-inherit           /* Outline-color: inherit */
outline-current           /* Outline-color: currentColor */
outline-transparent       /* Outline-color: transparent */
outline-black             /* Outline-color: rgb(0 0 0) */
outline-white             /* Outline-color: rgb(255 255 255) */

/* Color palette - same pattern */
outline-red-500           /* Example */
outline-[#1da1f2]         /* Arbitrary color */
```

## RING COLOR

```
ring-inherit              /* Ring-color: inherit */
ring-current              /* Ring-color: currentColor */
ring-transparent          /* Ring-color: transparent */
ring-black                /* Ring-color: rgb(0 0 0) */
ring-white                /* Ring-color: rgb(255 255 255) */

/* Color palette - same pattern */
ring-blue-500             /* Example */
ring-[#1da1f2]            /* Arbitrary color */
```

## ACCENT COLOR

```
accent-auto               /* Accent-color: auto */
accent-inherit            /* Accent-color: inherit */
accent-current            /* Accent-color: currentColor */
accent-transparent        /* Accent-color: transparent */
accent-black              /* Accent-color: rgb(0 0 0) */
accent-white              /* Accent-color: rgb(255 255 255) */

/* Color palette - same pattern */
accent-blue-500           /* Example */
accent-[#1da1f2]          /* Arbitrary color */
```

## CARET COLOR

```
caret-inherit             /* Caret-color: inherit */
caret-current             /* Caret-color: currentColor */
caret-transparent         /* Caret-color: transparent */
caret-black               /* Caret-color: rgb(0 0 0) */
caret-white               /* Caret-color: rgb(255 255 255) */

/* Color palette - same pattern */
caret-blue-500            /* Example */
caret-[#1da1f2]           /* Arbitrary color */
```

## FILL (SVG)

```
fill-none                 /* Fill: none */
fill-inherit              /* Fill: inherit */
fill-current              /* Fill: currentColor */
fill-transparent          /* Fill: transparent */
fill-black                /* Fill: rgb(0 0 0) */
fill-white                /* Fill: rgb(255 255 255) */

/* Color palette - same pattern */
fill-red-500              /* Example */
fill-[#1da1f2]            /* Arbitrary color */
```

## STROKE (SVG)

```
stroke-none               /* Stroke: none */
stroke-inherit            /* Stroke: inherit */
stroke-current            /* Stroke: currentColor */
stroke-transparent        /* Stroke: transparent */
stroke-black              /* Stroke: rgb(0 0 0) */
stroke-white              /* Stroke: rgb(255 255 255) */

/* Color palette - same pattern */
stroke-red-500            /* Example */
stroke-[#1da1f2]          /* Arbitrary color */
```

## GRADIENT COLOR STOPS

```
/* From color */
from-transparent          /* Gradient from transparent */
from-red-500              /* Gradient from red-500 */
from-[#1da1f2]            /* Gradient from arbitrary color */

/* Via color (middle) */
via-transparent           /* Gradient via transparent */
via-blue-500              /* Gradient via blue-500 */
via-[#1da1f2]             /* Gradient via arbitrary color */

/* To color */
to-transparent            /* Gradient to transparent */
to-green-500              /* Gradient to green-500 */
to-[#1da1f2]              /* Gradient to arbitrary color */
```

## COLOR OPACITY MODIFIERS

```
/* Add /opacity to any color utility */
text-blue-500/50          /* Text color blue-500 with 50% opacity */
bg-red-500/75             /* Background red-500 with 75% opacity */
border-green-500/25       /* Border green-500 with 25% opacity */

/* Available opacities: 0, 5, 10, 20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 95, 100 */
text-blue-500/[0.37]      /* Arbitrary opacity */
```