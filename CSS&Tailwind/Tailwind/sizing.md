# TAILWIND SIZING - Utility class reference

## WIDTH

```
w-0                       /* Width: 0px */
w-px                      /* Width: 1px */
w-0.5                     /* Width: 0.125rem (2px) */
...                       /* Uses spacing scale: 0.5, 1, 2, 4...96 */
w-96                      /* Width: 24rem (384px) */
w-[350px]                 /* Width: Any value */

/* Fractions */
w-1/2                     /* Width: 50% */
w-1/3, w-2/3              /* Thirds */
w-1/4...w-3/4             /* Quarters */
w-1/5...w-4/5             /* Fifths */
w-1/6, w-5/6              /* Sixths */
w-1/12...w-11/12          /* Twelfths */

/* Full/screen/min/max/fit */
w-auto                    /* Width: auto */
w-full                    /* Width: 100% */
w-screen                  /* Width: 100vw */
w-min                     /* Width: min-content */
w-max                     /* Width: max-content */
w-fit                     /* Width: fit-content */
```

## HEIGHT

```
h-0                       /* Height: 0px */
h-px                      /* Height: 1px */
h-0.5                     /* Height: 0.125rem (2px) */
...                       /* Uses spacing scale: 0.5, 1, 2, 4...96 */
h-96                      /* Height: 24rem (384px) */
h-[350px]                 /* Height: Any value */

/* Fractions */
h-1/2                     /* Height: 50% */
h-1/3, h-2/3              /* Thirds */
h-1/4...h-3/4             /* Quarters */
h-1/5...h-4/5             /* Fifths */
h-1/6, h-5/6              /* Sixths */

/* Full/screen/min/max/fit */
h-auto                    /* Height: auto */
h-full                    /* Height: 100% */
h-screen                  /* Height: 100vh */
h-min                     /* Height: min-content */
h-max                     /* Height: max-content */
h-fit                     /* Height: fit-content */
```

## MIN-WIDTH

```
min-w-0                   /* Min-width: 0px */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
min-w-96                  /* Min-width: 24rem */
min-w-[200px]             /* Min-width: Any value */

min-w-full                /* Min-width: 100% */
min-w-min                 /* Min-width: min-content */
min-w-max                 /* Min-width: max-content */
min-w-fit                 /* Min-width: fit-content */
```

## MIN-HEIGHT

```
min-h-0                   /* Min-height: 0px */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
min-h-96                  /* Min-height: 24rem */
min-h-[200px]             /* Min-height: Any value */

min-h-full                /* Min-height: 100% */
min-h-screen              /* Min-height: 100vh */
min-h-min                 /* Min-height: min-content */
min-h-max                 /* Min-height: max-content */
min-h-fit                 /* Min-height: fit-content */
```

## MAX-WIDTH

```
max-w-0                   /* Max-width: 0rem */
max-w-xs                  /* Max-width: 20rem (320px) */
max-w-sm                  /* Max-width: 24rem (384px) */
max-w-md                  /* Max-width: 28rem (448px) */
max-w-lg                  /* Max-width: 32rem (512px) */
max-w-xl                  /* Max-width: 36rem (576px) */
max-w-2xl                 /* Max-width: 42rem (672px) */
max-w-3xl                 /* Max-width: 48rem (768px) */
max-w-4xl                 /* Max-width: 56rem (896px) */
max-w-5xl                 /* Max-width: 64rem (1024px) */
max-w-6xl                 /* Max-width: 72rem (1152px) */
max-w-7xl                 /* Max-width: 80rem (1280px) */

max-w-full                /* Max-width: 100% */
max-w-min                 /* Max-width: min-content */
max-w-max                 /* Max-width: max-content */
max-w-fit                 /* Max-width: fit-content */
max-w-prose               /* Max-width: 65ch */
max-w-screen-sm           /* Max-width: 640px */
max-w-screen-md           /* Max-width: 768px */
max-w-screen-lg           /* Max-width: 1024px */
max-w-screen-xl           /* Max-width: 1280px */
max-w-screen-2xl          /* Max-width: 1536px */
max-w-[500px]             /* Max-width: Any value */
```

## MAX-HEIGHT

```
max-h-0                   /* Max-height: 0px */
max-h-px                  /* Max-height: 1px */
max-h-0.5                 /* Max-height: 0.125rem */
...                       /* Uses spacing scale: 0.5, 1, 2, 4...96 */
max-h-96                  /* Max-height: 24rem */
max-h-[500px]             /* Max-height: Any value */

max-h-full                /* Max-height: 100% */
max-h-screen              /* Max-height: 100vh */
max-h-min                 /* Max-height: min-content */
max-h-max                 /* Max-height: max-content */
max-h-fit                 /* Max-height: fit-content */
```

## SIZE (width and height together)

```
size-0                    /* Width & height: 0px */
...                       /* Uses spacing scale: 0, px, 0.5, 1, 2, 4...96 */
size-96                   /* Width & height: 24rem */
size-[200px]              /* Width & height: Any value */

size-auto                 /* Width & height: auto */
size-full                 /* Width & height: 100% */
size-min                  /* Width & height: min-content */
size-max                  /* Width & height: max-content */
size-fit                  /* Width & height: fit-content */
```