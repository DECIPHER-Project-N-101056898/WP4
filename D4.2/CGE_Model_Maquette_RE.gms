*######################################################################################################################*
* Select the path of this file in your personal computer
$setglobal path         "D:\Projects\151_H2020_DECIPHER\05_Model\CGE_Maquette_RE\";
* Expectations in Investment: Myopic (=0) or Rational (=1) 
$setglobal sw_ratexp    "1"
* Capital Mobility: No capital mobility to PV and CON (=0) or Full (=1)
$setglobal sw_mobility  "1"
* Scenarios: Baseline (=0), Temporary Shock (=1), Permanent Shock (=2)
$setglobal sw_scen      "2"

$if %sw_ratexp% == "0" $if  %sw_mobility% == "1" $if  %sw_scen% == "0" $setglobal scenario   "Baseline_ME"
$if %sw_ratexp% == "1" $if  %sw_mobility% == "1" $if  %sw_scen% == "0" $setglobal scenario   "Baseline_RE"
$if %sw_ratexp% == "0" $if  %sw_mobility% == "0" $if  %sw_scen% == "0" $setglobal scenario   "Baseline_ME_PART"
$if %sw_ratexp% == "1" $if  %sw_mobility% == "0" $if  %sw_scen% == "0" $setglobal scenario   "Baseline_RE_PART"

$if %sw_ratexp% == "0" $if  %sw_mobility% == "1" $if  %sw_scen% == "1" $setglobal scenario   "ME_PV_30"
$if %sw_ratexp% == "1" $if  %sw_mobility% == "1" $if  %sw_scen% == "1" $setglobal scenario   "RE_PV_30"
$if %sw_ratexp% == "0" $if  %sw_mobility% == "0" $if  %sw_scen% == "1" $setglobal scenario   "ME_PV_30_PART"
$if %sw_ratexp% == "1" $if  %sw_mobility% == "0" $if  %sw_scen% == "1" $setglobal scenario   "RE_PV_30_PART"

$if %sw_ratexp% == "0" $if  %sw_mobility% == "1" $if  %sw_scen% == "2" $setglobal scenario   "ME_PV_ALL"
$if %sw_ratexp% == "1" $if  %sw_mobility% == "1" $if  %sw_scen% == "2" $setglobal scenario   "RE_PV_ALL"
$if %sw_ratexp% == "0" $if  %sw_mobility% == "0" $if  %sw_scen% == "2" $setglobal scenario   "ME_PV_ALL_PART"
$if %sw_ratexp% == "1" $if  %sw_mobility% == "0" $if  %sw_scen% == "2" $setglobal scenario   "RE_PV_ALL_PART"

* ------------------------------------------------------------------------------
Set
stime Set of Time /2019,2020,2025,2030,2035,2040,2045,2050/
;

Singleton Sets
byear(stime)     Base Year        /2020/
pbyear(stime)    Before Base Year /2019/
;

* ---------------------------------------------- Sectors ----------------------------------------------------------*
Sets
pr               Product classification
/
AGR Agriculture
ENE Energy
IND Industry
CON Construction
TRA Transport
SRV Services
PV  PV_equipment
/
;

* Singleton Sets for sectors
Singleton Sets
pr_agr(pr)       Agriculture    /AGR/
pr_ene(pr)       Energy         /ENE/
pr_ind(pr)       Industry       /IND/
pr_con(pr)       Construction   /CON/
pr_tra(pr)       Transport      /TRA/
pr_srv(pr)       Services       /SRV/
pr_pve(pr)       PV_equipment   /PV/
;

Sets
* Subsets
prfele(pr)       Energy products /ENE/
prma(pr)         All sectors without Energy products /AGR,IND,CON,TRA,SRV,PV/
;

Sets
* Regions
REG              All regions /R1 Region 1, R2 Region 2, R3 Region 3/
* Primary production factors 
fa               Primary production factors /CAP Capital, LAB Labour/
* Consumption Categories
fn               Consumption categories /01 Total/
* Institutional Transfers 
se               Institutional sectors (Households-Firms-Government-World) /H Household, F Firms, G Government, W External/
gv               Government revenue categories  /IT INDIRECT TAXES/
;

Alias
* Sectors
(pr,br,pr1,br1), (reg,reg1,reg2), (byear,byear1), (se,sr), (fn,fr), 
* Subsectors
(prfele, prfele1), (gv,gvb)
;

Scalar  Hours_per_Year      /8760/;


Parameters
gemcal_io_chk        (*,*,pr,reg)                   Calibration check parameter
* IO and Trade
gdpv                (reg,stime)                     GDP in volume
gdpu                (reg,stime)                     GDP in value 
beta                (pr,reg,reg1,stime)             Share coefficient in armington for substitution among regions
delta               (pr,reg,stime)                  Share coefficient in armington for substitution between domestic - imported
ac                  (pr,reg,stime)                  Scale coefficient in armington for substitution between domestic - imported
* Labour
lh                  (br,reg,stime)                  Hours worked 
totlabfrc           (reg,stime)                     total labour force

* Private Consumption
stp                 (reg,stime)                     Social time preference
hcfpv               (pr,fn,reg,stime)               Volume of consumption matrix
thcfv               (pr,fn,reg,stime)               Coefficients of consumption matrix
tsave               (reg,stime)                     Savings ratio
hcf                 (pr,fn,reg,stime)               Normalised consumption matrix
hcfu                (pr,fn,reg)                     Initial consumption matrix in value
hcbse               (fn,reg,stime)                  Share of fn in hcndtot (cal)
eehca               (fn,reg,stime)                  Income elasticity consumption category (calibration)
bhcfv               (fn,reg,stime)                  Les (lower level) consumption category share parameter
chcfv               (fn,reg,stime)                  Les (lower level) obliged consumption (in volume)
str                 (reg,stime)                     Social time preference relative to rltlr (cal)

* Public Consumption
gctv                (reg,stime)                     Public consumption in b.$
tgcv                (pr,reg,stime)                  Share of branch in delivery to public consumption

* Capital and investment
stgr               (br,reg,stime)                   Growth expectation in investment function
exp_stgr           (pr,reg,stime)                   Expected growth rate
tinvpv             (pr,br,reg,stime)                Share of branch in delivery to investment
a0inv              (pr,reg,stime)                   Scale parameter of investment function
a1inv              (pr,reg,stime)                   Elasticity delay parameter in investment function
decl               (pr,reg,stime)                   Depreciation rate (sectors)
tcinv              (se,reg,stime)                   Investment Financing

* Institutional Transfers
txfsefa            (se,fa,reg,stime)               Share of agents in factor income

* Taxes
txit               (pr,reg,stime)                  Indirect tax

* Elasticities
sn0                (pr,reg,stime)                  Elasticity of substitution between Crude Oil Reserves & KLEM bundle
sn1                (pr,reg,stime)                  Elasticity of substitution between KLE and MA
sn2                (pr,reg,stime)                  Elasticity of substitution between KL and ENG
sn3                (pr,reg,stime)                  Elasticity of substitution between intermediate goods
sn4                (pr,reg,stime)                  Elasticity of substitution between (Capital and Skilled) with Unskilled Labour
sn5                (pr,reg,stime)                  Elasticity of substitution between energy products and electricity
sninv              (pr,reg,stime)                  Elasticity of substitution for investment
sigmax             (pr,reg,stime)                  Substitution elasticity in armington between domestic and imports
sigmai             (pr,reg,stime)                  Substitution elasticity in armington among countries

* technical progress
tgk                (pr,reg,stime)                  Technical progress on capital (cumulated rate)
tgl                (pr,reg,stime)                  Technical progress on labour by skill type
tge                (pr,br,reg,stime)               Technical progress on energy (cumulated rate)
tgm                (pr,br,reg,stime)               Technical progress on materials (cumulated rate)
tfpexo             (pr,reg,stime)                  Exogenous total factor productivity
tfp                (pr,reg,stime)                  Total factor productivity

* Numeraire
price_index        (stime)                          World price index
gdp_growth         (stime)                          World GDP growth index
Numeraire          (stime)                          Numeraire

* Value share in production function
theta_dkle         (pr,reg,stime)                  Value share of KLE bundle in production
theta_dma          (pr,reg,stime)                  Value share of Materials  in production
theta_dio          (pr,br,reg,stime)               Value share of intermediate inputs in production
theta_deng         (pr,reg,stime)                  Value share of ENG in KLE bundle
theta_dkl          (pr,reg,stime)                  Value share of KL in KLE bundle
theta_dkav         (pr,reg,stime)                  Value share of Capital in KL bundle 
theta_dlav         (pr,reg,stime)                  Value share of Labour in KL bundle 
theta_dmpr         (pr,br,reg,stime)               Value share of intermediate inputs in MA bundle
theta_depr         (pr,br,reg,stime)               Value share of energy inputs in ENG bundle

* Switches
swonkm             (pr,reg,stime)                  Switch for capital mobility

* Base year values for Activities
a_invp0            (pr,br,reg)                     Base year value of deliveries to Investment
a_inv0             (pr,reg)                        Base year value of Investment by branch
a_xd0              (pr,reg,stime)                  Benchmark production by branch
a_kl0              (pr,reg,stime)                  Benchmark capital labour bundle
a_kle0             (pr,reg,stime)                  Benchmark production by branch
a_ma0              (pr,reg,stime)                  Benchmark demand of materials by branch
a_eng0             (pr,reg,stime)                  Benchmark demand of energy by branch
a_io0              (pr,br,reg,stime)               Benchmark input output table in volume
a_kav0             (pr,reg,stime)                  Benchmark capital stock
a_lav0             (pr,reg,stime)                  Benchmark labour demand in hours by skill type

a_hcfv0            (fn,reg)                        Benchmark household consumption by purpose
a_hc0              (br,reg)                        Benchmark household consumption by product
a_hcfvpv0          (pr,fn,reg)                     Benchmark household consumption by product and by purpose

* Base year values for Prices
p_pwe0             (pr,reg)                        Base year value of unit cost of Export
p_inv0             (pr,reg)                        Base year value of unit cost of Investment
p_invp0            (pr,reg)                        Base year value of unit cost of deliveries to Investment
p_wpi0                                             Base year value of price index for taxes and subsidies at quantum (numeraire)

p_pd0              (pr,reg,stime)                  Base year value of unit cost of production corrected for Permit Endowment
p_pdbsr0           (pr,reg,stime)                  Base year value of unit cost of Production
p_kle0             (pr,reg,stime)                  Benchmark unit cost of KLE bundle
p_ma0              (pr,reg,stime)                  Benchmark unit cost of materials
p_kav0             (pr,reg,stime)                  Benchmark unit cost of Capital
p_io0              (pr,reg,stime)                  Benchmark unit cost of intermediate inputs
p_eng0             (pr,reg,stime)                  Benchmark unit cost of ENG bundle
p_kl0              (pr,reg,stime)                  Benchmark unit cost of KL bundle
p_y0               (pr,reg,stime)                  Benchmark unit cost of domestic demand
p_lav0             (pr,reg,stime)                  Benchmark unit cost of Labour by skill type

p_hc0              (pr,reg)                        Benchmark price of household consumption
p_hcfv0            (fn,reg)                        Benchmark price of private consumption category
p_gc0              (pr,reg)                        Benchmark price of government consumption

* Checks
check_XXD          (pr,reg)                        Check for negative values in domestic production
check_LAV          (pr,reg,stime)                  Check for Labour
check_theta        (*,pr,reg,stime)                Check that value share sum to one
check_Income       (pr,reg,stime)                  Check Income
testHCDTOT         (reg,stime)
errhcdt            (reg,stime)

* Time
ttime              (stime)                         Period Index
ttime1             (stime)                         Time+Period Index

