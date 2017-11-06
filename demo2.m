function demo2
    % A more elaborate example illustrating fmsoptions, NumTrans, and the passing of data parameters
    % This example is written as a function to allow multiple sub-functions in the same file.

    % For this example, we will obtain maximum likelihood estimates of the shape and rate parameter of the
    % Gamma probability distribution, constraining the shape parameter to be an integer.

    % Randomly generate some data to which a Gamma will be fit:
    TrueShape = 7;
    TrueRate = 0.048;
    NObservations = 500;
    xdata = gamrnd(TrueShape,TrueRate,[NObservations,1]);

    % Define some desired options for passing to fminsearch:
    fmsoptions = optimset('Display','iter');

    x0parms = [2*TrueShape 2*TrueRate];
    [xparms2,fval2,exitflag2,output2] = fminsearcharb(@ErrFun,x0parms,@realstoparms,@parmstoreals,'ir',fmsoptions,xdata)

end

function parms = realstoparms(reals,~)
% Note that the ~ is used in the function definition to allow a second input parameter,
% even though it is not used here, because fminsearcharb passes parmcodes in case you want it.
parms(2) = NumTrans.Real2GT(0,reals(2));  % The rate parameter must be greater than 0.
parms(1) = NumTrans.Real2GT(1,reals(1));  % The shape parameter must be greater than 1.
end

function reals = parmstoreals(parms,~)
% Note that the ~ is used in the function definition to allow a second input parameter,
% even though it is not used here, because fminsearcharb passes parmcodes in case you want it.
reals(2) = NumTrans.GT2Real(0,parms(2));  % The rate parameter must be greater than 0.
reals(1) = NumTrans.GT2Real(1,parms(1));  % The shape parameter must be greater than 1.
end

function err = ErrFun(parms,mydatastruc)
    ln = gampdf(mydatastruc,parms(1),parms(2));
    err = -sum(log(ln));
end

