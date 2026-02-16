# TAILWIND EFFECTS - Utility class reference

## BOX SHADOW

```
shadow-sm                 /* Box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05) */
shadow                    /* Box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1) */
shadow-md                 /* Box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1) */
shadow-lg                 /* Box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1) */
shadow-xl                 /* Box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1) */
shadow-2xl                /* Box-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.25) */
shadow-inner              /* Box-shadow: inset 0 2px 4px 0 rgb(0 0 0 / 0.05) */
shadow-none               /* Box-shadow: 0 0 #0000 */
```

## SHADOW COLOR

```
shadow-inherit            /* Shadow color: inherit */
shadow-current            /* Shadow color: currentColor */
shadow-transparent        /* Shadow color: transparent */
shadow-black              /* Shadow color: black */
shadow-white              /* Shadow color: white */

/* Color palette - same pattern as other colors */
shadow-red-500            /* Shadow color: red-500 */
shadow-[#1da1f2]          /* Shadow color: Any value */
```

## DROP SHADOW

```
drop-shadow-sm            /* Filter: drop-shadow(0 1px 1px rgb(0 0 0 / 0.05)) */
drop-shadow               /* Filter: drop-shadow(0 1px 2px rgb(0 0 0 / 0.1)) drop-shadow(0 1px 1px rgb(0 0 0 / 0.06)) */
drop-shadow-md            /* Filter: drop-shadow(0 4px 3px rgb(0 0 0 / 0.07)) drop-shadow(0 2px 2px rgb(0 0 0 / 0.06)) */
drop-shadow-lg            /* Filter: drop-shadow(0 10px 8px rgb(0 0 0 / 0.04)) drop-shadow(0 4px 3px rgb(0 0 0 / 0.1)) */
drop-shadow-xl            /* Filter: drop-shadow(0 20px 13px rgb(0 0 0 / 0.03)) drop-shadow(0 8px 5px rgb(0 0 0 / 0.08)) */
drop-shadow-2xl           /* Filter: drop-shadow(0 25px 25px rgb(0 0 0 / 0.15)) */
drop-shadow-none          /* Filter: drop-shadow(0 0 #0000) */
```

## OPACITY

```
opacity-0                 /* Opacity: 0 */
opacity-5                 /* Opacity: 0.05 */
opacity-10                /* Opacity: 0.1 */
opacity-20                /* Opacity: 0.2 */
opacity-25                /* Opacity: 0.25 */
opacity-30                /* Opacity: 0.3 */
opacity-40                /* Opacity: 0.4 */
opacity-50                /* Opacity: 0.5 */
opacity-60                /* Opacity: 0.6 */
opacity-70                /* Opacity: 0.7 */
opacity-75                /* Opacity: 0.75 */
opacity-80                /* Opacity: 0.8 */
opacity-90                /* Opacity: 0.9 */
opacity-95                /* Opacity: 0.95 */
opacity-100               /* Opacity: 1 */
opacity-[0.37]            /* Opacity: Any value */
```

## MIX BLEND MODE

```
mix-blend-normal          /* Mix-blend-mode: normal */
mix-blend-multiply        /* Mix-blend-mode: multiply */
mix-blend-screen          /* Mix-blend-mode: screen */
mix-blend-overlay         /* Mix-blend-mode: overlay */
mix-blend-darken          /* Mix-blend-mode: darken */
mix-blend-lighten         /* Mix-blend-mode: lighten */
mix-blend-color-dodge     /* Mix-blend-mode: color-dodge */
mix-blend-color-burn      /* Mix-blend-mode: color-burn */
mix-blend-hard-light      /* Mix-blend-mode: hard-light */
mix-blend-soft-light      /* Mix-blend-mode: soft-light */
mix-blend-difference      /* Mix-blend-mode: difference */
mix-blend-exclusion       /* Mix-blend-mode: exclusion */
mix-blend-hue             /* Mix-blend-mode: hue */
mix-blend-saturation      /* Mix-blend-mode: saturation */
mix-blend-color           /* Mix-blend-mode: color */
mix-blend-luminosity      /* Mix-blend-mode: luminosity */
mix-blend-plus-lighter    /* Mix-blend-mode: plus-lighter */
```

## BACKGROUND BLEND MODE