* Parameters used to store reference values
cash               (reg,stime)                     Current account as share in gdp
pdsh               (reg,stime)                     Surplus of government as percentage of total value added  in $
*--------------------------------------------------
exo_investements   (pr,reg,stime)                  Exogenous Investments
public_gc          (pr,reg,stime)                  Exogenous Governement Consumption 
;

* Expected Price of Capital
Sets
report_iter /000*100/
;

Parameters
iter_pk  /0/
exo_pkav(pr,reg,stime)
PKAV_Report(report_iter,pr,reg,stime)
;

exo_pkav(pr,reg,stime) = 0;
PKAV_Report("000",pr,reg,stime) = 0;


Variables
* Activities
A_YVST              (pr,stime)                      Internation transport services                - activity
A_XD                (pr,reg,stime)                  Production                                    - activity
A_XXD               (pr,reg,stime)                  Deliveries to Domestic Market                 - activity
A_EXPO              (pr,reg,reg1,stime)             Bilateral Exports by branch                   - activity
A_EXPOT             (pr,reg,stime)                  Total Exports by branch                       - activity
A_IMPO              (pr,reg,reg1,stime)             Bilateral Imports by branch                   - activity
A_IMP               (pr,reg,stime)                  Imports                                       - activity
A_Y                 (pr,reg,stime)                  Domestic Demand                               - activity
A_IO                (pr,br,reg,stime)               IO Deliveries among branches                  - activity
A_HC                (pr,reg,stime)                  Deliveries to Private Consumption by branch   - activity
A_GC                (pr,reg,stime)                  Deliveries to Public Consumption by branch    - activity
A_INVP              (pr,br,reg,stime)               Deliveries for Investment by branch           - activity
A_LAV               (pr,reg,stime)                  Demand for labor                              - activity
A_KAV               (pr,reg,stime)                  Demand for capital                            - activity
A_INV               (pr,reg,stime)                  Investment by branch                          - activity
A_KAVC              (pr,reg,stime)                  Capital stock by branch at the beginning of the period  - activity
A_ENG               (pr,reg,stime)                  Energy demand                                 - activity
A_MA                (pr,reg,stime)                  Demand of Materials                           - activity
A_KL                (pr,reg,stime)                  Capital Labour bundle                         - activity
A_KLE               (pr,reg,stime)                  Capital- Labour - Energy bundle               - activity
A_HCFV              (fn,reg,stime)                  Household consumption by purpose              - activity
A_HCFVPV            (pr,fn,reg,stime)               Consumption matrix                            - activity
A_POPV              (reg,stime)                     Total labour force (hours) by skill type      - activity

* Prices
P_PD                (pr,reg,stime)                  Unit cost of Production corrected for Permit Endowment  - price ($ per unit of output)
P_XD                (pr,reg,stime)                  Unit cost of production                                 - price ($ per unit of output)
P_PDBSR             (pr,reg,stime)                  Unit cost of Production (from dual production function) - price ($ per unit of output)
P_PWE               (pr,reg,stime)                  Unit cost of Export in international currency           - price ($ per unit of output)
P_IMPO              (pr,reg,reg1,stime)             Unit cost of Bilateral Imports                          - price ($ per unit of output)
P_IMP               (pr,reg,stime)                  Unit cost of Imports incl. duties and trans. costs      - price ($ per unit of imports)
P_Y                 (pr,reg,stime)                  Unit cost of Domestic Demand                            - price ($ per unit of output)
P_IO                (pr,reg,stime)                  Delivery Price in Intermediate Demand                   - price ($ per unit of output)
P_HC                (pr,reg,stime)                  Unit cost of delivery to Private Consumption            - price ($ per unit of output)
P_GC                (pr,reg,stime)                  Unit cost of delivery to Public Consumption             - price ($ per unit of output)
P_INVP              (pr,reg,stime)                  Unit cost of Deliveries to Investment                   - price ($ per unit of output)
P_LAV               (pr,reg,stime)                  Unit cost of Labor by sector                            - price ($ per working hour)
P_L                 (reg,stime)                     Unit cost of Labor                                      - price ($ per working hour)
P_KAV               (pr,reg,stime)                  Uner Cost of Capital                                    - price ($ per unit of capital)
P_KNOKM             (pr,reg,stime)                  User Cost of Capital (no mobility)                      - price ($ per unit of capital)
P_KNAKM             (reg,stime)                     User Cost of Capital (mobility among branches)          - price ($ per unit of capital)
P_INV               (pr,reg,stime)                  Unit cost of Investment                                 - price ($ per unit of output)
P_ENG               (pr,reg,stime)                  Unit cost of energy                                     - price ($ per unit of output)
P_MA                (pr,reg,stime)                  Unit cost of Material Aggregate                         - price ($ per unit of output)
P_KL                (pr,reg,stime)                  Unit cost of Capital Labour bundle                      - price ($ per unit of output)
P_KLE               (pr,reg,stime)                  Unit cost of Capital- Labour - Energy bundle            - price ($ per unit of output)
P_HCFV              (fn,reg,stime)                  Unit cost of Private Consumption Category               - price
P_WPI               (stime)                         World Price Index                                       - price

* Values
V_FGRB              (gv,pr,reg,stime)               Government revenues                           - accounting item (value)
V_FSEFA             (se,fa,reg,stime)               Payments by Factors to Sectors                - accounting item (value)
V_FSEFAT            (fa,reg,stime)                  Total Payments by Factors                     - accounting item (value)
V_FC                (se,reg,stime)                  Consumption by Sector                         - accounting item (value)
V_YDISP             (reg,stime)                     Disposable Income                             - accounting item (value)
V_VA                (fa,pr,reg,stime)               Value Added by Factor and Branch              - accounting item (value)
V_VU                (reg,stime)                     GDP at factor prices (nominal)                - accounting item (value)
V_SAVE              (se,reg,stime)                  Savings by institutional sector               - accounting item (value)
V_INV               (se,reg,stime)                  Investment by institutional sector            - accounting item (value)
V_SURPL             (se,reg,stime)                  Surplus or deficit by institutional sector    - accounting item (value)
V_HCDTOT            (reg,stime)                     Total household consumption in value          - accounting item (value)

* Rates - Shares - Taxes
RLTLR               (reg,stime)                     Real Interest Rate
RLTLRWORLD          (stime)                         World closure

* Expected Unit Cost of Capital
P_EKAV              (pr,reg,stime)                  Expected unit cost of capital
;

*######################################################################################################################*
* Loading Data 
* --------------------------------------------  PARAMETERS from Databases ---------------------------------------------*
Parameters
* ------------------------------------------------- IO and Trade ------------------------------------------------------*
CAL_indc(pr,br,reg)                   Value of Intermediate Consumption                    
CAL_hc(pr,reg)                        Value of Household Consumption                       
CAL_gc(pr,reg)                        Value of Government Consumption                      
CAL_inv_v(pr,reg)                     Investment by product                                
CAL_exprts(pr,reg)                    Value of Exports                                     
CAL_vstexp(pr,reg)                    Value of Export Transport Sales                      
CAL_cap(pr,reg)                       Value of Operating surplus                           
CAL_lab(pr,reg)                       Value of Compensation of employees                   
CAL_tax(pr,reg)                       Value of Indirect Taxes                              
CAL_imprts(pr,reg)                    Value of Imports (FOB)                               
CAL_expbil(pr,reg,reg1)               Value of Bilateral Exports                           
* --------------------------------------- Institutional Transfers  ----------------------------------------------------*
CAL_inst_fsefa               (se,fa,reg)               Payments by Factors to Sectors
CAL_inst_fgrb                (gv,pr,reg)               Payments by Branches to Public Sector
CAL_sh_fsefau                (se,fa,reg)               Share by sector of factor payments
CAL_inst_fsefat              (fa,reg)                  Total Payments by Factors
* ------------------------------------------- Labour Market -----------------------------------------------------------*
CAL_lh               (pr,reg)               Hours worked
CAL_lab_frc_tot      (reg)                  Total Labour Force in number thousands of persons
* ---------------------------------------- Capital and Investment -----------------------------------------------------*
CAL_rltlr            (reg)                  Real Interest rate
CAL_a0inv            (pr,reg)               Scale parameter of investment function
CAL_a1inv            (pr,reg)               Elasticity delay parameter in investment function
CAL_decl             (pr,reg)               Depreciation rate (sectors)
CAL_Capital_Stock    (pr,reg)               Capital Stock
CAL_tcinv            (se,reg)               Investment Financing
* ------------------------------------------- Investment Matrix -------------------------------------------------------*
CAL_invm             (pr,br,reg)            Investment matrix                                 
* ---------------------------------------- Production Prices ----------------------------------------------------------*
CAL_PD               (pr,reg)               Production prices

* ------------------------------------------ Elasticities -------------------------------------------------------------*
CAL_sn0              (pr,reg)               Elasticity of substitution between Crude Oil Reserves & KLEM bundle
CAL_sn1              (pr,reg)               Elasticity of substitution between KLE and MA
CAL_sn2              (pr,reg)               Elasticity of substitution between KL and ENG
CAL_sn3              (pr,reg)               Elasticity of substitution between intermediate goods
CAL_sn4              (pr,reg)               Elasticity of substitution between (Capital and Skilled) with Unskilled Labour
CAL_sn5              (pr,reg)               Elasticity of substitution between energy products and electricity
CAL_sninv            (pr,reg)               Elasticity of substitution for investment
CAL_sigmax           (pr,reg)               Substitution elasticity in armington between domestic and imports
CAL_sigmai           (pr,reg)               Substitution elasticity in armington among countries
* ------------------------------------------- Consumption Matrix ------------------------------------------------------*
CAL_hcfu             (pr,fn,reg)            Consumption matrix (extended)                       
* ----------------------------------------------- Consumption ---------------------------------------------------------*
CAL_frisch           (reg)                  Frisch parameter used in households calibration
CAL_eehc             (fn,reg)               Income elasticity consumption category (data)
* Production
CAL_prod             (pr,reg)               Production
;

* ---------------------------------------------- Load Data -------------------------------------------------*
$call  gdxxrw i=%path%\CGE_Model_Data.xlsx  o=%path%\CGE_Model_Data.gdx index=index!a1:f100
$gdxin %path%\CGE_Model_Data.gdx
* IO and Trade
$load    CAL_indc     CAL_hc       CAL_gc       CAL_inv_v    CAL_exprts
$load    CAL_cap      CAL_lab      CAL_tax      CAL_imprts   CAL_expbil   
* Labour Market
$load    CAL_lh                  
$load    CAL_lab_frc_tot
* Income
$load    CAL_inst_fsefa         
* Capital and Investment
$load    CAL_decl                CAL_a0inv            CAL_a1inv
$load    CAL_Capital_Stock       CAL_rltlr
$load    CAL_invm
$load    CAL_tcinv
* Production Prices
$load    CAL_PD
* Elasticities
$load    CAL_sn0          CAL_sn1          CAL_sn2          CAL_sn3
$load    CAL_sn4          CAL_sn5
$load    CAL_sninv        
$load    CAL_sigmax       CAL_sigmai
* Consumption Matrix & Data
$load    CAL_hcfu
$load    CAL_frisch       CAL_eehc
$gdxin

*-----------------------------------------------------------------------------------------------------------------------
*Hours Worked
lh(br,reg,byear) = CAL_lh(br,reg);
* Production value (excl. taxes)
CAL_prod(br,reg) = sum(pr, CAL_indc(pr,br,reg)) + CAL_cap(br,reg) + CAL_lab(br,reg);
* Investment
a0inv(pr,reg,byear)      = CAL_a0inv(pr,reg);
a1inv(pr,reg,byear)      = CAL_a1inv(pr,reg);
decl(pr,reg,byear)       = CAL_decl(pr,reg) ;
* Elasticities
sn0(pr,reg,byear)        = CAL_sn0(pr,reg)   ;
sn1(pr,reg,byear)        = CAL_sn1(pr,reg)   ;
sn2(pr,reg,byear)        = CAL_sn2(pr,reg)   ;
sn3(pr,reg,byear)        = CAL_sn3(pr,reg)   ;
sn4(pr,reg,byear)        = CAL_sn4(pr,reg)   ;
sn5(pr,reg,byear)        = CAL_sn5(pr,reg)   ;
sninv(pr,reg,byear)      = CAL_sninv(pr,reg) ;
sigmax(pr,reg,byear)     = CAL_sigmax(pr,reg);
sigmai(pr,reg,byear)     = CAL_sigmai(pr,reg);

