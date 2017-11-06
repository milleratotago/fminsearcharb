Overview
========

fminsearcharb is a wrapper function that allows MATLAB users to employ
fminsearch with constrained parameters. It was inspired by John
D’Errico’s fminsearchbnd and fminsearchcon, but it allows a bit more
flexibility with regard to parameter constraints (e.g., parameters can
be constrained to be integers).

Requirements
============

As far as I know, it should work with any version of MATLAB that
includes fminsearch.

License
=======

Copyright (C) 2017, Jeff Miller

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see http://www.gnu.org/licenses/

Syntax
======

fminsearcharb is called with one of these basic parameter
configurations:

-   xparms2 = fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals)

-   xparms2 =
    fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals,parmcodes)

-   xparms2 =
    fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals,parmcodes,fmsoptions)

-   xparms2 =
    fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals,parmcodes,fmsoptions,d1,d2,…)

-   \[xparms2,fval,exitflag,output\] =
    fminsearcharb(ErrFun,x0parms,…)

These are the input parameters (those marked \* are exactly the same as
in MATLAB’s fminsearch):

-   ErrFun\*: The error function to be minimized

-   x0parms\*: A vector of the starting values for each parameter

-   realstoparms: A function mapping a vector of any real numbers onto a
    set of parameter values satisfying your desired constraints. For
    further details, see section 5.

-   parmstoreals: A function which is the inverse of realstoparms (i.e.,
    maps your parameter values onto the full set of real numbers
    considered by fminsearch).

-   parmcodes: A list of characters—one per parameter—indicating whether
    each parameter is an adjustable real number, an adjustable integer,
    or fixed. For further details, see section 6.

-   fmsoptions\*: A set of options passed through to fminsearch.

-   d1,d2,…: Additional *data parameters* that are to be passed through
    to the ErrFunc

The output results are the same as those produced by MATLAB’s fminsearch
and are described in more detail in their documentation. In brief:

-   xparms2: best parameter values that were found

-   fval: minimum value found for ErrFun

-   exitflag: the reason for stopping, returned as an integer. 1 =
    converged, 0 = Too many iterations, -1 = terminated by output
    function.

-   output: structure holding information about the optimization process
    (e.g., number of iterations).

Constraints
===========

Example: Suppose you want to minimize an error function ErrFunc that
depends on parameters p1, p2, and p3. If p1, p2, and p3 can take on any
real number values, you can just use fminsearch. But suppose that there
are three constraints—for example:

-   [0 &lt; *p*1 &lt; 1]

-   [100 &lt; =*p*2]

-   [*p*3 &gt; =*p*1 + *p*2]

To use fminsearcharb, you must supply two functions that map back and
forth between the parameter ranges that you want and the full range of
real numbers that fminsearch considers.

One function, called “realstoparms”, maps from the range of all reals to
the range of the parameter space you want. For the above three example
constraints, this function could be:

    function [ xparms ] = realstoparms( xreals, ~ )
    % Example function to convert arbitrary reals to acceptable parm values
    % according to the constraints in the documentation.
    xparms = zeros(3,1);
    xparms(1) = abs(xreals(1)) / (1 + abs(xreals(1)));   % xparms(1) always between 0 and 1
    xparms(2) = 100 + xreals(2)^2;                       % xparms(2) always >= 100
    xparms(3) = xparms(1) + xparms(2) + xreals(3)^2;     % xparms(3) always >= xparms(1) + xparms(2)
    end

Note that the output values for this mapping function always satisfy the
desired constraints for any set of real numbers that fminsearch might
consider.

Of course you will have different constraints and so you must write a
different realstoparms function to implement those constraints. There
are almost always several different ways to write this function (i.e.,
different ways to “enforce the constraints”), and it is up to you to
choose the one that works best for your problem. (In my experience, it
doesn’t usually matter much.)

You must also write an inverse function, called “parmstoreals”, that
goes back from the range of your parameter space to the range of all
reals. For the realstoparms function given above, the reverse function
is:

    function [ xreals ] = parmstoreals( xparms, ~ )
    % Example function to convert acceptable parm values to arbitrary reals,
    % exactly reversing the mapping used by realstoparms
    xreals = zeros(3,1);
    xreals(1) = xparms(1) / (1 - xparms(1));              % Assume 0<xparms(1)<1
    xreals(2) = sqrt(xparms(2) - 100);                    % Assume xparms(2) >= 100
    xreals(3) = sqrt(xparms(3) - xparms(1) - xparms(2));  % Assume xparms(3) >= xparms(1) - xparms(2)
    end

