# TAILWIND TYPOGRAPHY - Utility class reference

## FONT FAMILY

```
font-sans                 /* Sans-serif font stack */
font-serif                /* Serif font stack */
font-mono                 /* Monospace font stack */
```

## FONT STACKS
```
font-sans: ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"
font-serif: ui-serif, Georgia, Cambria, "Times New Roman", Times, serif
font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace
```

## FONT SIZE

```
text-xs                   /* Font-size: 0.75rem (12px), line-height: 1rem */
text-sm                   /* Font-size: 0.875rem (14px), line-height: 1.25rem */
text-base                 /* Font-size: 1rem (16px), line-height: 1.5rem */
text-lg                   /* Font-size: 1.125rem (18px), line-height: 1.75rem */
text-xl                   /* Font-size: 1.25rem (20px), line-height: 1.75rem */
text-2xl                  /* Font-size: 1.5rem (24px), line-height: 2rem */
text-3xl                  /* Font-size: 1.875rem (30px), line-height: 2.25rem */
text-4xl                  /* Font-size: 2.25rem (36px), line-height: 2.5rem */
text-5xl                  /* Font-size: 3rem (48px), line-height: 1 */
text-6xl                  /* Font-size: 3.75rem (60px), line-height: 1 */
text-7xl                  /* Font-size: 4.5rem (72px), line-height: 1 */
text-8xl                  /* Font-size: 6rem (96px), line-height: 1 */
text-9xl                  /* Font-size: 8rem (128px), line-height: 1 */
text-[14px]               /* Font-size: Any value */
```

## FONT WEIGHT

```
font-thin                 /* Font-weight: 100 */
font-extralight           /* Font-weight: 200 */
font-light                /* Font-weight: 300 */
font-normal               /* Font-weight: 400 */
font-medium               /* Font-weight: 500 */
font-semibold             /* Font-weight: 600 */
font-bold                 /* Font-weight: 700 */
font-extrabold            /* Font-weight: 800 */
font-black                /* Font-weight: 900 */
```

## FONT STYLE

```
italic                    /* Font-style: italic */
not-italic                /* Font-style: normal */
```

## TEXT COLOR

```
text-inherit              /* Color: inherit */
text-current              /* Color: currentColor */
text-transparent          /* Color: transparent */
text-black                /* Color: rgb(0 0 0) */
text-white                /* Color: rgb(255 255 255) */

/* Slate */
text-slate-50             /* Lightest slate */
...                       /* 100, 200, 300, 400, 500, 600, 700, 800, 900 */
text-slate-950            /* Darkest slate */

/* Gray, Zinc, Neutral, Stone - same pattern */
text-gray-500             /* Example: medium gray */
text-zinc-700             /* Example: dark zinc */

/* Red, Orange, Amber, Yellow, Lime, Green, Emerald, Teal, Cyan */
/* Blue, Indigo, Violet, Purple, Fuchsia, Pink, Rose */
/* All use 50-950 scale */
text-red-500              /* Example: medium red */
text-blue-600             /* Example: darker blue */
text-green-400            /* Example: lighter green */

/* Arbitrary color */
text-[#1da1f2]            /* Text color: Any hex/rgb/hsl value */
```

## TEXT ALIGNMENT

```
text-left                 /* Text-align: left */
text-center               /* Text-align: center */
text-right                /* Text-align: right */
text-justify              /* Text-align: justify */
text-start                /* Text-align: start */
text-end                  /* Text-align: end */
```

## TEXT DECORATION

```
underline                 /* Text-decoration: underline */
overline                  /* Text-decoration: overline */
line-through              /* Text-decoration: line-through */
no-underline              /* Text-decoration: none */
```

## TEXT DECORATION STYLE

```
decoration-solid          /* Text-decoration-style: solid */
decoration-double         /* Text-decoration-style: double */
decoration-dotted         /* Text-decoration-style: dotted */
decoration-dashed         /* Text-decoration-style: dashed */
decoration-wavy           /* Text-decoration-style: wavy */
```

## TEXT DECORATION THICKNESS

