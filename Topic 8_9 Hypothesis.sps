* Encoding: UTF-8.

Exploration of Data Analysis (Normality)

EXAMINE VARIABLES=y
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


//testing hytpothesis different for one sample, testing the overall data with the standard

T-TEST
  /TESTVAL=20
  /MISSING=ANALYSIS
  /VARIABLES=y
  /CRITERIA=CI(.95).

// testing between 2 groups

T-TEST GROUPS=x1(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=y
  /CRITERIA=CI(.95).

RECODE x2 (500=1) (500.1 thru 1000=2) (1001 thru Highest=3) INTO dose.cat.
EXECUTE.

// test for more groups

ONEWAY y BY dose.cat
  /STATISTICS DESCRIPTIVES HOMOGENEITY 
  /MISSING ANALYSIS
  /POSTHOC=TUKEY ALPHA(0.05).

// bandingan antara different time

konon2 time 1 and time 2

T-TEST PAIRS=y WITH x2 (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.


/// data non para

NPAR TESTS
  /M-W= y BY x1(1 2)
  /MISSING ANALYSIS.

SORT CASES  BY x1.
SPLIT FILE LAYERED BY x1.

FREQUENCIES VARIABLES=y
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MEDIAN
  /ORDER=ANALYSIS.

SPLIT FILE OFF. 

/// kurskal walis

NPAR TESTS
  /K-W=y BY dose.cat(1 3)
  /MISSING ANALYSIS.

SORT CASES  BY dose.cat.
SPLIT FILE LAYERED BY dose.cat.

FREQUENCIES VARIABLES=y
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MEDIAN
  /ORDER=ANALYSIS.

SPLIT FILE OFF. 

// wilcoxon

NPAR TESTS
  /WILCOXON=y WITH x2 (PAIRED)
  /MISSING ANALYSIS.

FREQUENCIES VARIABLES=y x2
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MEDIAN
  /ORDER=ANALYSIS.

=====16/2/2022 ===== Correlation and Regression ====

IV - numeric
DV - numeric

Correlation :
1) Pearson Correlation - Data normal, IV dan DV dalam numeric (IR - Interval and Ratio Scale) - Scale data
2) Spearman Rho Correlation - Data X normal, IV / DV dalam bentuk data numeric yang x normal / IV dan DV yang ordinal

r - value (NOR = Nature of Relationship : Strength dan Direction - Arah positive/ negative, Streght Gliford Rule of Thumb)
(Pearson Correlation)

NOR:
Strenght +-1 nilai r anda mesti dalam julat +-1. Cth 0.987, -0.564, IF you get more than 1.23 r- value (SALAH KIRA)

// follow scientific judgement

Gliford Rule of Thumb
 <0.2 - negligeable (abaikan) 
 0.2 - 0.4 - Low
 0.4 - 0.7 - Medium
 0.7 - 0.9 - High
 >0.9 - Very high
 
Direction = -+, cth 0.998 positive very high correlation; r- value = -0.678 - negative medium correlation
 
membuat ujian hipotesis - formula ujian t-statistic: r/1-r2/punca kuasa n-2 (rujuk formula). jadual t untuk bandingkan dalam/ luar kawasa

utk decide wheter reject/ fail to reject.

====

rs-value (spearman) - data xnormal, ordinal scale.
NOR, direction and strenght.

// RUN the data analysis

one/ two tail menentukan dari aspek slope kemana

Step 1: Null = There is no significant relationship between x (dose) and y (TL) // had been rejected
Alternative = There is significant relationship between x and y 

Step 2:
Alpha = 0.05

Step 3:

CORRELATIONS
  /VARIABLES=x2 y
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

Step 4: Decision based on p-value, report statistical value (r-value) p-value:
r-value: 0.803 (NOR) - Positive high correlation
p-value: (compare against our hypothetical alpha), "p<0.001" jgn tulis .000
Decision = reject? or fail to reject? = alpha 0.05, p<0.001, LESS THAN ALPHA - REJECT NULL

Step 5:
Conclusion (based on hypothesis decision) - reject null (p-value less than alpha)
There is significant relationship between the dose (x) and tooth lenght (y) at the significant level 0.05. 
Where the r-value is 0.803 corresponding the nature of positive and high correlation.  Therefore, the dose is
one of the factor that may influence the tooth growth. 

===

NONPAR CORR
  /VARIABLES=x2 y
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

Step 1 - Step 5.. r-value SALAH, rs-value

==== END OF The ANALYSIS ===

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT y
  /METHOD=ENTER x2.

1) Descriptive (PE, R, R2)
2) Model Fit (Hypothesis test)
3) Significant Predictor (Hypothesis test)

Descriptive - 

R = 0.803
R2 = 0.644 = x 100 = 64.4% of variance explain by the x to predict the y
64.4% perkara yang dalam episod panjang gigi diceritakan oleh dose

Yhat = 0.01dose + 7.423

2) Model fit

Step1: 
Null: There is no significant model fit between variables (rejected)
Alternative: There is significant model fit between variables

Step2:
Alpha = 0.05

Step3:
Run and Report =
ANOVA Table = F-stat = 105.065
p-value = p<0.001

Step4: alpha = 0.05, p-value = p<0.001 oleh itu REJECT NULL
Decision = REJECT NULL hypothesis, alpha 0.05, p-value kurang dari alpha value kita

Step5:
Conclusion = There is statistically significant model fit between x and y. Where F-stat = 105.065 and the p-value
= p<0.001. The model shows the x able to fit with the y.

====

Significant predictor

NULL = Assumption of ORIGIN

Step1:
H0: There is no signficant predictor between dose and TL (reject)
Ha/ Hr: There is signficant predictor between dose and TL

Step2:alpha

Step3: Run and Report
Coefficient Table
t-stat = 10.250
p-value = p<0.001

Step4: Decision
LESS THAN ALPHA = REJECT
MORE THAN ALPHA = FAIL TO REJECT

p-value(p <0.001) < alpha 0.05 = REJECT

Step5:
Conclusion
There is significant prediction between the dose and TL at the significant level (alpha), 0.05. Where the t-stat = 10.250, and the p-value 
is p<0.001.

==== dummy variable ==

0, 1

RECODE x1 (1=1) (2=0) INTO x1.new.
EXECUTE.

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT y
  /METHOD=ENTER x2 x1.new.

=== Bangsa ===
1,2,3,4 = 1,0; 1,0 4 variables
