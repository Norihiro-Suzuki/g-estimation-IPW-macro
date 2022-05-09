libname a "C:\Users\suzun\Desktop\卒論\ORACLEデータ";
data df1;
	set a.tr_demog;
run;
ods graphics on;
/*データの標準化*/
proc standard data=df1 out=df2  m=0 std=1;
	var gen_:;
run;


/*DAS以外のアウトカムにマージ用のデータ作成*/
data mergedata_origin;
	set df2;
	drop das28d_3 _NAME_;
run;
proc print data=mergedata_origin;
run;






/*Validation解析用のマージ用のデータ作成*/
libname a "C:\Users\suzun\Desktop\卒論\ORACLEデータ";
data oracle2;
	set a.oracle2;
run;
proc print data=oracle2;
run;
/*データの分割*/
data visit0 visit3 visit6 visit12;
	set oracle2;
	if visit=0 then output visit0;
	if visit=3 then output visit3;
	if visit=6 then output visit6;
	if visit=12 then output visit12;
run;
data visit0;
   set visit0;
   keep studyId varname rel_v ;
run;
data visit3;
   set visit3;
   keep studyId varname rel_v ;
run;
data visit6;
   set visit6;
   keep studyId varname rel_v ;
run;
data visit12;
   set visit12;
   keep studyId varname rel_v ;
run;
/*studyIdを昇順にソート*/
proc sort data=visit0;
	by studyId;
run;
proc sort data=visit3;
	by studyId;
run;
proc sort data=visit6;
	by studyId;
run;
proc sort data=visit12;
	by studyId;
run;
/*横長データに変換*/
proc transpose data=visit0 out=visit0;
 var rel_v;
 id varname;
 by studyId;
run;
data visit0;
	set visit0;
	drop _NAME_ _LABEL_ ;
run;
proc transpose data=visit3 out=visit3;
 var rel_v;
 id varname;
 by studyId;
run;
data visit3;
	set visit3;
	drop _NAME_ _LABEL_ ;
run;
proc transpose data=visit6 out=visit6;
 var rel_v;
 id varname;
 by studyId;
run;
data visit6;
	set visit6;
	drop _NAME_ _LABEL_ ;
run;
proc transpose data=visit12 out=visit12;
 var rel_v;
 id varname;
 by studyId;
run;
data visit12;
	set visit12;
	drop _NAME_ _LABEL_ ;
run;

/*確認用*/
/*proc print data=visit0;*/
/*run;*/
/*proc print data=visit3;*/
/*run;*/
/*proc print data=visit6;*/
/*run;*/
/*proc print data=visit12;*/
/*run;*/
/*visit12の個体はtrdemog/DAS28CRPと同一*/
data visit0;
   set visit0;
   if studyId="AO_022" then delete;
	if studyId="AO_024" then delete;
	if studyId="AO_031" then delete;
	if studyId="AY_006" then delete;
	if studyId="AY_010" then delete;
	if studyId="AY_016" then delete;
	if studyId="AY_019" then delete;
run;
/*t=0-12のデータ作成*/
data visit0;
	set visit0;
	drop studyId ;
run;
data visit12_2;
	set visit12;
	drop studyId;
run;

proc iml;
  use visit12_2;
    read all into x[COLNAME=varname];
  use visit0;
    read all into y;
  z = x - y;
  create visit0_12 from z[COLNAME=varname];
  append from z;
quit;
data visit12;
	 set visit12;
	 keep studyId;
/*データ標準化*/
proc standard data=visit0_12 out=visit0_12  m=0 std=1;
run;
data mergedata_validation;
	merge visit12 visit0_12;
run;
proc print data=mergedata_validation;
run;





/*IgGデータ作成*/
data IgG;
input studyId$ IgG_0 IgG_3 IgG_6 IgG_12 IgG_d3;
cards;
AO_001	1125.718	1227.083	955.9055	1129.898	-4.18
AO_003	721.8255	405.1905	397.353	492.9705	228.855
AO_004	766.7605	744.8155	786.6155	878.5755	-111.815
AO_005	794.9755	708.2405	622.028	456.918	338.0575
AO_007	632.478	635.0905	527.978	462.6655	169.8125
AO_010	592.768	591.723	693.088	690.4755	-97.7075
AO_011	1235.9655	1096.62132	1042.118	1030.623	205.3425
AO_012	2041.138	1931.9355	1651.8755	1763.168	277.97
AO_014	508.6455	463.7105	501.05259	499.21015	9.43535
AO_015	961.653	689.90269	702.705	751.1082	210.5448
AO_016	1095.4768	721.8646	732.957	688.0832	407.3936
AO_019	1145.3926	810.6038	846.402	811.108	334.2846
AO_021	808.0828	701.6966	761.1922	739.0074	69.0754
AO_023	712.2848	629.596	598.3356	739.5116	-27.2268
AO_025	651.2766	373.4624	354.807	462.7058	188.5708
AO_026	649.2598	631.6128	538.3358	574.6382	74.6216
AO_027	891.2758	704.2176	687.0748	782.3686	108.9072
AO_028	292.7904	317.4962	277.1602	306.21456	-13.42416
AO_029	445.0588	442.5378	396.6556	494.9746	-49.9158
AO_030	483.8822	433.34292	378.99094	417.22157	66.66063
AY_001	786.2298	567.8358	728.6532	549.9672	236.2626
AY_002	675.0474	515.5536	589.6752	499.6704	175.377
AY_004	2118.36195	1588.23115	1524.9999	1263.36214	854.99981
AY_007	736.37975	742.9558	702.99365	677.1953	59.18445
AY_008	758.63715	672.64265	782.4121	851.71355	-93.0764
AY_009	830.9737	713.11065	632.6805	627.622	203.3517
AY_018	419.2118	362.5566	263.91585	271.5036	147.7082
AY_020	591.70665	621.04595	733.8505	748.473	-156.76635
;
run;
data IgG;
	set IgG;
	keep studyId IgG_d3;