```
bg-blend-normal           /* Background-blend-mode: normal */
bg-blend-multiply         /* Background-blend-mode: multiply */
bg-blend-screen           /* Background-blend-mode: screen */
bg-blend-overlay          /* Background-blend-mode: overlay */
bg-blend-darken           /* Background-blend-mode: darken */
bg-blend-lighten          /* Background-blend-mode: lighten */
bg-blend-color-dodge      /* Background-blend-mode: color-dodge */
bg-blend-color-burn       /* Background-blend-mode: color-burn */
bg-blend-hard-light       /* Background-blend-mode: hard-light */
bg-blend-soft-light       /* Background-blend-mode: soft-light */
bg-blend-difference       /* Background-blend-mode: difference */
bg-blend-exclusion        /* Background-blend-mode: exclusion */
bg-blend-hue              /* Background-blend-mode: hue */
bg-blend-saturation       /* Background-blend-mode: saturation */
bg-blend-color            /* Background-blend-mode: color */
bg-blend-luminosity       /* Background-blend-mode: luminosity */
```

## FILTERS

```
/* Blur */
blur-none                 /* Filter: blur(0) */
blur-sm                   /* Filter: blur(4px) */
blur                      /* Filter: blur(8px) */
blur-md                   /* Filter: blur(12px) */
blur-lg                   /* Filter: blur(16px) */
blur-xl                   /* Filter: blur(24px) */
blur-2xl                  /* Filter: blur(40px) */
blur-3xl                  /* Filter: blur(64px) */
blur-[2px]                /* Filter: blur(Any value) */

/* Brightness */
brightness-0              /* Filter: brightness(0) */
brightness-50             /* Filter: brightness(0.5) */
brightness-75             /* Filter: brightness(0.75) */
brightness-90             /* Filter: brightness(0.9) */
brightness-95             /* Filter: brightness(0.95) */
brightness-100            /* Filter: brightness(1) */
brightness-105            /* Filter: brightness(1.05) */
brightness-110            /* Filter: brightness(1.1) */
brightness-125            /* Filter: brightness(1.25) */
brightness-150            /* Filter: brightness(1.5) */
brightness-200            /* Filter: brightness(2) */
brightness-[1.75]         /* Filter: brightness(Any value) */

/* Contrast */
contrast-0                /* Filter: contrast(0) */
contrast-50               /* Filter: contrast(0.5) */
...                       /* Same values as brightness */
contrast-200              /* Filter: contrast(2) */
contrast-[1.75]           /* Filter: contrast(Any value) */

/* Grayscale */
grayscale-0               /* Filter: grayscale(0) */
grayscale                 /* Filter: grayscale(100%) */
grayscale-[50%]           /* Filter: grayscale(Any value) */

/* Hue Rotate */
hue-rotate-0              /* Filter: hue-rotate(0deg) */
hue-rotate-15             /* Filter: hue-rotate(15deg) */
hue-rotate-30             /* Filter: hue-rotate(30deg) */
hue-rotate-60             /* Filter: hue-rotate(60deg) */
hue-rotate-90             /* Filter: hue-rotate(90deg) */
hue-rotate-180            /* Filter: hue-rotate(180deg) */
-hue-rotate-180           /* Filter: hue-rotate(-180deg) */
hue-rotate-[75deg]        /* Filter: hue-rotate(Any value) */

/* Invert */
invert-0                  /* Filter: invert(0) */
invert                    /* Filter: invert(100%) */
invert-[50%]              /* Filter: invert(Any value) */

/* Saturate */
saturate-0                /* Filter: saturate(0) */
saturate-50               /* Filter: saturate(0.5) */
saturate-100              /* Filter: saturate(1) */
saturate-150              /* Filter: saturate(1.5) */
saturate-200              /* Filter: saturate(2) */
saturate-[1.75]           /* Filter: saturate(Any value) */

/* Sepia */
sepia-0                   /* Filter: sepia(0) */
sepia                     /* Filter: sepia(100%) */
sepia-[50%]               /* Filter: sepia(Any value) */
```

## BACKDROP FILTERS

```
/* Same utilities as filters, but with backdrop- prefix */
backdrop-blur-sm          /* Backdrop-filter: blur(4px) */
backdrop-brightness-50    /* Backdrop-filter: brightness(0.5) */
backdrop-contrast-100     /* Backdrop-filter: contrast(1) */
backdrop-grayscale        /* Backdrop-filter: grayscale(100%) */
backdrop-hue-rotate-90    /* Backdrop-filter: hue-rotate(90deg) */
backdrop-invert           /* Backdrop-filter: invert(100%) */
backdrop-saturate-100     /* Backdrop-filter: saturate(1) */
backdrop-sepia            /* Backdrop-filter: sepia(100%) */
```