* Payments by Branches to Public Sector
CAL_inst_fgrb("IT",pr,reg)  = CAL_tax(pr,reg);

* ------------------------------------ Income Distribution ------------------------------------------------------------*
* Factor payments
CAL_inst_fsefat("cap",reg)  = sum(pr, CAL_cap(pr,reg));
CAL_inst_fsefat("lab",reg)  = sum(pr, CAL_lab(pr,reg));

* ---------------------------------------------------------------------------------------------------------------------*
* Investment Financing (share by sector of financing of investments)
tcinv(se,reg,byear)    = CAL_tcinv(se,reg);

*-------------------------------------------
*Exogenous investments
exo_investements(pr,reg,stime)      = 0;


*######################################################################################################################*
*                                        CALIBRATION OF THE MODEL                                                      *
*----------------------------------------------------------------------------------------------------------------------*
* Governement Taxes
V_FGRB.l(gv,pr,reg,byear) = CAL_inst_fgrb(gv,pr,reg);

* Real Interest rate
RLTLR.L(reg,byear)        = CAL_rltlr(reg);

*----------------------------------------------------------------------------------------------------------------------*
* Use of the Harberger convention to set prices
P_PD.l(pr,reg,byear)      = CAL_PD(pr,reg);

*----------------------------------------------------------------------------------------------------------------------*
* Total Production
P_PDBSR.l(pr,reg,byear)  = P_PD.l(pr,reg,byear);
A_XD.l(pr,reg,byear)     = CAL_prod(pr,reg)/P_PD.l(pr,reg,byear);

* Sale price including subsidies
P_PWE.l(pr,reg,byear)    = P_PD.l(pr,reg,byear);
P_XD.l(pr,reg,byear)     = P_PD.l(pr,reg,byear);

*----------------------------------------------------------------------------------------------------------------------*
* Trade
* Volume of Bilateral Exports
A_EXPO.l(pr,reg,reg1,byear)      = CAL_expbil(pr,reg,reg1)/P_PWE.l(pr,reg,byear);
A_EXPOT.l(pr,reg,byear)          = sum(reg1, A_EXPO.l(pr,reg,reg1,byear));
A_IMPO.l(pr,reg1,reg,byear)      = A_EXPO.l(pr,reg,reg1,byear);

*----------------------------------------------------------------------------------------------------------------------*
*                                        Production for domestic consumption
*----------------------------------------------------------------------------------------------------------------------*
A_XXD.l(br,reg,byear)     = A_XD.l(br,reg,byear) - A_EXPOT.l(br,reg,byear);

check_XXD(br,reg)$(A_XXD.l(br,reg,byear) lt 0) = 1;
abort$(smax((br,reg), abs(check_XXD(br,reg))) gt 1e-4) "Negative production for domestic consumption", check_XXD;

*----------------------------------------------------------------------------------------------------------------------*
* Total Imports
A_IMP.l(pr,reg,byear)$sum(reg1, A_IMPO.l(pr,reg,reg1,byear))
                     =  CAL_imprts(pr,reg)/(sum(reg1,P_PWE.l(pr,reg1,byear)*A_IMPO.l(pr,reg,reg1,byear))/
                                            sum(reg1,A_IMPO.l(pr,reg,reg1,byear))                      );
* Unit cost of Bilateral Imports
P_IMPO.l(pr,reg,reg1,byear) = P_PWE.l(pr,reg1,byear);

* Unit cost of Imports
P_IMP.l(pr,reg,byear) = (sum(reg1, P_IMPO.l(pr,reg,reg1,byear) * A_IMPO.l(pr,reg,reg1,byear))
                               /   A_IMP.l(pr,reg,byear));
                               
* Calibration of armington coefficient (share among regions)
beta(br,reg,reg1,byear) = (((A_IMPO.l(br,reg,reg1,byear)/(A_IMP.l(br,reg,byear)))**(1/(sigmai(br,reg,byear))))
                         / (P_IMP.l(br,reg,byear)/P_IMPO.l(br,reg,reg1,byear)));

* Composite Goods
A_Y.l(br,reg,byear)     = A_XXD.l(br,reg,byear)  + A_IMP.l(br,reg,byear);

P_Y.l(pr,reg,byear)     =  (P_IMP.l(pr,reg,byear) * A_IMP.l(pr,reg,byear)
                           +P_XD.l(pr,reg,byear)  * A_XXD.l(pr,reg,byear)
                           )/A_Y.l(pr,reg,byear)
;

delta(pr,reg,byear) =  P_IMP.l(pr,reg,byear)/P_XD.l(pr,reg,byear)
                         *(A_IMP.l(pr,reg,byear)/A_XXD.l(pr,reg,byear))**(1/sigmax(pr,reg,byear))
                      /(1+(P_IMP.l(pr,reg,byear)/P_XD.l(pr,reg,byear)
                         *(A_IMP.l(pr,reg,byear)/A_XXD.l(pr,reg,byear))**(1/sigmax(pr,reg,byear))));

ac(pr,reg,byear)  =
 (
    (
       delta(pr,reg,byear)**sigmax(pr,reg,byear)*P_IMP.l(pr,reg,byear)**(1-sigmax(pr,reg,byear))
                         + (1-delta(pr,reg,byear))**(sigmax(pr,reg,byear))*P_XD.l(pr,reg,byear)
                         **(1-sigmax(pr,reg,byear)) )**(1/(1-sigmax(pr,reg,byear))) )/P_Y.l(pr,reg,byear);

* Tax Rates
txit(pr,reg,byear)     =  V_FGRB.l("IT",pr,reg,byear)/A_Y.l(pr,reg,byear);

* Consumer Prices
P_IO.l(pr,reg,byear)    = txit(pr,reg,byear)+P_Y.l(pr,reg,byear);
P_HC.l(pr,reg,byear)    = txit(pr,reg,byear)+P_Y.l(pr,reg,byear);
P_GC.l(pr,reg,byear)    = txit(pr,reg,byear)+P_Y.l(pr,reg,byear);
P_INVP.l(pr,reg,byear)  = txit(pr,reg,byear)+P_Y.l(pr,reg,byear);

* Demand
A_IO.l(pr,br,reg,byear)     = CAL_indc(pr,br,reg) /P_IO.l(pr,reg,byear);
A_HC.l(pr,reg,byear)        = CAL_hc(pr,reg)      /P_HC.l(pr,reg,byear);
A_GC.l(pr,reg,byear)        = CAL_gc(pr,reg)      /P_GC.l(pr,reg,byear);
A_INVP.l(pr,br,reg,byear)   = CAL_invm(pr,br,reg) /P_INVP.l(pr,reg,byear);

* Labour
A_LAV.l(pr,reg,byear)  =  CAL_lab_frc_tot(reg) * CAL_lab(pr,reg)/sum(pr1, CAL_lab(pr1,reg)) * lh(pr,reg,byear);

P_L.l(reg,byear)  =  sum(pr, CAL_lab(pr,reg))/sum(pr, A_LAV.l(pr,reg,byear));

P_LAV.l(pr,reg,byear)  =  P_L.l(reg,byear);

V_VA.l("lab",pr,reg,byear) = P_LAV.l(pr,reg,byear)*A_LAV.l(pr,reg,byear);

* Capital and Investment
P_KAV.l(pr,reg,byear)    = sum(br, CAL_cap(br,reg))/sum(br, CAL_Capital_Stock(br,reg));
A_KAV.l(pr,reg,byear)    = CAL_cap(pr,reg)/P_KAV.l(pr,reg,byear);
P_KNOKM.l(pr,reg,byear)  = P_KAV.l(pr,reg,byear);

* Expected growth rate
exp_stgr(pr,reg,byear) = 0.025;
A_INV.l(br,reg,byear)  =  sum(pr, CAL_invm(pr,br,reg));
P_INV.l(br,reg,byear)  = (sum(pr, CAL_invm(pr,br,reg))/A_INV.l(br,reg,byear));

tinvpv(pr,br,reg,byear) = (P_INVP.l(pr,reg,byear)*A_INVP.l(pr,br,reg,byear)/(P_INV.l(br,reg,byear)
                         * A_INV.l(br,reg,byear)));

* Base year prices
p_inv0(br,reg)     = P_INV.l(br,reg,byear);
p_invp0(pr,reg)    = P_INVP.l(pr,reg,byear);
a_invp0(pr,br,reg) = A_INVP.l(pr,br,reg,byear);
a_inv0(pr,reg)     = A_INV.l(pr,reg,byear);

ttime(pbyear) = pbyear.val;
ttime(byear)  = byear.val;
ttime1(pbyear)= byear.val;
ttime1(byear) = 2025;

A_KAVC.l(pr,reg,pbyear) =  A_KAV.l(pr,reg,byear);
A_KAVC.l(pr,reg,byear)  =  (1-decl(pr,reg,byear))**(ttime1(byear)-ttime(byear))
                           *A_KAV.l(pr,reg,byear)
                         + (1-(1-decl(pr,reg,byear))**(ttime1(byear)- ttime(byear)))
                           /decl(pr,reg,byear) *A_INV.l(pr,reg,byear);

P_KNAKM.l(reg,byear) =  sum(pr, P_KAV.l(pr,reg,byear)* A_KAV.l(pr,reg,byear))
                       /sum(pr, A_KAV.l(pr,reg,byear)) ;

V_VA.l("CAP",pr,reg,byear) = P_KAV.l(pr,reg,byear)*A_KAV.l(pr,reg,byear);

tgk(pr,reg,pbyear) = 0;

stgr(br,reg,byear) =
        -1 +(A_INV.l(br,reg,byear)/(a0inv(br,reg,byear)* A_KAV.l(br,reg,byear))
           + 1 - decl(br,reg,byear))*(P_KAV.l(br,reg,byear)
                /(P_INV.l(br,reg,byear)*(RLTLR.l(reg,byear)+decl(br,reg,byear)))
                    )**(-sninv(br,reg,byear)*a1inv(br,reg,byear))
                                 *exp(-sum(pbyear, tgk(br,reg,pbyear))*(1-sninv(br,reg,byear)))
;

*----------------------------------------------------------------------------------------------------------------------*
* RATES for FACTORS INCOME ALLOCATION
V_FSEFA.L(se,fa,reg,byear) = CAL_inst_fsefa(se,fa,reg);
V_FSEFAT.L(fa,reg,byear)   = sum(se, CAL_inst_fsefa(se,fa,reg));

txfsefa(se,fa,reg,byear)   = (V_FSEFA.l(se,fa,reg,byear)/sum(br, V_VA.l(fa,br,reg,byear))
                             )$(sum(br,V_VA.l(fa,br,reg,byear)) ne 0) ;

*----------------------------------------------------------------------------------------------------------------------*
* RATES for INCOME ALLOCATION among SECTORS
V_FC.L(se,reg,byear)       = [ sum(pr, CAL_hc(pr,reg))       ]$(sameas(se,"H"))
                           + [ 0.0                           ]$(sameas(se,"F"))
                           + [ sum(pr, CAL_gc(pr,reg))       ]$(sameas(se,"G"))
                           + [ sum(pr, CAL_exprts(pr,reg))   ]$(sameas(se,"W"));

*###############################################################################
*                             INCOME
*###############################################################################
V_YDISP.l(reg,byear) = sum(fa, V_FSEFA.l("H",fa,reg,byear));