run;




/*originalとマージ*/
data IgGorigin;
	merge IgG mergedata_origin;
	by studyId;
run;
data IgGorigin;
   set IgGorigin;
   if IgG_d3=. then delete;
run;
proc print data=IgGorigin;
run;





/*validationとマージ*/
data IgGValidation;
	merge IgG mergedata_validation;
	by studyId;
run;
data IgGValidation;
   set IgGvalidation;
   if IgG_d3=. then delete;
run;
proc print data=IgGValidation;
run;










/*IgGをアウトカムとした場合のオリジナルデータでの解析*/
ODS TRACE ON;
/*標準化データでのLasso回帰モデル Solution Pathの作成*/
proc glmselect data=IgGorigin plots=all  seed=12345 ;
	model IgG_d3=gen_: / selection=lasso(choose=cv stop=none) cvmethod=random(10) STB;
	output;
run;
/** ODS TRACEステートメントの解除 **/
ODS TRACE OFF;

/*変数選択後のモデル評価*/
proc glm data=IgGorigin;
model IgG_d3 =
gen_213
gen_328 
gen_359 
gen_491 
gen_784 
gen_796
gen_886 
gen_987 
gen_1019 
gen_1033 
gen_1039
gen_1339
gen_1348  
gen_1621 
gen_1661
gen_1832 
gen_1839 
gen_1892 
gen_1901 
gen_1907 
gen_1984 
;
run;
/*Bootstrapサンプリング*/
proc surveyselect data=IgGorigin method=urs outhits noprint
rep=10/*繰り返し抽出の数*/  
n=35 /*元データのn*/ seed=12345 out=IgGbootorigin/*保存先*/;
run;
/*サンプルごとにLasso*/
ODS OUTPUT    ParameterEstimates = IgGoriginparameter;
proc glmselect data=IgGbootorigin seed=12345;
	by replicate;
	model IgG_d3=gen_: / selection=lasso(choose=cv stop=none) cvmethod=random(10) STB;
run;
/*Bootstrap&Lassoのパラメータ結果を取得*/
 data ParameterNameIgGorigin;
   set IgGoriginparameter;
   keep Parameter;
run;
/*パラメータの集計*/
ODS TRACE ON;
ODS OUTPUT OneWayFreqs =RankingIgGorigin;
proc freq data=ParameterNameIgGorigin;
run;
ODS TRACE OFF;
/*余計な列を削除*/
data RankingIgGorigin;
   set RankingIgGorigin;
   keep Parameter Frequency;
run;
/*ランキングを降順にソート*/
proc sort data=RankingIgGorigin;
	key Frequency / descending;
run;
proc print data=RankingIgGorigin;
run;









/*IgGをアウトカムとした場合のValidationデータでの解析*/
ODS TRACE ON;
/*標準化データでのLasso回帰モデル Solution Pathの作成*/
proc glmselect data=IgGvalidation plots=all  seed=12345 ;
	model IgG_d3=ACE--SCN1B/ selection=lasso(choose=cv stop=none) cvmethod=random(10) STB;
	output;
run;
/** ODS TRACEステートメントの解除 **/
ODS TRACE OFF;

/*変数選択後のモデル評価*/
proc glm data=IgGvalidation;
model IgG_d3 =
ACE 
C1S 
C20orf18  
C21orf55
CD2BP2 
CDH3 
CFDP1 
CLEC12A 
GPR172A 
NDE1 
NTHL1
PARK2 
PCNA 
SDHB 
SLC1A1
SRPR 
TSSC4
ZADH2 
ZNF559
RNF149 
;
run;
/*Bootstrapサンプリング*/
proc surveyselect data=IgGvalidation method=urs outhits noprint
rep=10/*繰り返し抽出の数*/  
n=35 /*元データのn*/ seed=12345 out=IgGbootvalidation/*保存先*/;
run;
/*サンプルごとにLasso*/
ODS OUTPUT    ParameterEstimates = IgGvalidationparameter;
proc glmselect data=IgGbootvalidation seed=12345;
	by replicate;
	model IgG_d3=ACE--SCN1B/ selection=lasso(choose=cv stop=none) cvmethod=random(10) STB;
run;
/*Bootstrap&Lassoのパラメータ結果を取得*/
 data ParameterNameIgGvalidation;
   set IgGvalidationparameter;
   keep Parameter;
run;
/*パラメータの集計*/
ODS TRACE ON;
ODS OUTPUT OneWayFreqs =RankingIgGvalidation;
proc freq data=ParameterNameIgGvalidation;
run;
ODS TRACE OFF;
/*余計な列を削除*/
data RankingIgGvalidation;
   set RankingIgGvalidation;
   keep Parameter Frequency;
run;
/*ランキングを降順にソート*/
proc sort data=RankingIgGvalidation;
	key Frequency / descending;
run;
proc print data=RankingIgGvalidation;
run;