Included with fminsearcharb is a class called NumTrans, which contains
some handy routines that can be used within realstoparms and
parmstoreals (see demo2.m for an example).

Here are several important points to remember about realstoparms and
parmstoreals:

-   Both functions must accept two input parameters. The first is the
    vector of parms or reals that is to be converted. The second is the
    parmcodes string (see section \[sec:parmcodes\]). This string is
    passed to these functions by fminsearcharb, so the functions must be
    able to accept the second parameter even if it is not used. (It is
    rarely a good idea to have realstoparms and parmstoreals check
    parmcodes, but once in a while it is essential.)

-   These functions should process *all* parameters, including any fixed
    ones.

-   These functions should process all parameters as real numbers and
    *not* attempt to force any parameters to be integers (e.g., by
    rounding). For example, if you want a parameter to be an integer
    greater than or equal to 1, realstoparms and parmstoreals should
    just make sure it is greater than 1, but not round it. Conversion to
    integers happens as part of the search process within fminsearcharb.
    Doing that conversion within realstoparms and parmstoreals will
    disrupt the search.

ParmCodes: Integer Parameters and Fixed Parameters
==================================================

fminsearcharb also allows you to constrain parameters in two other ways
besides those provided by realstoparms and parmstoreals: (a) You can
constrain the parameter value to be an integer, or (b) you can constrain
it to remained fixed. These constraints are specified by means of an
fminsearcharb calling parameter called “parmcodes”.

Parmcodes is a string with one character for each of the parameters that
is passed to your error function. Each character should be one of these
possibilities:

-   r: This parameter should be adjusted by fminsearch, and it can be
    any real number, subject to the constraints enforced by
    realstoparms.

-   i: This parameter should be adjusted by fminsearch, and it must be
    an integer, subject to the constraints enforced by realstoparms.

-   f: This parameter should not be adjusted by fminsearch.

Other Issues
============

All of the considerations involving function minimization (e.g., local
minima, multiple solutions) apply as usual, and these are sometimes
worsened if there are integer parameters.

The use of transformations can increase these problems and introduce
additional ones. For an excellent discussion of these issues, see the
document “Understanding fminsearchbnd” by John D’Errico in his
FMINSEARCHBND contribution to MATLAB File Exchange. The sections
“Multiple solutions due to the transformations” and “Starting values,
infeasible starting values, tolerances, etc.” are particularly relevant
to fminsearcharb.

Search Method With Integer Parameters
=====================================

For anyone who is curious, this section briefly describes
fminsearcharb’s method of searching for integer parameters. You don’t
need to read this section if you just want to use fminsearcharb.

fminsearch always tries real-valued parameters as candidates to minimize
ErrFun. So, for an integer parameter, fminsearcharb evaluates the error
function twice, once for each integer value above and below the current
real-valued candidate (which I admit may not be very efficient). For
example, if fminsearch wants to evaluate the candidate value of 6.25,
fminsearcharb evaluates the error function with floor(6.25)=6 and
ceil(6.25)=7. The overall error function computed for 6.25 (and returned
to fminsearch) is computed as the weighted average of the error
functions at 6 and 7, with weights of 0.75 and 0.25, respectively (6
gets the higher weight because 6.25 is closer to 6).

Note that this procedure always converges onto some integer as long as
two adjacent integers give different error values. For example, it will
go to 7 if ErrFun(6) [&gt;] ErrFun(7), because the
smallest weighted average error value is 0.0\*ErrFun(6)+1.00\*ErrFun(7).

Note also that this procedure naturally tries larger and smaller
integers as appropriate. For example, if ErrFun(6) [&gt;]
ErrFun(7), fminsearch might suggest a series of values like 6.25, 6.65,
6.90, 7.10, …. Once the candidate value of 7.10 is reached, the new
overall error will be the weighted average of ErrFun(7) and ErrFun(8),
so the function will “find” 8 if that is better than 7. And so on.

When searching with 2,3,… integer parameters, the same basic idea is
used in 2,3,… dimensions.