*###############################################################################
*                             PRODUCTION
*###############################################################################
* Quantities in production function
A_MA.l(br,reg,byear)               = sum(prma,    A_IO.l(prma,br,reg,byear));
A_ENG.l(pr,reg,byear)              =              A_IO.l(pr_ene,pr,reg,byear);
A_KL.l(pr,reg,byear)               = A_LAV.l(pr,reg,byear) + A_KAV.l(pr,reg,byear);
A_KLE.l(pr,reg,byear)              = A_ENG.l(pr,reg,byear) + A_KL.l(pr,reg,byear);

* sectors with reserves
* Prices
P_MA.l(br,reg,byear) =   sum(prma,  A_IO.l(prma,br,reg,byear)*P_IO.l(prma,reg,byear))
                                                             /A_MA.l(br,reg,byear);

P_ENG.l(pr,reg,byear) =  sum(prfele, P_IO.l(prfele,reg,byear)*A_IO.l(prfele,pr,reg,byear))
                        /A_ENG.l(pr,reg,byear);

P_KL.l(pr,reg,byear)     = (P_LAV.l(pr,reg,byear)*A_LAV.l(pr,reg,byear)
                           +P_KAV.l(pr,reg,byear)*A_KAV.l(pr,reg,byear)
                           )/A_KL.l(pr,reg,byear);

P_KLE.l(pr,reg,byear)   = (P_KL.l(pr,reg,byear) *A_KL.l(pr,reg,byear)+
                            P_ENG.l(pr,reg,byear)*A_ENG.l(pr,reg,byear)
                           )/A_KLE.l(pr,reg,byear);

* Share - Distribution parameters
* Default sectors
theta_dkle(br,reg,byear)          =   P_KLE.l(br,reg,byear)    *  A_KLE.l(br,reg,byear)
                                    /(P_PD.l(br,reg,byear)     *  A_XD.l(br,reg,byear));
theta_dma(br,reg,byear)           =   P_MA.L(br,reg,byear)     *  A_MA.l(br,reg,byear)
                                    /(P_PD.l(br,reg,byear)     *  A_XD.l(br,reg,byear));
theta_dmpr(prma,br,reg,byear)     =   P_IO.L(prma,reg,byear)   *  A_IO.l(prma,br,reg,byear)
                                    /(P_MA.l(br,reg,byear)     *  A_MA.l(br,reg,byear));
theta_dkl(br,reg,byear)           =   P_KL.L(br,reg,byear)     *  A_KL.l(br,reg,byear)
                                    /(P_KLE.l(br,reg,byear)    *  A_KLE.l(br,reg,byear));
theta_deng(br,reg,byear)          =   P_ENG.l(br,reg,byear)    *  A_ENG.l(br,reg,byear)
                                    /(P_KLE.l(br,reg,byear)    *  A_KLE.l(br,reg,byear));
theta_dkav(br,reg,byear)          =   P_KAV.L(br,reg,byear)    *  A_KAV.l(br,reg,byear)
                                    /(P_KL.l(br,reg,byear)     *  A_KL.l(br,reg,byear));
theta_depr(prfele,br,reg,byear)   =   P_IO.L(prfele,reg,byear) *  A_IO.l(prfele,br,reg,byear)
                                    /(P_ENG.l(br,reg,byear)    *  A_ENG.l(br,reg,byear));
theta_dlav(br,reg,byear)          =   P_LAV.l(br,reg,byear)    *  A_LAV.l(br,reg,byear)
                                    /(P_KL.l(br,reg,byear)     *  A_KL.l(br,reg,byear));

* Level K-L
check_theta("K-L",br,reg,byear) =  (1 - theta_dkav(br,reg,byear) - theta_dlav(br,reg,byear));


V_HCDTOT.l(reg,byear)    = sum(pr, P_HC.L(pr,reg,byear)*A_HC.l(pr,reg,byear));
tsave(reg,byear)         = 1-V_HCDTOT.l(reg,byear)/V_YDISP.l(reg,byear);

* Volume of consumption matrix
hcfpv(pr,fn,reg,byear)      = CAL_hcfu(pr,fn,reg)/P_HC.l(pr,reg,byear);
A_HCFVPV.l(pr,fn,reg,byear) = hcfpv(pr,fn,reg,byear);

* Coefficients of consumption matrix
thcfv(pr,fn,reg,byear)  = (hcfpv(pr,fn,reg,byear)/sum(br, hcfpv(br,fn,reg,byear)))$(sum(br,hcfpv(br,fn,reg,byear)) ne 0);
thcfv(pr,fn,reg,byear)  $ (thcfv(pr,fn,reg,byear) lt  1e-18) = 0  ;

* Prices
P_HCFV.l(fn,reg,byear)   =
   (sum(pr,thcfv(pr,fn,reg,byear)*P_HC.l(pr,reg,byear)))
                     $((sum(pr,thcfv(pr,fn,reg,byear)*P_HC.l(pr,reg,byear))) ne 0)
                  +1.$((sum(pr,thcfv(pr,fn,reg,byear)*P_HC.l(pr,reg,byear))) eq 0);

A_HCFV.L(fn,reg,byear)  = sum(pr, CAL_hcfu(pr,fn,reg))/P_HCFV.L(fn,reg,byear);

hcbse(fn,reg,byear) = (A_HCFV.L(fn,reg,byear)*P_HCFV.L(fn,reg,byear))
                      /V_HCDTOT.L(reg,byear);

eehca(fn,reg,byear) = CAL_eehc(fn,reg) /(sum(fr, hcbse(fr,reg,byear)* CAL_eehc(fr,reg)));

bhcfv(fn,reg,byear) = eehca(fn,reg,byear)*hcbse(fn,reg,byear);

chcfv(fn,reg,byear) = A_HCFV.l(fn,reg,byear)+(V_HCDTOT.l(reg,byear))*bhcfv(fn,reg,byear)
                    /(P_HCFV.l(fn,reg,byear)*CAL_frisch(reg));

str(reg,byear)      = (V_HCDTOT.l(reg,byear)-sum(fn, chcfv(fn,reg,byear)*P_HCFV.l(fn,reg,byear)))
                     /(V_YDISP.l(reg,byear) -sum(fn, chcfv(fn,reg,byear)*P_HCFV.l(fn,reg,byear)));

stp(reg,byear)      = str(reg,byear)*RLTLR.L(reg,byear);

A_HCFVPV.l(pr,fn,reg,byear) = thcfv(pr,fn,reg,byear)* A_HCFV.l(fn,reg,byear) ;


*#######################################################################################################################################
testHCDTOT(reg,byear)= - V_HCDTOT.l(reg,byear) +  sum(fn, P_HCFV.l(fn,reg,byear)*chcfv(fn,reg,byear))
                       + (stp(reg,byear)/RLTLR.l(reg,byear))*(V_YDISP.l(reg,byear)- sum(fn, P_HCFV.l(fn,reg,byear)*chcfv(fn,reg,byear)));

abort$(smax(reg, sum(byear, abs(testHCDTOT(reg,byear)))) gt 1e-7 ) "Household consumption is not correctly calibrated";

totlabfrc(reg,byear)   = sum(pr,  A_LAV.l(pr,reg,byear));

*--------------------- PUBLIC CONSUMPTION
gctv(reg,byear)    = sum(pr, A_GC.l(pr,reg,byear));
tgcv(pr,reg,byear) = A_GC.l(pr,reg,byear)/gctv(reg,byear);

*-------------------------------------------------------------------------------
*                             VALUE ADDED/GDP
*-------------------------------------------------------------------------------
gdpu(reg,byear)     =  sum(fa,sum(br,V_VA.l(fa,br,reg,byear)))
                    +  sum(gv,sum(br,V_FGRB.l(gv,br,reg,byear)));

gdpv(reg,byear)     =  gdpu(reg,byear);

V_VU.l(reg,byear)   =  sum(br,sum(fa, V_VA.l(fa,br,reg,byear)));

V_SAVE.L(se,reg,byear)    = sum(fa,V_FSEFA.L(se,fa,reg,byear))
                          - V_FC.L(se,reg,byear)                          
                          +(sum(br,     CAL_imprts(br,reg))          )$(sameas(se,"w"))
                          + sum((br,gv),V_FGRB.l(gv,br,reg,byear)    )$(sameas(se,"g"));

V_INV.L(se,reg,byear) = sum(br, tcinv(se,reg,byear)*sum(pr,  CAL_invm(pr,br,reg)));

V_SURPL.L(se,reg,byear)  = V_SAVE.L(se,reg,byear)- V_INV.L(se,reg,byear);
cash(reg,byear)          = - 100*V_SURPL.l("W",reg,byear)/V_VU.l(reg,byear);
pdsh(reg,byear)          =   100*V_SURPL.l("G",reg,byear)/V_VU.l(reg,byear);

errhcdt(reg,byear)  =  V_HCDTOT.l(reg,byear)-sum(fn, P_HCFV.l(fn,reg,byear)*A_HCFV.l(fn,reg,byear));

* Computation of reference balance of payment equilibrium
*------------------------------------------------------------
* Base year current account surplus or deficit
P_WPI.L(byear)       = 1;
*-------------------------------------------------------------------------------
*---------------------- Capital and Labour Market ------------------------------
*-------------------------------------------------------------------------------
RLTLRWORLD.l(byear)             = 1;

* Expected Unit Cost of Capital
P_EKAV.l(pr,reg,byear) = P_KAV.l(pr,reg,byear);

*-------------------------------------------------------------------------------
*                             Calibration Check
*-------------------------------------------------------------------------------
parameters
zeroprof(br,reg,stime)          Check of the Zero profit condition for firms
erriovals(pr,reg,stime)         Check that the SAM is consistent
absorxxd(pr,reg,stime)          Check of the absorption of domestic production
absory(pr,reg,stime)            Check of the absorption of the composite good
errfl(reg,stime)                Check the surplus at country level
errortest(reg,stime)            Check the IO Balance
errtot(reg,stime)               Check for final demand

gemcal_demand(pr,reg)         Demand by sector in base year
gemcal_supply(pr,reg)         Supply by sector in base year
gemcal_io_chk(*,*,pr,reg)       Checks on the IO table
;
*----------------------------------------------------------------------------------------------------------------------*
*                           Check that the Final IO table to be used in calibration is balanced                        *
*                                  Check and abort condition if  Demand<>Supply                                        *
gemcal_demand(pr,reg) =  sum(br, CAL_indc(pr,br,reg)) + CAL_hc(pr,reg)
                                        + CAL_gc(pr,reg) + CAL_inv_v(pr,reg) + CAL_exprts(pr,reg);

gemcal_supply(pr,reg) =  sum(br, CAL_indc(br,pr,reg)) + CAL_cap(pr,reg)+ CAL_lab(pr,reg)
                                        + CAL_tax(pr,reg) + CAL_imprts(pr,reg);

gemcal_io_chk("Balance","Demand = Supply (absolute difference)", pr, reg) =
                         gemcal_demand(pr,reg) - gemcal_supply(pr,reg);

gemcal_io_chk("Balance","Demand = Supply (percentage difference)", pr, reg)=
                         gemcal_demand(pr,reg)/gemcal_supply(pr,reg) -1;

gemcal_io_chk("Balance","Re-Exports",pr,reg)$(CAL_prod(pr,reg) < CAL_exprts(pr,reg))
                                            = CAL_prod(pr,reg) - CAL_exprts(pr,reg);

abort$(smax((pr,reg), abs(gemcal_io_chk("Balance","Demand = Supply (percentage difference)",pr,reg))) gt 0.001)
                                                                              "IO not balanced ", gemcal_io_chk;

abort$(smin((pr,reg), gemcal_io_chk("Balance","Re-Exports",pr,reg)) < 0)
                                                                          "There are re-exports", gemcal_io_chk;

