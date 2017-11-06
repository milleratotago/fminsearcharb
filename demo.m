% Script to demonstrate fminsearcharb -- a small function allowing the use of fminsearch
% with constrained parameters.

% First, we will do a plain, unconstrained fminsearch:

% Here is the error function.
% It is easy to see that it is minimized by x=[4 5 6]
ErrFun = @(x)( sum( (x - [4.1 5.2 6.9]).^2) );

x0parms = [1 2 3];  % start search at parameter values [1 2 3]

[xparms1,fval1,exitflag1,output1] = fminsearch(ErrFun,x0parms)
% xparms1 should be [4 5 6]

% Now try fminsearcharb with some arbitrary constraints:

% The next pair of two functions define the constraints:

% This function maps all reals onto the constrained parameter space.
% For this example, the only constraint is that x(2) >= 5.2
realstoparms = @(x,~)( [x(1)  5.4+x(2)^2  x(3)] );
% Note that the ~ is used in the function definition to allow a second input parameter,
% even though it is not used here, because fminsearcharb passes parmcodes in case you want it.

% This function maps the constrained parameters back onto the space of all reals.
% It essentially "reverses" the constraints represented by the function realstoparms
parmstoreals = @(x,~)( [x(1)  sqrt(x(2))-5.2  x(3)] );
% Note that the ~ is used in the function definition to allow a second input parameter,
% even though it is not used here, because fminsearcharb passes parmcodes in case you want it.

% Now that we have defined the functions implementing the constraint
% and its reversal, we can call fminsearcharb to search under these constraints.

x0parms = [1 2 3];  % start at 1 2 3

[xparms2,fval2,exitflag2,output2] = fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals)
% xparms2 should be [4 5.2 6], which minimizes the error function under the constraint.

%% Next, let's constrain some of the parameters to be integers:

parmcodes='irr';  % parm1 must be an integer
[xparms2,fval2,exitflag2,output2] = fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals,parmcodes)

parmcodes='rri';  % parm3 must be an integer
[xparms2,fval2,exitflag2,output2] = fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals,parmcodes)

parmcodes='iri';  % parm1 & 3 must both be integers
[xparms2,fval2,exitflag2,output2] = fminsearcharb(ErrFun,x0parms,realstoparms,parmstoreals,parmcodes)

% A more advanced demo:
demo2;
