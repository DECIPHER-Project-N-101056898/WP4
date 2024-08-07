* Simulation for the Rational Expectation Model
* Initial values in the rational expectation model
Set    iter     /001*050/;
Scalar icounter /1/;

execute_unload '%path%\rational.gdx',  exo_pkav, iter_pk, PKAV_Report;

* Iterations in the rational expectation model
Loop(iter$(ord(iter) eq icounter),

* Unfix Lag Variables in each Iteration
A_KAVC.up(PR,ER,RTIME)       $(rtime.val>byear.val) = inf;
A_KAVC.lo(PR,ER,RTIME)       $(rtime.val>byear.val) = 0;

* Update after 1st iteration
if(icounter > 1,
execute_load   '%path%\rational.gdx', exo_pkav, iter_pk, PKAV_Report;
);

* Initial values in the model runs for each iteration
curyearp  = inityear;
an(rtime) = 0;

loop(bcl $((ord(bcl) eq curyearp-inityear+2) and (curyearp le endyearp)),
*  Set current year
an(rtime)$(ord(rtime) eq curyearp-inityear+2)=yes;

solve CGE_Maquette using mcp;

*  Fixing lagged value for next period
A_KAVC.FX(PR,ER,RTIME)       $(ord(RTIME) EQ CURYEARP-INITYEAR+2) = A_KAVC.L(pr,er,rtime);

*  Shift current year
   curyearp=curyearp+1;

*------------------------------------
* Starting Values for Next Period Run
*-------------------------------------
A_ENG.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = A_ENG.L(PR,ER,RTIME-1);
A_EXPO.L(BR,CR,CS,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)          = A_EXPO.L(BR,CR,CS,RTIME-1);
A_EXPOT.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)            = A_EXPOT.L(PR,ER,RTIME-1);
V_FC.L(SE,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = V_FC.L(SE,ER,RTIME-1);
V_FGRB.L(GV,PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)          = V_FGRB.L(GV,PR,ER,RTIME-1);
V_FSEFA.L(SE,FA,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)         = V_FSEFA.L(SE,FA,ER,RTIME-1);
V_FSEFAT.L(FA,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)           = V_FSEFAT.L(FA,ER,RTIME-1);
A_GC.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = A_GC.L(PR,ER,RTIME-1);
V_HCDTOT.L(ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = V_HCDTOT.L(ER,RTIME-1);
A_HCFV.L(FN,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)             = A_HCFV.L(FN,ER,RTIME-1);
A_HC.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = A_HC.L(PR,ER,RTIME-1);
A_IMP.L(PR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = A_IMP.L(PR,CR,RTIME-1);
A_IMPO.L(PR,CR,CS,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)          = A_IMPO.L(PR,CR,CS,RTIME-1);
V_INV.L(SE,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = V_INV.L(SE,ER,RTIME-1);
A_INVP.L(PR,BR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)          = A_INVP.L(PR,BR,ER,RTIME-1);
A_INV.L(BR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = A_INV.L(BR,ER,RTIME-1);
A_IO.L(PR,BR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)            = A_IO.L(PR,BR,ER,RTIME-1);
A_KAV.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = A_KAV.L(PR,ER,RTIME-1);
A_KAVC.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)             = A_KAVC.L(PR,ER,RTIME-1);
A_KL.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = A_KL.L(PR,ER,RTIME-1);
A_KLE.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = A_KLE.L(PR,ER,RTIME-1);
A_MA.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = A_MA.L(PR,ER,RTIME-1);
P_WPI.L(RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)                    = P_WPI.L(RTIME-1);
P_PD.L(BR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_PD.L(BR,CR,RTIME-1);
P_PDBSR.L(BR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)            = P_PDBSR.L(BR,ER,RTIME-1);
P_ENG.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = P_ENG.L(PR,ER,RTIME-1);
P_GC.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_GC.L(PR,ER,RTIME-1);
P_HC.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_HC.L(PR,ER,RTIME-1);
P_HCFV.L(FN,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)             = P_HCFV.L(FN,ER,RTIME-1);
P_IMP.L(PR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = P_IMP.L(PR,CR,RTIME-1);
P_INV.L(BR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = P_INV.L(BR,ER,RTIME-1);
P_INVP.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)             = P_INVP.L(PR,ER,RTIME-1);
P_IO.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_IO.L(PR,ER,RTIME-1);
P_KAV.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = P_KAV.L(PR,ER,RTIME-1);
P_KL.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_KL.L(PR,ER,RTIME-1);
P_KLE.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = P_KLE.L(PR,ER,RTIME-1);
P_KNAKM.L(ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_KNAKM.L(ER,RTIME-1);
P_KNOKM.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)            = P_KNOKM.L(PR,ER,RTIME-1);
P_MA.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_MA.L(PR,ER,RTIME-1);
P_PWE.L(PR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = P_PWE.L(PR,CR,RTIME-1);
P_IMPO.L(PR,CS,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)          = P_IMPO.L(PR,CS,CR,RTIME-1);
P_XD.L(PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = P_XD.L(PR,ER,RTIME-1);
P_Y.L(BR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)                = P_Y.L(BR,CR,RTIME-1);
RLTLR.L(ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)                 = RLTLR.L(ER,RTIME-1);
RLTLRWORLD.L(RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = RLTLRWORLD.L(RTIME-1);
V_SAVE.L(SE,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)             = V_SAVE.L(SE,ER,RTIME-1);
V_SURPL.L(SE,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)            = V_SURPL.L(SE,ER,RTIME-1);
V_VA.L(FA,PR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)            = V_VA.L(FA,PR,ER,RTIME-1);
V_VU.L(ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)                  = V_VU.L(ER,RTIME-1);
A_XD.L(PR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = A_XD.L(PR,CR,RTIME-1);
A_XXD.L(BR,ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)              = A_XXD.L(BR,ER,RTIME-1);
A_Y.L(PR,CR,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)                = A_Y.L(PR,CR,RTIME-1);
V_YDISP.L(ER,RTIME)$(ord(RTIME) eQ CURyearP-INITyear+2)               = V_YDISP.L(ER,RTIME-1);

P_L.l(er,rtime)$(ord(rtime) eq curyearp-inityear+2)                   = P_L.l(er,rtime-1);
P_LAV.l(pr,er,rtime)$(ord(rtime) eq curyearp-inityear+2)              = P_LAV.l(pr,er,rtime-1);
A_LAV.l(pr,er,rtime)$(ord(rtime) eq curyearp-inityear+2)              = A_LAV.l(pr,er,rtime-1);
P_HCFV.l(fn,er,rtime)$(ord(rtime) eq curyearp-inityear+2)             = P_HCFV.l(fn,er,rtime-1);
A_HCFVPV.l(pr,fn,er,rtime)$(ord(rtime) eq curyearp-inityear+2)        = A_HCFVPV.l(pr,fn,er,rtime-1);
P_EKAV.l(br,er,rtime)$(ord(rtime) eq curyearp-inityear+2)             = P_EKAV.l(br,er,rtime-1);
*----------------------------------------------------------------------------------------------------------------------*
   an(rtime)=no;
);
* main loop on time --------------------end
an(rtime)$(ord(rtime) ge 2 and ord(rtime) le curyearp-1-inityear+2) = yes;

* rational expectation loop --------------------end
PKAV_Report(report_iter,pr,reg,an)$(ord(report_iter) eq (iter_pk +1))
                                  = P_EKAV.l(pr,reg,an);

exo_pkav(pr,reg,rtime)$(rtime.val  <  2025) = P_KAV.l(pr,reg,rtime);
exo_pkav(pr,reg,rtime)$((rtime.val >= 2025) and (rtime.val < %finalyear%))
                      = P_KAV.l(pr,reg,rtime+1);
iter_pk  = iter_pk + 1;
icounter = icounter + 1;

execute_unload '%path%\rational.gdx', exo_pkav, iter_pk, PKAV_Report;
);