*----------------------------------------------------------------------------------------------------------------------*
*                             INCOME CHECK
Check_Income(pr,reg,byear)  =   - A_Y.l(pr,reg,byear)
                                 + sum(br, A_IO.l(pr,br,reg,byear))
                                 + A_GC.l(pr,reg,byear)
                                 + A_HC.l(pr,reg,byear)
                                 + sum(br, A_INVP.l(pr,br,reg,byear))    ;

abort$(smax((pr,reg,byear), abs(Check_Income(pr,reg,byear))) gt 10e-3) "Income is not balanced (Check_Income)", Check_Income;

*-------------------------------------------------------------------------------
*                             BALANCE TEST
*-------------------------------------------------------------------------------
*Zero profit condition for firms
zeroprof(br,reg,byear) = P_PD.L(br,reg,byear)*A_XD.L(br,reg,byear)
                       - sum(prma,   A_IO.L(prma,br,reg,byear)  *P_IO.L(prma,reg,byear))
                       - sum(prfele, A_IO.L(prfele,br,reg,byear)*P_IO.L(prfele,reg,byear))
                       - sum(fa,     V_VA.L(fa,br,reg,byear));
abort$(smax((pr,reg,byear),zeroprof(pr,reg,byear)) gt 10e-3) "zero profit condition is not satisfied", zeroprof;

*Check that the SAM is consistent
erriovals(pr,reg,byear)= P_PD.L(pr,reg,byear)*A_XD.L(pr,reg,byear)
                        +V_FGRB.L("IT",pr,reg,byear)
                        +P_IMP.L(pr,reg,byear)*A_IMP.L(pr,reg,byear)
                     -(
                        sum(br,(P_IO.L(pr,reg,byear)$prma(pr)
                               +P_IO.L(pr,reg,byear)$prfele(pr))*A_IO.L(pr,br,reg,byear))
                        +P_HC.L(pr,reg,byear)*A_HC.L(pr,reg,byear)
                        +P_GC.L(pr,reg,byear)*A_GC.L(pr,reg,byear)
                        +P_INVP.L(pr,reg,byear)*sum(br,A_INVP.L(pr,br,reg,byear))
                        +P_PWE.L(pr,reg,byear)*A_EXPOT.L(pr,reg,byear)
                       );

abort$(smax((pr,reg,byear),abs(erriovals(pr,reg,byear))) gt 10e-3) "erriovals check not satisfied", erriovals;

*Absorption of domestic production
absorxxd(pr,reg,byear)=  P_PD.L(pr,reg,byear) * A_XD.L(pr,reg,byear)
                       -(P_XD.L(pr,reg,byear) * A_XXD.L(pr,reg,byear)
                       + P_PWE.L(pr,reg,byear)* A_EXPOT.L(pr,reg,byear));

abort$(smax((pr,reg,byear),abs(absorxxd(pr,reg,byear))) gt 10e-3) "Domestic production is not absorpted", absorxxd;

*Absorption of the composite good
absory(pr,reg,byear)   =  P_PD.L(pr,reg,byear)*A_XD.L(pr,reg,byear)
                       - (P_Y.L(pr,reg,byear)*A_Y.L(pr,reg,byear)
                       -  P_IMP.L(pr,reg,byear)*A_IMP.L(pr,reg,byear)
                       +  P_PWE.L(pr,reg,byear)*A_EXPOT.L(pr,reg,byear));

abort$(smax((br,reg,byear),abs(absory(br,reg,byear))) gt 10e-3) "Composite good is not absorpted", absory;


*Surplus at country level
errfl(reg,byear)       =  sum(se, V_SURPL.L(se,reg,byear));
abort$(smax((reg,byear),errfl(reg,byear)) gt 10e-3) "errfl check not satisfied", errfl;
*----------------------------------------------------------------------------------------------------------------------
* Scenario Projections
* ---------------------------------------------------------------------------------------------------------------------
* Interface
$setglobal finalyear "2050"
* Model time period
$setglobal uperiod  "5"
* ---------------------------------------------------------------------------------------------------------------------*
* ------------------------------------ Set and parameters in model setting --------------------------------------------*
* ---------------------------------------------------------------------------------------------------------------------*
Set
   rtime(stime)          model periods incl. calibration and pre-calibration period /2019,2020,2025,2030,2035,2040,2045,2050/
   rtime2(stime)         model periods after calibration periods /2025,2030,2035,2040,2045,2050/
   rtime3(stime)         model periods incl. calibration periods /2020,2025,2030,2035,2040,2045,2050/
   an(stime)             Time set used in recursive runs
   fy(stime)             Final year
;

Alias(rtime,bcl);
Alias (reg,er,cr,cs);

ttime(rtime)    = rtime.val;
ttime1(pbyear)  = pbyear.val + 1;
ttime1(rtime-1) = ttime(rtime);
ttime1(rtime)$((rtime.val = %finalyear%) and ((%finalyear% ge 2020))) = ttime(rtime)+%uperiod%;

* Running Period after the base year
rtime2(rtime)$(ord(rtime) > byear.val)  = yes;
rtime3(rtime)$(ord(rtime) > pbyear.val) = yes;

fy(rtime)$(ttime(rtime) = smax(bcl, ttime(bcl))) = ttime(rtime);

* Parameters which define the time in the recursive dynamic setting
Parameters
curyearp                 Period within the loop
inityear                 First period within the loop
endyearp                 Last period within the loop
;

* Initial values for the base year
inityear = pbyear.val +1;
curyearp = inityear;
endyearp = inityear + card(rtime) -2;

* ---------------------------------------------------------------------------------------------------------------------*
* ------------------------------------  Model declarations and assumptions  -------------------------------------------*
* ---------------------------------------------------------------------------------------------------------------------*
* Generating the parameter values for the run periods
*-----------------------------------------------------
a0inv(br,er,rtime2)              = a0inv(br,er,byear);
a1inv(br,er,rtime2)              = a1inv(br,er,byear);
ac(br,er,rtime2)                 = ac(br,er,byear);
beta(br,er,cr,rtime2)            = beta(br,er,cr,byear);
bhcfv(fn,er,rtime2)              = bhcfv(fn,er,byear);
chcfv(fn,er,rtime2)              = chcfv(fn,er,byear);
decl(pr,er,rtime2)               = decl(pr,er,byear);
delta(br,er,rtime2)              = delta(br,er,byear);
stgr(br,er,rtime2)               = stgr(br,er,byear);
stp(er,rtime2)                   = stp(er,byear);
tgcv(pr,er,rtime2)               = tgcv(pr,er,byear);
thcfv(pr,fn,er,rtime2)           = thcfv(pr,fn,er,byear);
tinvpv(pr,br,er,rtime2)          = tinvpv(pr,br,er,byear);
tsave(er,rtime2)                 = tsave(er,byear);
txfsefa(se,fa,er,rtime2)         = txfsefa(se,fa,er,byear);
txit(pr,er,rtime2)               = txit(pr,er,byear);
tcinv(se,er,rtime)               = tcinv(se,er,byear);
* Shares in value share forms
theta_dkle(br,er,rtime2)         = theta_dkle(br,er,byear);
theta_dma(br,er,rtime2)          = theta_dma(br,er,byear);
theta_dmpr(pr,br,er,rtime2)      = theta_dmpr(pr,br,er,byear);
theta_dkl(br,er,rtime2)          = theta_dkl(br,er,byear);
theta_deng(br,er,rtime2)         = theta_deng(br,er,byear);
theta_dkav(br,er,rtime2)         = theta_dkav(br,er,byear);
theta_dlav(br,er,rtime2)         = theta_dlav(br,er,byear);
theta_depr(pr,br,er,rtime2)      = theta_depr(pr,br,er,byear);
* Elasticities
sn0(br,er,rtime2)                = sn0(br,er,byear);
sn1(br,er,rtime2)                = sn1(br,er,byear);
sn2(br,er,rtime2)                = sn2(br,er,byear);
sn3(br,er,rtime2)                = sn3(br,er,byear);
sn4(br,er,rtime2)                = sn4(br,er,byear);
sn5(br,er,rtime2)                = sn5(br,er,byear);
sninv(br,er,rtime2)              = sninv(br,er,byear);
sigmax(br,er,rtime2)             = sigmax(br,er,byear);
sigmai(br,er,rtime2)             = sigmai(br,er,byear);
* Labour Market
lh(br,er,rtime2)                 = lh(br,er,byear);
TotLabFrc(er,rtime2)             = TotLabFrc(er,byear);

* Prices in base year
p_pdbsr0(pr,er,rtime3)                  = P_PDBSR.l(pr,er,byear);
p_kle0(pr,er,rtime3)                    = P_KLE.l(pr,er,byear);
p_ma0(pr,er,rtime3)                     = P_MA.l(pr,er,byear);
p_kav0(pr,er,rtime3)                    = P_KAV.l(pr,er,byear);
p_io0(pr,er,rtime3)                     = P_IO.l(pr,er,byear);
p_kl0(pr,er,rtime3)                     = P_KL.l(pr,er,byear);
p_eng0(pr,er,rtime3)                    = P_ENG.l(pr,er,byear);
p_lav0(pr,er,rtime3)                    = P_LAV.l(pr,er,byear);
p_pd0(pr,er,rtime3)                     = P_PD.l(pr,er,byear);
p_wpi0                                  = P_WPI.l(byear);
p_hc0(pr,er)                            = P_HC.l(pr,er,byear);
p_hcfv0(fn,er)                          = P_HCFV.l(fn,er,byear);
p_gc0(pr,er)                            = P_GC.l(pr,er,byear);

* Volumes in base year in value shares form
a_xd0(pr,er,rtime3)                     = A_XD.l(pr,er,byear);
a_kl0(pr,er,rtime3)                     = A_KL.l(pr,er,byear);
a_kle0(pr,er,rtime3)                    = A_KLE.l(pr,er,byear);
a_ma0(pr,er,rtime3)                     = A_MA.l(pr,er,byear);
a_eng0(pr,er,rtime3)                    = A_ENG.l(pr,er,byear);
a_io0(pr,br,er,rtime3)                  = A_IO.l(pr,br,er,byear);
a_kav0(pr,er,rtime3)                    = A_KAV.l(pr,er,byear);
a_lav0(pr,er,rtime3)                    = A_LAV.l(pr,er,byear);
a_hcfv0(fn,er)                          = A_HCFV.l(fn,er,byear);
a_hc0(br,er)                            = A_HC.l(br,er,byear);
a_hcfvpv0(br,fn,er)                     = A_HCFVPV.l(br,fn,er,byear);

*------------ Base year values for non calibrated parameters ------------------*
* Prices
price_index(rtime3)             = 1;
gdp_growth(rtime3)              = 1;

* Technical progress
tgk(pr,er,rtime3)               = 0;
tgl(pr,er,rtime3)               = 0;
tge(prfele,pr,er,rtime3)        = 0;
tgm(pr,br,er,rtime3)            = 0;
tfp(pr,er,rtime3)               = 1;
tfpexo(pr,er,rtime3)            = 1;

* Base year values for switches
swonkm(pr,er,rtime)             = 0;
public_gc(pr,reg,rtime)         = 0;

