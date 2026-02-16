# TAILWIND STATES - Utility class reference

## HOVER STATE

```
/* Apply utility on hover */
hover:bg-blue-500         /* Background blue-500 on hover */
hover:text-white          /* Text white on hover */
hover:scale-110           /* Scale 110% on hover */
hover:shadow-lg           /* Shadow large on hover */
hover:underline           /* Underline on hover */
hover:opacity-80          /* Opacity 80% on hover */

/* Works with any utility */
hover:{utility}           /* Apply any utility on hover */
```

## FOCUS STATE

```
/* Apply utility when element has focus */
focus:outline-none        /* No outline on focus */
focus:ring-2              /* Ring width 2 on focus */
focus:ring-blue-500       /* Ring blue-500 on focus */
focus:border-blue-500     /* Border blue-500 on focus */
focus:bg-gray-100         /* Background gray-100 on focus */

/* Works with any utility */
focus:{utility}           /* Apply any utility on focus */
```

## FOCUS-VISIBLE STATE

```
/* Only shows focus styles when keyboard navigating */
focus-visible:ring-2      /* Ring when keyboard focused */
focus-visible:outline-none /* No outline when keyboard focused */
```

## FOCUS-WITHIN STATE

```
/* Apply when element or child has focus */
focus-within:ring-2       /* Ring when element or child focused */
focus-within:border-blue-500 /* Border when element or child focused */
```

## ACTIVE STATE

```
/* Apply utility while element is being pressed/clicked */
active:bg-blue-700        /* Background blue-700 when active */
active:scale-95           /* Scale 95% when active */
active:translate-y-1      /* Translate down when active */

/* Works with any utility */
active:{utility}          /* Apply any utility when active */
```

## VISITED STATE

```
/* Apply utility to visited links */
visited:text-purple-600   /* Text purple-600 for visited links */
visited:underline         /* Underline visited links */
```

## DISABLED STATE

```
/* Apply utility when element is disabled */
disabled:opacity-50       /* Opacity 50% when disabled */
disabled:cursor-not-allowed /* Not-allowed cursor when disabled */
disabled:bg-gray-100      /* Background gray-100 when disabled */
disabled:pointer-events-none /* No pointer events when disabled */

/* Works with any utility */
disabled:{utility}        /* Apply any utility when disabled */
```

## ENABLED STATE

```
/* Apply utility when element is enabled */
enabled:hover:bg-blue-500 /* Hover background only when enabled */
```

## CHECKED STATE

```
/* Apply utility when checkbox/radio is checked */
checked:bg-blue-500       /* Background blue-500 when checked */
checked:border-blue-500   /* Border blue-500 when checked */
checked:text-white        /* Text white when checked */
```

## INDETERMINATE STATE

```
/* Apply utility when checkbox is indeterminate */
indeterminate:bg-gray-300 /* Background gray-300 when indeterminate */
```

## REQUIRED STATE

```
/* Apply utility when form field is required */
required:border-red-500   /* Border red-500 when required */
```

## INVALID STATE

```
/* Apply utility when form field is invalid */
invalid:border-red-500    /* Border red-500 when invalid */
invalid:text-red-600      /* Text red-600 when invalid */
```

## VALID STATE

```
/* Apply utility when form field is valid */
valid:border-green-500    /* Border green-500 when valid */
```

## PLACEHOLDER STATE

```
/* Apply utility to placeholder text */
placeholder:text-gray-400 /* Placeholder text gray-400 */
placeholder:italic        /* Placeholder italic */
placeholder:opacity-50    /* Placeholder opacity 50% */
```

## FIRST/LAST/ODD/EVEN CHILD

```
/* First child */
first:rounded-t-lg        /* First child rounded top */
first:border-t-0          /* First child no top border */

/* Last child */
last:rounded-b-lg         /* Last child rounded bottom */
last:border-b-0           /* Last child no bottom border */

/* Odd children */
odd:bg-white              /* Odd children white background */

/* Even children */
even:bg-gray-50           /* Even children gray background */
```

## ONLY CHILD

```
/* Apply when element is the only child */
only:py-4                 /* Padding when only child */
```

## FIRST/LAST OF TYPE

```
/* First of its type */
first-of-type:font-bold   /* First of type bold */

/* Last of its type */
last-of-type:mb-0         /* Last of type no margin-bottom */
```

## GROUP STATES

```
/* Apply utility based on parent with 'group' class */
/* Parent needs class="group" */

<div class="group">
  <div class="group-hover:text-blue-500">Turns blue when parent hovered</div>
</div>

group-hover:{utility}     /* Apply when parent with 'group' hovered */
group-focus:{utility}     /* Apply when parent with 'group' focused */
group-active:{utility}    /* Apply when parent with 'group' active */
```

## PEER STATES

```
/* Apply utility based on sibling with 'peer' class */
/* Sibling needs class="peer" */

<input type="checkbox" class="peer">
<div class="peer-checked:bg-blue-500">Changes when checkbox checked</div>

peer-hover:{utility}      /* Apply when sibling with 'peer' hovered */
peer-focus:{utility}      /* Apply when sibling with 'peer' focused */
peer-checked:{utility}    /* Apply when sibling with 'peer' checked */
peer-invalid:{utility}    /* Apply when sibling with 'peer' invalid */
peer-disabled:{utility}   /* Apply when sibling with 'peer' disabled */
```

## BEFORE/AFTER PSEUDO-ELEMENTS

```
/* Style ::before and ::after pseudo-elements */
before:content-['*']      /* ::before content */
before:block              /* ::before display block */
before:absolute           /* ::before position absolute */

after:content-['→']       /* ::after content */
after:ml-2                /* ::after margin-left */
```

## FILE INPUT

```
/* Style file input button */
file:mr-4                 /* File input button margin-right */
file:rounded-full         /* File input button rounded */
file:border-0             /* File input button no border */
file:bg-blue-500          /* File input button background */
file:text-white           /* File input button text white */
```

## MARKER (list markers)

```
/* Style list item markers */
marker:text-blue-500      /* Marker blue-500 */
marker:content-['→']      /* Custom marker content */
```

## SELECTION

```
/* Style text selection */
selection:bg-blue-200     /* Selection background blue-200 */
selection:text-blue-900   /* Selection text blue-900 */
```

## OPEN STATE

```
/* Apply when <details> or <dialog> is open */
open:bg-blue-50           /* Background when open */
```

## RTL/LTR

```
/* Right-to-left / Left-to-right */
rtl:text-right            /* Text right in RTL layout */
ltr:text-left             /* Text left in LTR layout */
```

## COMBINING STATES

```
/* Multiple states can be combined */
hover:focus:bg-blue-500   /* Background when hover AND focus */
group-hover:peer-checked:text-blue-500 /* Multiple parent/sibling states */
md:hover:bg-blue-500      /* Responsive + hover */
dark:hover:bg-gray-700    /* Dark mode + hover */
disabled:opacity-50 hover:disabled:opacity-50 /* Disabled overrides hover */
```

## ARBITRARY VARIANTS

```
/* Custom selectors */
[&:nth-child(3)]:bg-blue-500    /* 3rd child */
[&>*]:p-4                       /* Direct children */
[&_p]:text-gray-600             /* Descendant p elements */
```