```
decoration-auto           /* Text-decoration-thickness: auto */
decoration-from-font      /* Text-decoration-thickness: from-font */
decoration-0              /* Text-decoration-thickness: 0px */
decoration-1              /* Text-decoration-thickness: 1px */
decoration-2              /* Text-decoration-thickness: 2px */
decoration-4              /* Text-decoration-thickness: 4px */
decoration-8              /* Text-decoration-thickness: 8px */
decoration-[3px]          /* Text-decoration-thickness: Any value */
```

## TEXT TRANSFORM

```
uppercase                 /* Text-transform: uppercase */
lowercase                 /* Text-transform: lowercase */
capitalize                /* Text-transform: capitalize */
normal-case               /* Text-transform: none */
```

## TEXT OVERFLOW

```
truncate                  /* Overflow: hidden, text-overflow: ellipsis, white-space: nowrap */
text-ellipsis             /* Text-overflow: ellipsis */
text-clip                 /* Text-overflow: clip */
```

## LINE HEIGHT

```
leading-3                 /* Line-height: 0.75rem (12px) */
leading-4                 /* Line-height: 1rem (16px) */
leading-5                 /* Line-height: 1.25rem (20px) */
leading-6                 /* Line-height: 1.5rem (24px) */
leading-7                 /* Line-height: 1.75rem (28px) */
leading-8                 /* Line-height: 2rem (32px) */
leading-9                 /* Line-height: 2.25rem (36px) */
leading-10                /* Line-height: 2.5rem (40px) */

leading-none              /* Line-height: 1 */
leading-tight             /* Line-height: 1.25 */
leading-snug              /* Line-height: 1.375 */
leading-normal            /* Line-height: 1.5 */
leading-relaxed           /* Line-height: 1.625 */
leading-loose             /* Line-height: 2 */
leading-[32px]            /* Line-height: Any value */
```

## LETTER SPACING

```
tracking-tighter          /* Letter-spacing: -0.05em */
tracking-tight            /* Letter-spacing: -0.025em */
tracking-normal           /* Letter-spacing: 0em */
tracking-wide             /* Letter-spacing: 0.025em */
tracking-wider            /* Letter-spacing: 0.05em */
tracking-widest           /* Letter-spacing: 0.1em */
tracking-[0.25em]         /* Letter-spacing: Any value */
```

## WORD SPACING

```
/* No default utilities, use arbitrary values */
[word-spacing:0.5rem]     /* Word-spacing: 0.5rem */
```

## TEXT INDENT

```
indent-0                  /* Text-indent: 0px */
indent-px                 /* Text-indent: 1px */
indent-0.5                /* Text-indent: 0.125rem */
...                       /* Uses spacing scale: 0.5, 1, 2, 4...96 */
indent-96                 /* Text-indent: 24rem */
indent-[50px]             /* Text-indent: Any value */
```

## VERTICAL ALIGN

```
align-baseline            /* Vertical-align: baseline */
align-top                 /* Vertical-align: top */
align-middle              /* Vertical-align: middle */
align-bottom              /* Vertical-align: bottom */
align-text-top            /* Vertical-align: text-top */
align-text-bottom         /* Vertical-align: text-bottom */
align-sub                 /* Vertical-align: sub */
align-super               /* Vertical-align: super */
```

## WHITESPACE

```
whitespace-normal         /* White-space: normal */
whitespace-nowrap         /* White-space: nowrap */
whitespace-pre            /* White-space: pre */
whitespace-pre-line       /* White-space: pre-line */
whitespace-pre-wrap       /* White-space: pre-wrap */
whitespace-break-spaces   /* White-space: break-spaces */
```

## WORD BREAK

```
break-normal              /* Word-break: normal, overflow-wrap: normal */
break-words               /* Overflow-wrap: break-word */
break-all                 /* Word-break: break-all */
break-keep                /* Word-break: keep-all */
```

## HYPHENS

```
hyphens-none              /* Hyphens: none */
hyphens-manual            /* Hyphens: manual */
hyphens-auto              /* Hyphens: auto */
```

## CONTENT (for ::before and ::after)

```
content-none              /* Content: none */
content-['text']          /* Content: 'text' */
```