*-------------------------
* Model equations
*----------------------
EQUATIONS
epd(br,reg,stime)                     Unit Cost of Goods (less value of grf. permits)
esales(pr,reg,stime)                  Price of Domestically Produced Good
esupply(br,reg,stime)                 Supply Price of Exports (in international currency)
epy(pr,reg,stime)                     Composite Price of Good on the Domestic Market (Armington Price Eq.)
epio(pr,reg,stime)                    Price of Good for Intermediate Consumption (with taxes)
epgc(pr,reg,stime)                    Price of Good for Public Consumption (with taxes)
ephc(pr,reg,stime)                    Price of Good for Private Consumption (with taxes)
epinv(br,reg,stime)                   Price of Good for Investment for the Investing BR (with taxes)
epinvp(pr,reg,stime)                  Price of Good for Investment (deliveries) (with taxes)
epopv(reg,stime)                      Labour Market
epl(br,reg,stime)                     Unit cost of Labour by sector
eequiki(br,reg,stime)                 Equilibrium of the Capital Stock per Branch (fixing PKNOKM)
eequikc(reg,stime)                    Equilibrium on the Country Capital Stock Market (fixing PKNAKM)
epk(pr,reg,stime)                     Rental Price of Capital
exd(br,reg,stime)                     Unit Production Cost of Good by BR
epkle(pr,reg,stime)                   Price of KLE bundle
epm(pr,reg,stime)                     Unit Cost of Material Aggregate (non energy)
epkl(pr,reg,stime)                    Price of KL bundle
epeng(pr,reg,stime)                   Price of ENG bundle
ekav(pr,reg,stime)                    Demand for Capital Services by Branch
elav(pr,reg,stime)                    Demand for labour by skill type
ekle(pr,reg,stime)                    Demand for KLE bundle
ema(pr,reg,stime)                     Demand for MA (materials) Aggregate
ekl(pr,reg,stime)                     Demand for Capital and Labor services (KL)
eeng(pr,reg,stime)                    Demand for ENG bundle
eiovtot(pr,br,reg,stime)              Deliveries from Branches to Branches for Intermediate Consumption
einvv(br,reg,stime)                   Demand for Investment by Branch
einvpv(pr,br,reg,stime)               Deliveries from Branches to Branches for Investment
einv(se,reg,stime)                    Total Investment Expenditure by Sector
ekavc(pr,reg,stime)                   Capital Stock Available Next Period
eydisp(reg,stime)                     Disposable Income of Households
etsave(reg,stime)                     Consumption Expenditure by H
egcv(pr,reg,stime)                    Deliveries to Public Consumption by BR
exdtot(br,reg,stime)                  Total Domestic Production by BR
eydem(pr,reg,stime)                   Total Domestic Demand
eabsor(pr,reg,stime)                  Demand for Domestic Production by Domestic Consumers (Armington)
epwxo(pr,reg1,reg,stime)              Import Price (in international currency)
epimpl(pr,reg,stime)                  Composite Import Price with Duties (Armington)
eexpol(br,reg,reg1,stime)             Export Demand (bilateral)
eimpl(br,reg,stime)                   Demand for Imports (Armington)
eimpo(br,reg,reg1,stime)              Bilateral Import Demand (Armington)
efgrbtotl(gv,pr,reg,stime)            Transfers from Branches to G (by govern. category linked model)
evatot(fa,pr,reg,stime)               Value Added by Factor and Branch
efsefat(fa,reg,stime)                 Total Transfers of Factors to Sectors
efsefa(se,fa,reg,stime)               Transfers from Factors to Sectors
efcftot(se,reg,stime)                 Consumption Expenditure by Sector
esavel(se,reg,stime)                  Savings by Sector (linked model)
esurpl(se,reg,stime)                  Surplus by Sector
evu(reg,stime)                        Total Value Added (GDP at production prices)
ewpi(stime)                           World Price Index                                       - price
ephcfv(fn,reg,stime)                  Price of Consumer Category (with taxes and abatement cost)
ehcfvpv(pr,fn,reg,stime)              Private Consumption in volume by Consumer Category & by branch
ehcv(pr,reg,stime)                    Deliveries to Private Consumption by BR
ehcfv(fn,reg,stime)                   Demand for Consumption by Purpose
epek(pr,reg,stime)                    Expected Price of Capital
;

*#######################################################################################################################
*                                                       PRICES
*#######################################################################################################################
*------------------------------------------------- PRODUCTION ----------------------------------------------------------
* Unit cost of production
epd(br,er,an)..       P_PD(br,er,an) =E= P_PDBSR(br,er,an);
*----------------------------------------------------------------------------------------------------------------------*
*                                                   SUPPLY PRICES
*----------------------------------------------------------------------------------------------------------------------*
* Derived Domestic OUTPUT Prices
esales(br,er,an)..    P_XD(br,er,an)  =E= P_PD(br,er,an);
* Export output price
esupply(br,er,an)..   P_PWE(br,er,an) =E= P_PD(br,er,an);
*----------------------------------------------------------------------------------------------------------------------*
*                                                 PURCHASE PRICES
*----------------------------------------------------------------------------------------------------------------------*
* Basic input price by Armington function
epy(pr,er,an)..
  P_Y(pr,er,an) =E=   [ (((1/ac(pr,er,an))*(delta(pr,er,an)**sigmax(pr,er,an)*P_IMP(pr,er,an)**(1-sigmax(pr,er,an))
                      + (1-delta(pr,er,an))**(sigmax(pr,er,an))*P_XD(pr,er,an)**(1-sigmax(pr,er,an)))
                         **(1/(1-sigmax(pr,er,an)))))
                      ];
* Intermediate input purchase price
epio(pr,er,an)..      P_IO(pr,er,an) =E= txit(pr,er,an) * P_WPI(an)/p_wpi0 + P_Y(pr,er,an);
* Government purchase price
epgc(pr,er,an)..      P_GC(pr,er,an) =E= txit(pr,er,an) * P_WPI(an)/p_wpi0 + P_Y(pr,er,an);
* Consumer purchase price
ephc(pr,er,an)..      P_HC(pr,er,an) =E= txit(pr,er,an) * P_WPI(an)/p_wpi0 + P_Y(pr,er,an);
* Investment purchase price
epinv(br,er,an)..     P_INV(br,er,an) =E=  p_inv0(br,er)*(sum(pr, tinvpv(pr,br,er,an)*P_INVP(pr,er,an)/p_invp0(pr,er)));
* Investment purchase price
epinvp(pr,er,an)..    P_INVP(pr,er,an) =E= txit(pr,er,an)*P_WPI(an)/p_wpi0 + P_Y(pr,er,an);
;
*#######################################################################################################################
*                                                   FACTOR MARKETS
*#######################################################################################################################
*----------------------------------------------------------------------------------------------------------------------*
*                                                     LABOUR MARKET
*----------------------------------------------------------------------------------------------------------------------*
ePOPV(er,an)..   SUM(pr,  A_LAV(pr,er,an))  =E=   TotLabFrc(er,an);

ePL(pr,er,an)..  P_LAV(pr,er,an) =e= P_L(er,an);
*----------------------------------------------------------------------------------------------------------------------*
*                                                     CAPITAL MARKET
*----------------------------------------------------------------------------------------------------------------------*
* Capital stock fix and sector specific
eequiki(br,er,rtime)$(swonkm(br,er,rtime) eq 0 and an(rtime))..
    A_KAV(br,er,rtime)            =E=   A_KAVC(br,er,rtime-1);

* Capital stock and full Capital Mobility by sector
eequikc(er,rtime)$((smax(pr, swonkm(pr,er,rtime)) eq 1) and an(rtime))..
   sum(pr, A_KAV(pr,er,rtime))   =E=   sum(pr, A_KAVC(pr,er,rtime-1));

* Unit cost of capital
epk(pr,er,an)..  P_KAV(pr,er,an) =E= + P_KNOKM(pr,er,an)     $(swonkm(pr,er,an) eq 0)
                                     + P_KNAKM(er,an)        $(swonkm(pr,er,an) eq 1);

epek(pr,er,rtime)$(an(rtime))..
   P_EKAV(pr,er,rtime)    =E=   P_KAV(pr,er,rtime)       $(iter_pk = 0)
                             +  exo_pkav(pr,er,rtime)    $((iter_pk > 0) and (rtime.val < 2050))
                             +  P_KAV(pr,er,rtime)       $((iter_pk > 0) and (rtime.val = 2050));
                             
*#######################################################################################################################
*                                                       PRODUCTION
*#######################################################################################################################
*----------------------------------------------------------------------------------------------------------------------*
*                                                      ZERO PROFIT
*----------------------------------------------------------------------------------------------------------------------*
*------------------------------------------------------ TOP LEVEL ------------------------------------------------------
exd(br,er,an)..
   P_PDBSR(br,er,an)    =e=
          + p_pdbsr0(br,er,an)*(theta_dkle(br,er,an)*(P_KLE(br,er,an)/p_kle0(br,er,an))**(1-sn1(br,er,an))/
                               [tfp(br,er,an)*tfpexo(br,er,an)]**(1-sn1(BR,ER,AN))
                              + theta_dma(br,er,an)*(P_MA(br,er,an)/p_ma0(br,er,an))**(1-sn1(br,er,an))/
                               [tfp(br,er,an)*tfpexo(br,er,an)]**(1-sn1(BR,ER,AN))
                               )**(1/(1-sn1(br,er,an)));

*------------------------------------------------------ 2nd LEVEL ------------------------------------------------------
* 2nd level: Capital Labor Energy 
epKLE(pr,er,an)..
   P_KLE(pr,er,an) =E= p_kle0(pr,er,an)*( theta_dkl(pr,er,an) *(P_KL(pr,er,an) /p_kl0(pr,er,an) )**(1-sn2(pr,er,an))
                                        + theta_deng(pr,er,an)*(P_ENG(pr,er,an)/p_eng0(pr,er,an))**(1-sn2(pr,er,an))
                                        )**(1/(1-sn2(pr,er,an)));

* 2nd level: Material inputs 
epm(br,er,an)..
   P_MA(br,er,an) =E= p_ma0(br,er,an)*( sum(prma, theta_dmpr(prma,br,er,an)*(P_IO(prma,er,an)/p_io0(prma,er,an))**(1-sn3(br,er,an))))**(1/(1-sn3(br,er,an)));


*------------------------------------------------------ 3rd LEVEL ------------------------------------------------------
* 3rd level: Value added, Capital and labor
epkl(pr,er,an)..
   P_KL(pr,er,an) =e= p_kl0(pr,er,an)*( theta_dkav(pr,er,an) * (P_KAV(pr,er,an)/p_kav0(pr,er,an)*exp(-tgk(pr,er,an)))**(1-sn4(pr,er,an))
                                      + theta_dlav(pr,er,an) * (P_LAV(pr,er,an)/p_lav0(pr,er,an)*exp(-tgl(pr,er,an)))**(1-sn4(pr,er,an))
                                      )**(1/(1-sn4(pr,er,an)));
*------------------------------------------------------ 4th LEVEL ------------------------------------------------------
* 4. level: Energy products
epeng(pr,er,an)..
   P_ENG(pr,er,an) =e= p_eng0(pr,er,an)*(
                 +  sum(prfele, theta_depr(prfele,pr,er,an)*(P_IO(prfele,er,an)/p_io0(prfele,er,an)*exp(-tge(prfele,pr,er,an))))**(1-sn5(pr,er,an))
                                        )**(1/(1-sn5(pr,er,an)));

*----------------------------------------------------------------------------------------------------------------------*
*                                                     Market Clearance
*----------------------------------------------------------------------------------------------------------------------*
* Capital demand
ekav(pr,er,an)..
   A_KAV(pr,er,an) =e= + theta_dkav(pr,er,an) * A_KL(pr,er,an) * (p_kl0(pr,er,an)/p_kav0(pr,er,an))*exp(tgk(pr,er,an)*(sn4(pr,er,an)-1))*
                                (P_KL(pr,er,an)/P_KAV(pr,er,an)* p_kav0(pr,er,an)/p_kl0(pr,er,an))**sn4(pr,er,an);

* Labor demand
elav(pr,er,an)..
   A_LAV(pr,er,an) =e= + theta_dlav(pr,er,an) * A_KL(pr,er,an) * (p_kl0(pr,er,an)/p_lav0(pr,er,an))*exp(tgl(pr,er,an)*(sn4(pr,er,an)-1))*
                                (P_KL(pr,er,an)/P_LAV(pr,er,an)* p_lav0(pr,er,an)/p_kl0(pr,er,an))**sn4(pr,er,an);

