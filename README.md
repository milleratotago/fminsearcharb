# fminsearcharb
MATLAB function for minimizing an error function with constrained/integer/fixed parameters

[1]  Overview
------------------------

<div class="p">

</div>

fminsearcharb is a wrapper for calling MATLAB's fminsearch function
but constraining some of the parameters either numerically (e.g., to be within certain ranges),
or to be integers, or to be fixed (i.e., fminsearch should not adjust them).

<div class="p">

</div>

Users needing even more fine-grained control over individual subplots
can call the function SubplotTbl, which plots only one subplot within a
subplot-type figure.

<div class="p">

</div>

[2]  Requirements
----------------------------

<div class="p">

</div>

As far as I know, this will work with any version of MATLAB that has fminsearch.

