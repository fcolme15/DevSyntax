# TAILWIND BORDERS - Utility class reference

## BORDER WIDTH

```
border-0                  /* Border-width: 0px */
border                    /* Border-width: 1px (default) */
border-2                  /* Border-width: 2px */
border-4                  /* Border-width: 4px */
border-8                  /* Border-width: 8px */
border-[3px]              /* Border-width: Any value */

/* Individual sides */
border-x-2                /* Border left and right: 2px */
border-y-2                /* Border top and bottom: 2px */
border-t-2                /* Border top: 2px */
border-r-2                /* Border right: 2px */
border-b-2                /* Border bottom: 2px */
border-l-2                /* Border left: 2px */
```

## BORDER STYLE

```
border-solid              /* Border-style: solid */
border-dashed             /* Border-style: dashed */
border-dotted             /* Border-style: dotted */
border-double             /* Border-style: double */
border-hidden             /* Border-style: hidden */
border-none               /* Border-style: none */
```

## BORDER RADIUS

```
rounded-none              /* Border-radius: 0px */
rounded-sm                /* Border-radius: 0.125rem (2px) */
rounded                   /* Border-radius: 0.25rem (4px) */
rounded-md                /* Border-radius: 0.375rem (6px) */
rounded-lg                /* Border-radius: 0.5rem (8px) */
rounded-xl                /* Border-radius: 0.75rem (12px) */
rounded-2xl               /* Border-radius: 1rem (16px) */
rounded-3xl               /* Border-radius: 1.5rem (24px) */
rounded-full              /* Border-radius: 9999px (circle) */
rounded-[13px]            /* Border-radius: Any value */

/* Individual corners */
rounded-t-lg              /* Top left and right: 0.5rem */
rounded-r-lg              /* Top right and bottom right: 0.5rem */
rounded-b-lg              /* Bottom left and right: 0.5rem */
rounded-l-lg              /* Top left and bottom left: 0.5rem */

rounded-tl-lg             /* Top left: 0.5rem */
rounded-tr-lg             /* Top right: 0.5rem */
rounded-br-lg             /* Bottom right: 0.5rem */
rounded-bl-lg             /* Bottom left: 0.5rem */

/* Same sizing options for all corners: none, sm, (default), md, lg, xl, 2xl, 3xl, full */
```

## OUTLINE WIDTH

```
outline-0                 /* Outline-width: 0px */
outline-1                 /* Outline-width: 1px */
outline-2                 /* Outline-width: 2px */
outline-4                 /* Outline-width: 4px */
outline-8                 /* Outline-width: 8px */
outline-[3px]             /* Outline-width: Any value */
```

## OUTLINE STYLE

```
outline-none              /* Outline: 2px solid transparent, outline-offset: 2px */
outline                   /* Outline-style: solid */
outline-dashed            /* Outline-style: dashed */
outline-dotted            /* Outline-style: dotted */
outline-double            /* Outline-style: double */
```

## OUTLINE OFFSET

```
outline-offset-0          /* Outline-offset: 0px */
outline-offset-1          /* Outline-offset: 1px */
outline-offset-2          /* Outline-offset: 2px */
outline-offset-4          /* Outline-offset: 4px */
outline-offset-8          /* Outline-offset: 8px */
outline-offset-[3px]      /* Outline-offset: Any value */
```

## RING WIDTH

```
ring-0                    /* Box-shadow: 0 0 0 0px (no ring) */
ring-1                    /* Box-shadow: 0 0 0 1px */
ring-2                    /* Box-shadow: 0 0 0 2px */
ring                      /* Box-shadow: 0 0 0 3px (default) */
ring-4                    /* Box-shadow: 0 0 0 4px */
ring-8                    /* Box-shadow: 0 0 0 8px */
ring-[10px]               /* Box-shadow: 0 0 0 Any value */

ring-inset                /* Box-shadow: inset 0 0 0 ring-width */
```

## RING OFFSET WIDTH

```
ring-offset-0             /* Ring offset: 0px */
ring-offset-1             /* Ring offset: 1px */
ring-offset-2             /* Ring offset: 2px */
ring-offset-4             /* Ring offset: 4px */
ring-offset-8             /* Ring offset: 8px */
ring-offset-[3px]         /* Ring offset: Any value */
```

## DIVIDE WIDTH (between children)

```
divide-x-0                /* Horizontal divider: 0px */
divide-x                  /* Horizontal divider: 1px */
divide-x-2                /* Horizontal divider: 2px */
divide-x-4                /* Horizontal divider: 4px */
divide-x-8                /* Horizontal divider: 8px */
divide-x-[3px]            /* Horizontal divider: Any value */

divide-y-0                /* Vertical divider: 0px */
divide-y                  /* Vertical divider: 1px */
divide-y-2                /* Vertical divider: 2px */
divide-y-4                /* Vertical divider: 4px */
divide-y-8                /* Vertical divider: 8px */
divide-y-[3px]            /* Vertical divider: Any value */

divide-y-reverse          /* Reverse divide direction */
divide-x-reverse          /* Reverse divide direction */
```

## DIVIDE STYLE (between children)

```
divide-solid              /* Border-style: solid */
divide-dashed             /* Border-style: dashed */
divide-dotted             /* Border-style: dotted */
divide-double             /* Border-style: double */
divide-none               /* Border-style: none */
```

## DIVIDE COLOR (between children)

```
/* Same color palette as border-color */
divide-transparent        /* Divide color: transparent */
divide-black              /* Divide color: black */
divide-white              /* Divide color: white */
divide-red-500            /* Divide color: red-500 */
divide-[#1da1f2]          /* Divide color: Any value */
```