*----------------------------------------------------------------------------------------------------------------------*
*                                                   DEFINITIONS SUBLEVEL DEMANDS
*----------------------------------------------------------------------------------------------------------------------*
*--------------------------------------------------- STANDARD PRODUCTION -----------------------------------------------
*------------------------------------------------------ 2nd LEVEL ------------------------------------------------------

* 2nd level: capital labor energy bundle
ekle(pr,er,an)..
   A_KLE(pr,er,an) =e=  +theta_dkle(pr,er,an)*(p_pdbsr0(pr,er,an)/p_kle0(pr,er,an))*A_XD(pr,er,an)*
                                              (P_PDBSR(pr,er,an)/P_KLE(pr,er,an)*p_kle0(pr,er,an)/p_pdbsr0(pr,er,an)
                                              )**sn1(pr,er,an) *[tfp(pr,er,an)*tfpexo(pr,er,an)]**(sn1(pr,er,an)-1);
* 2nd level: Material inputs non-energy
ema(pr,er,an)..
   A_MA(pr,er,an)  =e= +   theta_dma(pr,er,an)*(p_pdbsr0(pr,er,an)/p_ma0(pr,er,an))*A_XD(pr,er,an)*
                           (P_PDBSR(pr,er,an)/P_MA(pr,er,an)*p_ma0(pr,er,an)/p_pdbsr0(pr,er,an))**sn1(pr,er,an)
                         * [tfp(pr,er,an)*tfpexo(pr,er,an)]**(sn1(pr,er,an)-1);

*------------------------------------------------------ 3rd LEVEL ------------------------------------------------------
* 3rd level: Value added, Capital and labor
ekl(pr,er,an)..
   A_KL(pr,er,an)  =e= + theta_dkl(pr,er,an)*A_KLE(pr,er,an)*(p_kle0(pr,er,an)/p_kl0(pr,er,an))*
                                            (P_KLE(PR,ER,AN)/P_KL(pr,er,an)*p_kl0(pr,er,an)/p_kle0(pr,er,an))**sn2(pr,er,an)
;

* 3rd level: energy bundle
eeng(pr,er,an)..
   A_ENG(pr,er,an) =e=  theta_deng(pr,er,an)*A_KLE(pr,er,an)*(p_kle0(pr,er,an)/p_eng0(pr,er,an))
                                           *(P_KLE(pr,er,an)/ P_ENG(pr,er,an)*p_eng0(pr,er,an)/p_kle0(pr,er,an) )**sn2(pr,er,an)
;

*------------------------------------------------------ 4th LEVEL ------------------------------------------------------
* 4th level. intermediate materials
eiovtot(pr,br,er,an)..
   A_IO(pr,br,er,an) =e= +[ + ( theta_dmpr(pr,br,er,an)*(p_ma0(br,er,an)/p_io0(pr,er,an))*A_MA(br,er,an)*(P_MA(br,er,an)/P_IO(pr,er,an)
                               *p_io0(pr,er,an) /p_ma0(br,er,an))**sn3(br,er,an)* exp(tgm(pr,br,er,an)*(sn3(br,er,an)-1)))
                             $(prma(pr))
                            + ( theta_depr(pr,br,er,an)*(p_eng0(br,er,an)/p_io0(pr,er,an))*A_ENG(br,er,an)*(P_ENG(br,er,an)/P_IO(pr,er,an)
                                *p_io0(pr,er,an) /p_eng0(br,er,an))**sn5(br,er,an)* exp((tge(pr,br,er,an))*(sn5(br,er,an)-1)))
                             $(prfele(pr))
                          ];

*#######################################################################################################################
*                                                       INVESTMENT
*#######################################################################################################################
* Investment demand
einvv(br,er,rtime)$(an(rtime))..
   A_INV(br,er,rtime) =E= [ A_KAV(br,er,rtime)*a0inv(br,er,rtime)*
                          ((P_EKAV(br,er,rtime)/(P_INV(br,er,rtime)*((RLTLR(er,rtime))
                            +decl(br,er,rtime))))**(sninv(br,er,rtime)*a1inv(br,er,rtime))
                            * (1+stgr(br,er,rtime))-1+decl(br,er,rtime))
                          ] 
                            + exo_investements(br,er,rtime)/P_INV(br,er,rtime)
;

* Investment demand by commodity
einvpv(pr,br,er,an)$(tinvpv(pr,br,er,an))..
   A_INVP(pr,br,er,an) =E= tinvpv(pr,br,er,an)*(p_inv0(br,er)/p_invp0(pr,er))*A_INV(br,er,an);

* Investment by institutional sector
einv(se,er,an)..
   V_INV(se,er,an) =E=   + [tcinv(se,er,an)* sum(pr, P_INV(pr,er,an)*A_INV(pr,er,an)) ]$(sameas(se,"H"))
                         + [tcinv(se,er,an)* sum(pr, P_INV(pr,er,an)*A_INV(pr,er,an)) ]$(sameas(se,"F"))
                         + [tcinv(se,er,an)* sum(pr, P_INV(pr,er,an)*A_INV(pr,er,an)) ]$(sameas(se,"G"))
                         + [tcinv(se,er,an)* sum(pr, P_INV(pr,er,an)*A_INV(pr,er,an)) ]$(sameas(se,"W"))
;

* Law of motion for capital
ekavc(pr,er,rtime)$(an(rtime))..
   A_KAVC(pr,er,rtime) =E= ( (1-decl(pr,er,rtime))**(ttime1(rtime)-ttime1(rtime-1))*A_KAV(pr,er,rtime)
                           + ((1-(1-decl(pr,er,rtime))**(ttime1(rtime)-ttime1(rtime-1)))/decl(pr,er,rtime))
                                 * A_INV(pr,er,rtime)
                           )$(theta_dkav(pr,er,rtime) ne 0)
;

*#######################################################################################################################
*                                                FINAL CONSUMPTION
*#######################################################################################################################
*----------------------------------------------------------------------------------------------------------------------*
*                                                INCOME EQUATION
*----------------------------------------------------------------------------------------------------------------------*
* Disposable Income
eydisp(er,an)..     V_YDISP(er,an) =E=   sum(fa, V_FSEFA("H",fa,er,an));

*----------------------------------------------------------------------------------------------------------------------*
*                                              PRIVATE CONSUMPTION
*----------------------------------------------------------------------------------------------------------------------*
etsave(er,an)..    V_HCDTOT(er,an) =E= sum(fn, P_HCFV(fn,er,an)*chcfv(fn,er,an))
                                       + (stp(er,an)/(RLTLR(er,an)*RLTLRWORLD(an)))
                                       * (V_YDISP(er,an) - sum(fn, P_HCFV(fn,er,an)*chcfv(fn,er,an)));
*----------------------------------------------------------------------------------------------------------------------*
*                                               PUBLIC CONSUMPTION
*----------------------------------------------------------------------------------------------------------------------*
* Public Consumption
egcv(pr,er,an)..   A_GC(pr,er,an) =E=  gctv(er,an)*tgcv(pr,er,an) + public_gc(pr,er,an);

*#######################################################################################################################
*                                                  TOTAL PRODUCTION
*#######################################################################################################################
* Total production in volume
exdtot(br,er,an)..
   A_XD(br,er,an) =E=  A_XXD(br,er,an) + sum(cr, A_EXPO(br,er,cr,an))
;

* Total Domestic Demand
eydem(pr,er,an)..
   A_Y(pr,er,an) =E= SUM(br, A_IO(pr,br,er,an) + A_INVP(pr,br,er,an)) + A_HC(pr,er,an) + A_GC(pr,er,an);

* Armington Allocation
eabsor(pr,er,an)..
   A_XXD(pr,er,an) =E= (A_Y(pr,er,an)*ac(pr,er,an)**(sigmax(pr,er,an)-1)
                           *(1-delta(pr,er,an))**(sigmax(pr,er,an))
                           *(P_Y(pr,er,an)/P_XD(pr,er,an))**(sigmax(pr,er,an)));

*#######################################################################################################################
*                                                INTERNATIONAL TRADE
*#######################################################################################################################
* EXTERNAL TRADE
* EXPORT and IMPORT PRICES
epwxo(pr,cs,cr,an)..
   P_IMPO(pr,cs,cr,an) =E= P_PWE(pr,cr,an);

epimpl(pr,er,an)..
   P_IMP(pr,er,an) =E= (sum(cr, beta(pr,er,cr,an)**(sigmai(pr,er,an))*(P_IMPO(pr,er,cr,an))**(1-sigmai(pr,er,an))))
                                 **(1/(1-sigmai(pr,er,an)));

* EXPORT and IMPORT QUANTITIES
eexpol(br,cr,cs,an)..
   A_EXPO(br,cr,cs,an) =E=  A_IMPO(br,cs,cr,an);

eimpl(pr,er,an)..
   A_IMP(pr,er,an)    =E= (A_Y(pr,er,an)*ac(pr,er,an)**(sigmax(pr,er,an)-1)
                              *delta(pr,er,an)**sigmax(pr,er,an)*(P_Y(pr,er,an)/P_IMP(pr,er,an))**sigmax(pr,er,an))
                              $(ac(pr,er,an) ne 0)
;

eimpo(br,cr,cs,an)..
   A_IMPO(br,cr,cs,an) =E= A_IMP(br,cr,an) *(P_IMP(br,cr,an)/P_IMPO(br,cr,cs,an)*beta(br,cr,cs,an))**(sigmai(br,cr,an))

;

*#######################################################################################################################
*                                                       TRANSFERS
*#######################################################################################################################
* Government tax income
efgrbtotl(gvb,pr,er,an)..
   V_FGRB(gvb,pr,er,an) =E=    +[ txit(pr,er,an)*P_WPI(an)/p_wpi0
                               *(  sum(br, A_IO(pr,br,er,an)) + A_GC(pr,er,an) + A_HC(pr,er,an)
                                 + sum(br, A_INVP(pr,br,er,an)))               ]$sameas(gvb,"IT")
;

* TRANSFERS between FACTORS and SECTORS
evatot(fa,pr,er,an)..
   V_VA(fa,pr,er,an) =E=  [P_LAV(pr,er,an)*A_LAV(pr,er,an)               ]$(sameas(fa,"lab"))
                        + [P_KAV(pr,er,an)*A_KAV(pr,er,an)               ]$(sameas(fa,"cap"))
;

EFSEFAT(fa,er,an)..
   V_FSEFAT(fa,er,an) =E=  SUM(br, V_VA(fa,br,er,an));

efsefa(se,fa,er,an)..
   V_FSEFA(se,fa,er,an)   =E= txfsefa(se,fa,er,an)* sum(br, V_VA(fa,br,er,an));


* EPILOGUE
efcftot(se,er,an)..
   V_FC(se,er,an)         =E= [ V_HCDTOT(er,an)                                      ]$(sameas(se,"H"))
                            + [ 0.                                                   ]$(sameas(se,"F"))
                            + [ sum(pr, P_GC(pr,er,an)*A_GC(pr,er,an) )              ]$(sameas(se,"G"))
                            + [ sum(pr, P_PWE(pr,er,an)*sum(cr, A_EXPO(pr,er,cr,an)))]$(sameas(se,"W"))
;

esavel(se,er,an)..
   V_SAVE(se,er,an)       =E= [ V_YDISP(er,an) - V_HCDTOT(er,an)                ]$(sameas(se,"H"))
                            + [ sum(fa, V_FSEFA(se,fa,er,an)) - V_FC(se,er,an)  ]$(sameas(se,"F"))
                            + [ sum((gv,br), V_FGRB(gv,br,er,an))
                              + sum(fa, V_FSEFA(se,fa,er,an)) - V_FC(se,er,an)  ]$(sameas(se,"G"))
                            + [ sum(br, P_IMP(br,er,an) * A_IMP(br,er,an))
                              + sum(fa, V_FSEFA(se,fa,er,an)) - V_FC(se,er,an)  ]$(sameas(se,"W"))
;

esurpl(se,er,an)..
   V_SURPL(se,er,an)      =E=   V_SAVE(se,er,an) - V_INV(se,er,an);

evu(er,an)..
   V_VU(er,an)            =E=   sum((br,fa), V_VA(fa,br,er,an));

*######################################################################################################################*
*                                                       CLOSURES                                                       *
*######################################################################################################################*
* Macro Closure
eWPI(an)..  sum((se,er), V_SAVE(se,er,an)) =e=  sum((se,er), V_INV(se,er,an));


*######################################################################################################################*
*                                               Household Consumption SubModel
*######################################################################################################################*
ephcfv(fn,er,an)..         P_HCFV(fn,er,an)     =e=  sum(pr, thcfv(pr,fn,er,an) * P_HC(pr,er,an));

eHCFVPV(pr,fn,er,an)..     A_HCFVPV(pr,fn,er,an) =e=  thcfv(pr,fn,er,an) * A_HCFV(fn,er,an);

eHCV(pr,er,an)..           A_HC(pr,er,an)        =e=  sum(fn, A_HCFVPV(pr,fn,er,an));

* Household Demand for Consumption by purpose
eHCFV(fn,er,rtime)$(an(rtime))..
   A_HCFV(fn,er,rtime)   =e=   chcfv(fn,er,rtime) + bhcfv(fn,er,rtime)/P_HCFV(fn,er,rtime)*
                              (V_HCDTOT(er,rtime) - sum(fr, P_HCFV(fr,er,rtime)*chcfv(fr,er,rtime)));

*###############################################################################
* MODEL DEFINITION
*###############################################################################
MODEL CGE_Maquette
/
epd.p_pd
esales.p_xd       
esupply.p_pwe     
epy.p_y          
epio.p_io        
epgc.p_gc        
ephc.p_hc        
epinv.p_inv      
epinvp.p_invp    
epopv.P_L
epl.P_LAV
epk.P_KAV             
eequiki.p_knokm      
eequikc.p_knakm  
exd.p_pdbsr      
epkle.p_kle      
epm.p_ma         
epkl.p_kl        
epeng.p_eng      
ekav.A_KAV       
elav.A_LAV        
ekle.a_kle       
ema.a_ma         
ekl.a_kl         
eeng.a_eng       
eiovtot.a_io     
einvv.a_inv      
einvpv.a_invp    
einv.v_inv       
ekavc.a_kavc     
eydisp.v_ydisp   
etsave.v_hcdtot  
egcv.a_gc        
exdtot.a_xd      
eydem.a_y        
eabsor.a_xxd     
epwxo.p_impo     
epimpl.p_imp     
eexpol.a_expo    
eimpl.a_imp      
eimpo.a_impo     
efgrbtotl.v_fgrb 
evatot.v_va      
efsefat.v_fsefat 
efsefa.v_fsefa   
efcftot.v_fc     
esavel.v_save    
esurpl.v_surpl   
evu.v_vu         
ewpi.rltlrworld    
ephcfv.P_HCFV    
ehcfvpv.A_hcfvpv 
eHCV.A_HC        
eHCFV.A_HCFV     
epek.P_EKAV      
/
;
**----------------------------------------------------------------------------------------------------------------------*
*----------------------------------------- Baseline Scenario Assumptions ----------------------------------------------*
*----------------------------------------------------------------------------------------------------------------------*
Parameters
* ----------------------------------------  Loaded from Baseline_Assumptions.xlsx -------------------------------------*
* Real interest rate
exo_rltlr(reg,stime)                            Exogenous real interest rate (when trade of balance is free)
* Technical Progress
exo_tfp(pr,reg,stime)                           Exogenous total productivity tfp
exo_tgl(reg,stime)                              Exogenous labour productivity tgl
exo_tgk(pr,reg,stime)                           Exogenous capital productivity tgk
exo_tgm(pr,br,reg,stime)                        Exogenous materials productivity tgm
exo_tge(pr,br,reg,stime)                        Exogenous energy productivity tge
;
*----------------------------------------------------------------------------------------------------------------------*
*                                                        Switches
*----------------------------------------------------------------------------------------------------------------------*
*        Capital mobility
*        Full mobility between national firms but not internationally
swonkm(pr,er,rtime3)      = 1;
*----------------------------------------------------------------------------------------------------------------------*
*                                                         Load Exogenous Assumptions
*----------------------------------------------------------------------------------------------------------------------*
* Real Interest rates (remains at base year level)
exo_rltlr(er,rtime3)         = sum(byear, RLTLR.l(er,byear));
exo_tgl(er,rtime3)           = 0;
exo_tgk(pr,er,rtime3)        = 0;
exo_tge(pr,br,er,rtime3)     = 0;
exo_tgm(pr,br,er,rtime3)     = 0;
*----------------------------------------------------------------------------------------------------------------------*
*                                                Population, Labour Force and Employment
*----------------------------------------------------------------------------------------------------------------------*
TotLabFrc(er,rtime)$(rtime.val > byear.val) = TotLabFrc(er,byear);
*----------------------------------------------------------------------------------------------------------------------*
*                                                 Government Expenditure
*----------------------------------------------------------------------------------------------------------------------*
gctv(er,rtime)$(rtime.val > byear.val) = gctv(er,byear);
*----------------------------------------------------------------------------------------------------------------------*
*                                              Expected Investment by sector
*----------------------------------------------------------------------------------------------------------------------*
stgr(pr,er,rtime)$(rtime.val > byear.val) = stgr(pr,er,byear);
*----------------------------------------------------------------------------------------------------------------------*
*                                                 Social Time Preference
*----------------------------------------------------------------------------------------------------------------------*
stp(er,rtime)$(rtime.val > byear.val)     = stp(er,byear);
*----------------------------------------------------------------------------------------------------------------------*
*                                                   Technical Progress
*----------------------------------------------------------------------------------------------------------------------*
* Total Factor Productivity
tfpexo(br,er,rtime)     $(rtime.val > byear.val)    = 1;
* Labour
TGL(br,er,rtime)        $(rtime.val > byear.val)     = exo_tgl(er,rtime);
* Capital
tgk(br,er,rtime)        $(rtime.val > byear.val)     = exo_tgk(br,er,rtime);
* Materials
tgm(prma,br,er,rtime)   $(rtime.val > byear.val)     = exo_tgm(prma,br,er,rtime);
* Energy
tge(prfele,br,er,rtime) $(rtime.val > byear.val)     = exo_tge(prfele,br,er,rtime) ;

*----------------------------------------------------------------------------------------------------------------------*
*----------------------------------------- Scenario Assumptions -------------------------------------------------------*
*----------------------------------------------------------------------------------------------------------------------*
* Increase demand for PV equipmet by USD 50 billion at base year values at 2030
$if  %sw_scen% == "1"  public_gc(pr_pve,"R1",rtime)$(rtime.val = 2030)  = 10 / P_GC.l(pr_pve,"R1",byear);
* Increase demand for PV equipmet by USD 50 billion at base year values at the period 2030 - 2050
$if  %sw_scen% == "2"  public_gc(pr_pve,"R1",rtime)$(rtime.val ge 2030) = 10 / P_GC.l(pr_pve,"R1",byear);

* No capital mobility for specific sectors
$if  %sw_mobility% == "0"    swonkm(pr_pve,er,rtime) $(rtime.val > 2020) = 0;
$if  %sw_mobility% == "0"    swonkm(pr_con,er,rtime) $(rtime.val > 2020) = 0;

*----------------------------------------------------------------------------------------------------------------------*
* FIX variables
*----------------------------------------------------------------------------------------------------------------------*
* Numeraire
P_WPI.fx(rtime)             $(rtime.val ge byear.val) = 1.0 ;
P_IO.fx("SRV","R2",rtime)   $(rtime.val ge byear.val) = P_WPI.l(rtime) * P_IO.l("SRV","R2",byear);

A_KAVC.fx(pr,er,pbyear)     = A_KAVC.L(pr,er,pbyear);
RLTLR.fx(er,rtime)          = RLTLR.L(er,byear);

*###############################################################################
*                              SIMULATION
*###############################################################################
$if %sw_ratexp% == "0"   $include '%path%\Solve_Myopic.gms'; 
$if %sw_ratexp% == "1"   $include '%path%\Solve_Rational.gms'; 
* ---------------------------------------------------------------------------------------------------------------------*
* ------------------------------------------   Equilibrium checks  ----------------------------------------------------*
* ---------------------------------------------------------------------------------------------------------------------*
* Walras law
ERRFL(er,an)        = sum(se,  V_SURPL.L(se,er,an));
* Zero profit
ZEROPROF(br,er,an)  = P_PDBSR.L(br,er,an)*A_XD.L(br,er,an)
                    - sum(pr,   A_IO.L(pr,br,er,an)*P_IO.L(pr,er,an))
                    - P_LAV.l(br,er,an)*A_LAV.l(br,er,an)
                    - P_KAV.l(br,er,an)*A_KAV.l(br,er,an);

ERRIOVALS(pr,er,an) =
                         P_PD.L(pr,er,an)*A_XD.L(pr,er,an)
                       + V_FGRB.L("IT",pr,er,an)
                       + P_IMP.L(pr,er,an)*A_IMP.L(pr,er,an)
                       -(
                            SUM(br, P_IO.L(pr,er,an)*A_IO.L(pr,br,er,an))
                          + P_HC.L(pr,er,an)*A_HC.L(pr,er,an)
                          + P_GC.L(pr,er,an)*A_GC.L(pr,er,an)
                          + P_INVP.L(pr,er,an)*SUM(br,A_INVP.L(pr,br,er,an))
                          + P_PWE.L(pr,er,an)*SUM(cr, A_EXPO.l(pr,er,cr,an))
                        );

errortest(er,an)  = smax(pr, abs(ERRIOVALS(pr,er,an)));

abort$(smax((er,an), abs(errfl(er,an)))     gt  1e-2) "errfl is not equal to zero",      errfl;
abort$(smax((er,an), abs(errortest(er,an))) gt  1e-2) "erriovals is not equal to zero",  errortest;


Parameters
Report(*,*,reg,stime)       Reporting
;

Report("P_KAV",pr,er,an)  = P_KAV.l(pr,er,an);
Report("A_INV",pr,er,an)  = A_INV.l(pr,er,an);
Report("SH_EXP",pr,er,an) = (P_PWE.l(pr,er,byear) * sum(cr, A_EXPO.l(pr,er,cr,an)))
                          / (P_PD.l(pr,er,byear) * A_XD.l(pr,er,an));
Report("SH_IMP",pr,er,an) = (P_IMP.l(pr,er,byear) * A_IMP.l(pr,er,an))
                          / (P_Y.l(pr,er,byear) * A_Y.l(pr,er,an));
Report("PROD",pr,er,an)    = P_XD.l(pr,er,byear) * A_XD.l(pr,er,an);
Report("EXPORTS",pr,er,an) = P_PWE.l(pr,er,byear) * sum(cr, A_EXPO.l(pr,er,cr,an));
Report("IMPORTS",pr,er,an) = sum(cr, P_PWE.l(pr,cr,byear) * A_EXPO.l(pr,cr,er,an));
Report("INV",pr,er,an)     = P_INVP.L(pr,er,byear) * SUM(br, A_INVP.L(pr,br,er,an));
Report("HC",pr,er,an)      = P_HC.L(pr,er,byear) * A_HC.L(pr,er,an);
Report("GC",pr,er,an)      = P_GC.L(pr,er,byear) * A_GC.L(pr,er,an);


execute_unload    '%path%\Report_Maquette.gdx',   Report;
execute "GDXXRW  i=%path%\Report_Maquette.gdx     o=%path%\Report_Maquette.xlsx    par=Report         Rng=%scenario%!b2  RDIM=4  CDIM=0  DIM=4";












