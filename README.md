
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rwicc

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/d-morrison/rwicc.svg?branch=master)](https://travis-ci.com/d-morrison/rwicc)
[![R-CMD-check](https://github.com/d-morrison/rwicc/workflows/R-CMD-check/badge.svg)](https://github.com/d-morrison/rwicc/actions)
<!-- badges: end -->

rwicc (“Regression With Interval-Censored Covariates”) is an R software
package implementing an analysis for a particular regression modeling
problem involving interval-censored covariates, as described in
“Regression with Interval-Censored Covariates: Application to
Cross-Sectional Incidence Estimation” by Morrison, Laeyendecker, and
Brookmeyer (2021) in Biometrics (<https://doi.org/10.1111/biom.13472>).

This analysis uses a joint model for the distributions of the outcome of
interest and the interval-censored covariates; the model is maximized
using an EM algorithm. The submodel used for the distribution of the
interval-censored covariate is somewhat specific to the application of
interest (estimation of the mean duration of a biomarker-defined window
period for cross-sectional incidence estimation), so this package may
not be immediately applicable to other problems. We are publishing it
with the goal of making the results in our paper easier to reproduce and
with the hope that others might adapt pieces of this code for their own
applications. Please feel free to [contact us](dmorrison01@ucla.edu)
with any questions about the code or the paper!

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("d-morrison/rwicc")
```

## Example of use

Here, we simulate some data:

``` r
library(rwicc)
#> Registered S3 method overwritten by 'pryr':
#>   method      from
#>   print.bytes Rcpp

theta_true = c(0.986, -3.88)
study_cohort_size = 4500
preconversion_interval_length = 365
hazard_alpha = 1
hazard_beta = 0.5

set.seed(1)
sim_data = simulate_interval_censoring(
  theta = theta_true,
  study_cohort_size = study_cohort_size,
  preconversion_interval_length = preconversion_interval_length,
  hazard_alpha = hazard_alpha,
  hazard_beta = hazard_beta)

# extract the participant-level and observation-level simulated data:
sim_participant_data = sim_data$pt_data
sim_obs_data = sim_data$obs_data
rm(sim_data)
```

Here, we apply our proposed analysis (this takes a couple of minutes;
use argument `verbose = TRUE` to print progress messages):

``` r
# this call runs the estimation algorithm for the joint modeling approach:
EM_algorithm_outputs = fit_joint_model(
  obs_level_data = sim_obs_data,
  subject_level_data = sim_participant_data,
  bin_width = 7,
  verbose = TRUE)
#> Starting `fit_joint_model();`, mem used = 153 MB
#> initial estimate for mu = 183.80818; initial estimate for theta:
#> (Intercept)           T 
#>    1.672487   -3.662889
#> 2021-05-21 18:14:46: starting EM iteration (E step) 1; mem used = 161 MB
#> Ending E step.
#> observed-data log-likelihood = -680.21393
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 161.15437; theta =
#> (Intercept)           T 
#>    1.512951   -3.877556
#> 
#> Change in mu = 22.6538179668489
#> Max change in theta = 0.214666754177144
#> Max relative change in theta = 0.0953887132359044
#> 2021-05-21 18:14:47: starting EM iteration (E step) 2; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -662.69257
#> Change in log-likelihood = 17.5213569989709
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 150.0032; theta =
#> (Intercept)           T 
#>    1.374246   -3.892790
#> 
#> Change in mu = 11.1511629003479
#> Max change in theta = 0.138704350454229
#> Max relative change in theta = 0.091678043894103
#> 2021-05-21 18:14:48: starting EM iteration (E step) 3; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -657.93947
#> Change in log-likelihood = 4.75310193108726
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 142.92462; theta =
#> (Intercept)           T 
#>    1.274785   -3.884952
#> 
#> Change in mu = 7.07858479703694
#> Max change in theta = 0.0994612280969711
#> Max relative change in theta = 0.0723751139713008
#> 2021-05-21 18:14:49: starting EM iteration (E step) 4; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -655.45714
#> Change in log-likelihood = 2.48232542811365
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 138.26116; theta =
#> (Intercept)           T 
#>    1.209389   -3.882035
#> 
#> Change in mu = 4.66346197338467
#> Max change in theta = 0.0653960213547988
#> Max relative change in theta = 0.0512996472729438
#> 2021-05-21 18:14:49: starting EM iteration (E step) 5; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -653.90211
#> Change in log-likelihood = 1.55503320196215
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 135.09515; theta =
#> (Intercept)           T 
#>    1.166567   -3.884346
#> 
#> Change in mu = 3.16600222182342
#> Max change in theta = 0.042822017908315
#> Max relative change in theta = 0.0354079773465963
#> 2021-05-21 18:14:50: starting EM iteration (E step) 6; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -652.83407
#> Change in log-likelihood = 1.06804336387688
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 132.88527; theta =
#> (Intercept)           T 
#>     1.13794    -3.88919
#> 
#> Change in mu = 2.20988362243276
#> Max change in theta = 0.0286265254922053
#> Max relative change in theta = 0.0245391188107178
#> 2021-05-21 18:14:51: starting EM iteration (E step) 7; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -652.05023
#> Change in log-likelihood = 0.783833302869652
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 131.30685; theta =
#> (Intercept)           T 
#>    1.118330   -3.894758
#> 
#> Change in mu = 1.57842549076616
#> Max change in theta = 0.0196104981774863
#> Max relative change in theta = 0.0172333255767473
#> 2021-05-21 18:14:52: starting EM iteration (E step) 8; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -651.43641
#> Change in log-likelihood = 0.613827067332068
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 130.15855; theta =
#> (Intercept)           T 
#>    1.104620   -3.900191
#> 
#> Change in mu = 1.14829614846525
#> Max change in theta = 0.0137102861047542
#> Max relative change in theta = 0.0122596074104883
#> 2021-05-21 18:14:53: starting EM iteration (E step) 9; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -650.92582
#> Change in log-likelihood = 0.510588391010742
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 129.30933; theta =
#> (Intercept)           T 
#>    1.094875   -3.905169
#> 
#> Change in mu = 0.849219366854612
#> Max change in theta = 0.00974491549092416
#> Max relative change in theta = 0.00882196455171163
#> 2021-05-21 18:14:53: starting EM iteration (E step) 10; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -650.48112
#> Change in log-likelihood = 0.444700615684269
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 128.67018; theta =
#> (Intercept)           T 
#>    1.087833   -3.909614
#> 
#> Change in mu = 0.639146697847679
#> Max change in theta = 0.0070413112183414
#> Max relative change in theta = 0.00643115684999314
#> 2021-05-21 18:14:54: starting EM iteration (E step) 11; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -650.08212
#> Change in log-likelihood = 0.399000995584402
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 128.17909; theta =
#> (Intercept)           T 
#>    1.082641   -3.913540
#> 
#> Change in mu = 0.491090877639607
#> Max change in theta = 0.00519284107888951
#> Max relative change in theta = 0.00477356267608135
#> 2021-05-21 18:14:55: starting EM iteration (E step) 12; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -649.7178
#> Change in log-likelihood = 0.364312745327652
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 127.79241; theta =
#> (Intercept)           T 
#>    1.078706   -3.916990
#> 
#> Change in mu = 0.386682587921953
#> Max change in theta = 0.00393500641629485
#> Max relative change in theta = 0.00363463779355998
#> 2021-05-21 18:14:55: starting EM iteration (E step) 13; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -649.38177
#> Change in log-likelihood = 0.336037565163792
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 127.47944; theta =
#> (Intercept)           T 
#>    1.075620   -3.920016
#> 
#> Change in mu = 0.312967986411039
#> Max change in theta = 0.00308577460283166
#> Max relative change in theta = 0.00286062725650496
#> 2021-05-21 18:14:56: starting EM iteration (E step) 14; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -649.06981
#> Change in log-likelihood = 0.311951840819688
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 127.21876; theta =
#> (Intercept)           T 
#>    1.073103   -3.922667
#> 
#> Change in mu = 0.260686004800547
#> Max change in theta = 0.00265092158007096
#> Max relative change in theta = 0.00233943168802265
#> 2021-05-21 18:14:57: starting EM iteration (E step) 15; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -648.77885
#> Change in log-likelihood = 0.290961306473832
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.99553; theta =
#> (Intercept)           T 
#>    1.070968   -3.924990
#> 
#> Change in mu = 0.223230395341446
#> Max change in theta = 0.00232313482809765
#> Max relative change in theta = 0.00198984228617543
#> 2021-05-21 18:14:58: starting EM iteration (E step) 16; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -648.50639
#> Change in log-likelihood = 0.272464432370043
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.79958; theta =
#> (Intercept)           T 
#>    1.069089   -3.927028
#> 
#> Change in mu = 0.19594590453093
#> Max change in theta = 0.00203852674423377
#> Max relative change in theta = 0.00175423630869232
#> 2021-05-21 18:14:58: starting EM iteration (E step) 17; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -648.25033
#> Change in log-likelihood = 0.256060371186322
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.62397; theta =
#> (Intercept)           T 
#>    1.067387   -3.928821
#> 
#> Change in mu = 0.175607395574275
#> Max change in theta = 0.00179283487090576
#> Max relative change in theta = 0.00159284106576814
#> 2021-05-21 18:14:59: starting EM iteration (E step) 18; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -648.0089
#> Change in log-likelihood = 0.241432561303327
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.46395; theta =
#> (Intercept)           T 
#>    1.065808   -3.930403
#> 
#> Change in mu = 0.160019440458626
#> Max change in theta = 0.00158159183516116
#> Max relative change in theta = 0.0014790015673291
#> 2021-05-21 18:15:00: starting EM iteration (E step) 19; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -647.78058
#> Change in log-likelihood = 0.228310654477696
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.31624; theta =
#> (Intercept)           T 
#>    1.064321   -3.931803
#> 
#> Change in mu = 0.147709624697697
#> Max change in theta = 0.00148717318853153
#> Max relative change in theta = 0.00139534827775804
#> 2021-05-21 18:15:01: starting EM iteration (E step) 20; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -647.56412
#> Change in log-likelihood = 0.216461162308633
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.17854; theta =
#> (Intercept)           T 
#>    1.062904   -3.933048
#> 
#> Change in mu = 0.137699912026235
#> Max change in theta = 0.00141643600056018
#> Max relative change in theta = 0.00133083570833958
#> 2021-05-21 18:15:01: starting EM iteration (E step) 21; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -647.35844
#> Change in log-likelihood = 0.205685368486911
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 126.0492; theta =
#> (Intercept)           T 
#>    1.061545   -3.934159
#> 
#> Change in mu = 0.129342245505626
#> Max change in theta = 0.00135899999709932
#> Max relative change in theta = 0.00127857233766267
#> 2021-05-21 18:15:02: starting EM iteration (E step) 22; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -647.16262
#> Change in log-likelihood = 0.195817274587966
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.927; theta =
#> (Intercept)           T 
#>    1.060235   -3.935156
#> 
#> Change in mu = 0.122204605728072
#> Max change in theta = 0.00131027479193913
#> Max relative change in theta = 0.00123430891650818
#> 2021-05-21 18:15:03: starting EM iteration (E step) 23; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.9759
#> Change in log-likelihood = 0.186720255530417
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.811; theta =
#> (Intercept)           T 
#>    1.058968   -3.936053
#> 
#> Change in mu = 0.115994629542413
#> Max change in theta = 0.00126743895975201
#> Max relative change in theta = 0.00119543211229236
#> 2021-05-21 18:15:03: starting EM iteration (E step) 24; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.79762
#> Change in log-likelihood = 0.178282916505736
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.70049; theta =
#> (Intercept)           T 
#>    1.057739   -3.936865
#> 
#> Change in mu = 0.110509821623779
#> Max change in theta = 0.0012287418698409
#> Max relative change in theta = 0.00116032059970476
#> 2021-05-21 18:15:04: starting EM iteration (E step) 25; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.6272
#> Change in log-likelihood = 0.170414846215294
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.59489; theta =
#> (Intercept)           T 
#>    1.056546   -3.937602
#> 
#> Change in mu = 0.105605795614494
#> Max change in theta = 0.00119307321461837
#> Max relative change in theta = 0.00112794689812896
#> 2021-05-21 18:15:05: starting EM iteration (E step) 26; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.46416
#> Change in log-likelihood = 0.163042719702503
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.49371; theta =
#> (Intercept)           T 
#>    1.055386   -3.938274
#> 
#> Change in mu = 0.1011763051537
#> Max change in theta = 0.00115970491506312
#> Max relative change in theta = 0.00109763815229962
#> 2021-05-21 18:15:05: starting EM iteration (E step) 27; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.30805
#> Change in log-likelihood = 0.156106948825141
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.39657; theta =
#> (Intercept)           T 
#>    1.054258   -3.938890
#> 
#> Change in mu = 0.0971407636812245
#> Max change in theta = 0.00112813979022053
#> Max relative change in theta = 0.00106893567998685
#> 2021-05-21 18:15:06: starting EM iteration (E step) 28; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.15849
#> Change in log-likelihood = 0.149558913452665
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.30313; theta =
#> (Intercept)           T 
#>    1.053160   -3.939455
#> 
#> Change in mu = 0.0934364144811752
#> Max change in theta = 0.00109802412629589
#> Max relative change in theta = 0.00104151377956745
#> 2021-05-21 18:15:06: starting EM iteration (E step) 29; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -646.01514
#> Change in log-likelihood = 0.143358724071277
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.21312; theta =
#> (Intercept)           T 
#>    1.052091   -3.939977
#> 
#> Change in mu = 0.0900133447968017
#> Max change in theta = 0.00106909737892957
#> Max relative change in theta = 0.00101513303639588
#> 2021-05-21 18:15:07: starting EM iteration (E step) 30; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.87766
#> Change in log-likelihood = 0.137473436358164
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.12629; theta =
#> (Intercept)           T 
#>     1.05105    -3.94046
#> 
#> Change in mu = 0.0868312254791448
#> Max change in theta = 0.00104116289491629
#> Max relative change in theta = 0.000989613177666924
#> 2021-05-21 18:15:08: starting EM iteration (E step) 31; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.74579
#> Change in log-likelihood = 0.131875635300844
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 125.04243; theta =
#> (Intercept)           T 
#>    1.050036   -3.940910
#> 
#> Change in mu = 0.0838571001026054
#> Max change in theta = 0.00101407030296041
#> Max relative change in theta = 0.000964816780676758
#> 2021-05-21 18:15:08: starting EM iteration (E step) 32; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.61924
#> Change in log-likelihood = 0.12654231514091
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.96137; theta =
#> (Intercept)           T 
#>    1.049048   -3.941330
#> 
#> Change in mu = 0.0810638213681045
#> Max change in theta = 0.000987704305980719
#> Max relative change in theta = 0.000940638927711794
#> 2021-05-21 18:15:09: starting EM iteration (E step) 33; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.49779
#> Change in log-likelihood = 0.121453993616569
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.88294; theta =
#> (Intercept)           T 
#>    1.048086   -3.941723
#> 
#> Change in mu = 0.0784288977718575
#> Max change in theta = 0.000961977009570125
#> Max relative change in theta = 0.000917000136030468
#> 2021-05-21 18:15:10: starting EM iteration (E step) 34; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.3812
#> Change in log-likelihood = 0.116594010958693
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.807; theta =
#> (Intercept)           T 
#>    1.047149   -3.942093
#> 
#> Change in mu = 0.0759336113875833
#> Max change in theta = 0.00093682226254499
#> Max relative change in theta = 0.00089384114219749
#> 2021-05-21 18:15:11: starting EM iteration (E step) 35; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.26925
#> Change in log-likelihood = 0.111947974446025
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.73344; theta =
#> (Intercept)           T 
#>    1.046237   -3.942442
#> 
#> Change in mu = 0.073562323953027
#> Max change in theta = 0.000912191232130377
#> Max relative change in theta = 0.000871118817802618
#> 2021-05-21 18:15:11: starting EM iteration (E step) 36; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.16175
#> Change in log-likelihood = 0.107503317779106
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.66214; theta =
#> (Intercept)           T 
#>    1.045349   -3.942773
#> 
#> Change in mu = 0.0713019205418419
#> Max change in theta = 0.000888048809216668
#> Max relative change in theta = 0.000848802842183976
#> 2021-05-21 18:15:12: starting EM iteration (E step) 37; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -645.0585
#> Change in log-likelihood = 0.103248951194701
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.593; theta =
#> (Intercept)           T 
#>    1.044484   -3.943087
#> 
#> Change in mu = 0.0691413586504837
#> Max change in theta = 0.00086437064053424
#> Max relative change in theta = 0.000826872946275737
#> 2021-05-21 18:15:13: starting EM iteration (E step) 38; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.95932
#> Change in log-likelihood = 0.0991749834614666
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.52593; theta =
#> (Intercept)           T 
#>    1.043643   -3.943388
#> 
#> Change in mu = 0.0670713004630699
#> Max change in theta = 0.000841140668409457
#> Max relative change in theta = 0.000805316619694319
#> 2021-05-21 18:15:13: starting EM iteration (E step) 39; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.86405
#> Change in log-likelihood = 0.0952725009267397
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.46084; theta =
#> (Intercept)           T 
#>    1.042825   -3.943675
#> 
#> Change in mu = 0.0650838125106219
#> Max change in theta = 0.000818349101702642
#> Max relative change in theta = 0.00078412721290383
#> 2021-05-21 18:15:14: starting EM iteration (E step) 40; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.77252
#> Change in log-likelihood = 0.0915333919263048
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.39767; theta =
#> (Intercept)           T 
#>    1.042029   -3.943951
#> 
#> Change in mu = 0.0631721203248361
#> Max change in theta = 0.000795990763564181
#> Max relative change in theta = 0.000763302386459614
#> 2021-05-21 18:15:15: starting EM iteration (E step) 41; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.68457
#> Change in log-likelihood = 0.0879502072942842
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.33634; theta =
#> (Intercept)           T 
#>    1.041255   -3.944217
#> 
#> Change in mu = 0.0613304081704484
#> Max change in theta = 0.000774063756068477
#> Max relative change in theta = 0.000742842853247916
#> 2021-05-21 18:15:15: starting EM iteration (E step) 42; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.60005
#> Change in log-likelihood = 0.0845160496253357
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.27679; theta =
#> (Intercept)           T 
#>    1.040502   -3.944474
#> 
#> Change in mu = 0.0595536559345504
#> Max change in theta = 0.000752568403219023
#> Max relative change in theta = 0.000722751379527761
#> 2021-05-21 18:15:16: starting EM iteration (E step) 43; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.51882
#> Change in log-likelihood = 0.0812244854313349
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.21895; theta =
#> (Intercept)           T 
#>    1.039771   -3.944722
#> 
#> Change in mu = 0.0578375059452299
#> Max change in theta = 0.000731506416469463
#> Max relative change in theta = 0.000703031993412393
#> 2021-05-21 18:15:17: starting EM iteration (E step) 44; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.44076
#> Change in log-likelihood = 0.0780694755067088
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.16277; theta =
#> (Intercept)           T 
#>    1.039060   -3.944963
#> 
#> Change in mu = 0.0561781546947628
#> Max change in theta = 0.00071088026041588
#> Max relative change in theta = 0.00068368938109941
#> 2021-05-21 18:15:17: starting EM iteration (E step) 45; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.36571
#> Change in log-likelihood = 0.0750453197695151
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.1082; theta =
#> (Intercept)           T 
#>    1.038369   -3.945197
#> 
#> Change in mu = 0.054572264150508
#> Max change in theta = 0.000690692661523107
#> Max relative change in theta = 0.000664728417370827
#> 2021-05-21 18:15:18: starting EM iteration (E step) 46; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.29356
#> Change in log-likelihood = 0.0721466135738638
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.05518; theta =
#> (Intercept)           T 
#>    1.037698   -3.945426
#> 
#> Change in mu = 0.0530168891975933
#> Max change in theta = 0.000670946249686777
#> Max relative change in theta = 0.000646153821611145
#> 2021-05-21 18:15:19: starting EM iteration (E step) 47; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.22419
#> Change in log-likelihood = 0.0693682130954585
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 124.00367; theta =
#> (Intercept)           T 
#>    1.037047   -3.945648
#> 
#> Change in mu = 0.0515094179252458
#> Max change in theta = 0.000651643294085069
#> Max relative change in theta = 0.000627969903110018
#> 2021-05-21 18:15:19: starting EM iteration (E step) 48; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.15749
#> Change in log-likelihood = 0.0667052078678125
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.95363; theta =
#> (Intercept)           T 
#>    1.036414   -3.945866
#> 
#> Change in mu = 0.0500475222693666
#> Max change in theta = 0.000632785518198009
#> Max relative change in theta = 0.000610180381698601
#> 2021-05-21 18:15:20: starting EM iteration (E step) 49; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.09334
#> Change in log-likelihood = 0.0641528989332301
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.905; theta =
#> (Intercept)           T 
#>    1.035799   -3.946079
#> 
#> Change in mu = 0.0486291167899822
#> Max change in theta = 0.000614373973778948
#> Max relative change in theta = 0.000592788264707389
#> 2021-05-21 18:15:21: starting EM iteration (E step) 50; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -644.03163
#> Change in log-likelihood = 0.0617067813809626
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.85774; theta =
#> (Intercept)           T 
#>    1.035203   -3.946287
#> 
#> Change in mu = 0.0472523242714828
#> Max change in theta = 0.000596408962454165
#> Max relative change in theta = 0.000575795769658913
#> 2021-05-21 18:15:21: starting EM iteration (E step) 51; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.97227
#> Change in log-likelihood = 0.0593625302973351
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.81183; theta =
#> (Intercept)           T 
#>    1.034624   -3.946491
#> 
#> Change in mu = 0.0459154467049387
#> Max change in theta = 0.000578889994319098
#> Max relative change in theta = 0.000559204282681428
#> 2021-05-21 18:15:22: starting EM iteration (E step) 52; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.91515
#> Change in log-likelihood = 0.0571159893554523
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.76721; theta =
#> (Intercept)           T 
#>    1.034062   -3.946692
#> 
#> Change in mu = 0.0446169404340822
#> Max change in theta = 0.000561815769288376
#> Max relative change in theta = 0.000543014339056651
#> 2021-05-21 18:15:23: starting EM iteration (E step) 53; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.86019
#> Change in log-likelihood = 0.054963161432056
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.72386; theta =
#> (Intercept)           T 
#>    1.033517   -3.946888
#> 
#> Change in mu = 0.0433553952532435
#> Max change in theta = 0.000545184185063885
#> Max relative change in theta = 0.000527225629735135
#> 2021-05-21 18:15:23: starting EM iteration (E step) 54; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.80729
#> Change in log-likelihood = 0.0529002007739336
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.68173; theta =
#> (Intercept)           T 
#>    1.032988   -3.947081
#> 
#> Change in mu = 0.0421295162505686
#> Max change in theta = 0.00052899235583248
#> Max relative change in theta = 0.000511837018544688
#> 2021-05-21 18:15:24: starting EM iteration (E step) 55; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.75636
#> Change in log-likelihood = 0.0509234063382564
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.64079; theta =
#> (Intercept)           T 
#>    1.032475   -3.947271
#> 
#> Change in mu = 0.0409381082243527
#> Max change in theta = 0.000513236645263371
#> Max relative change in theta = 0.000496846573569032
#> 2021-05-21 18:15:25: starting EM iteration (E step) 56; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.70734
#> Change in log-likelihood = 0.0490292160194485
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.60101; theta =
#> (Intercept)           T 
#>    1.031977   -3.947457
#> 
#> Change in mu = 0.0397800622914701
#> Max change in theta = 0.000497912706260317
#> Max relative change in theta = 0.000482251605418666
#> 2021-05-21 18:15:25: starting EM iteration (E step) 57; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.66012
#> Change in log-likelihood = 0.0472142015356667
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.56235; theta =
#> (Intercept)           T 
#>    1.031494   -3.947640
#> 
#> Change in mu = 0.0386543443245984
#> Max change in theta = 0.000483015529316733
#> Max relative change in theta = 0.000468048714179677
#> 2021-05-21 18:15:26: starting EM iteration (E step) 58; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.61465
#> Change in log-likelihood = 0.0454750638095902
#> Starting M step, mem used = 164 MB
#> Ending M step; mu = 123.52479; theta =
#> (Intercept)           T 
#>    1.031025   -3.947820
#> 
#> Change in mu = 0.0375599848544255
#> Max change in theta = 0.000468539491573772
#> Max relative change in theta = 0.000454233837381246
#> 2021-05-21 18:15:27: starting EM iteration (E step) 59; mem used = 164 MB
#> Ending E step.
#> observed-data log-likelihood = -643.57084
#> Change in log-likelihood = 0.0438086287115311
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.4883; theta =
#> (Intercept)           T 
#>    1.030571   -3.947996
#> 
#> Change in mu = 0.0364960705231425
#> Max change in theta = 0.00045447841160362
#> Max relative change in theta = 0.000440802303821965
#> 2021-05-21 18:15:27: starting EM iteration (E step) 60; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.52863
#> Change in log-likelihood = 0.0422118430739147
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.45284; theta =
#> (Intercept)           T 
#>     1.03013    -3.94817
#> 
#> Change in mu = 0.0354617365589291
#> Max change in theta = 0.000440825602920691
#> Max relative change in theta = 0.000427748886452821
#> 2021-05-21 18:15:28: starting EM iteration (E step) 61; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.48794
#> Change in log-likelihood = 0.0406817709018696
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.41838; theta =
#> (Intercept)           T 
#>    1.029703   -3.948340
#> 
#> Change in mu = 0.03445616051836
#> Max change in theta = 0.000427573930990022
#> Max relative change in theta = 0.000415067858910254
#> 2021-05-21 18:15:29: starting EM iteration (E step) 62; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.44873
#> Change in log-likelihood = 0.0392155897357043
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.3849; theta =
#> (Intercept)           T 
#>    1.029288   -3.948508
#> 
#> Change in mu = 0.0334785567445124
#> Max change in theta = 0.000414715866555504
#> Max relative change in theta = 0.000402753048710417
#> 2021-05-21 18:15:29: starting EM iteration (E step) 63; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.41092
#> Change in log-likelihood = 0.0378105871246817
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.35237; theta =
#> (Intercept)           T 
#>    1.028886   -3.948672
#> 
#> Change in mu = 0.0325281717769741
#> Max change in theta = 0.000402243539877611
#> Max relative change in theta = 0.000390797891523212
#> 2021-05-21 18:15:30: starting EM iteration (E step) 64; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.37445
#> Change in log-likelihood = 0.0364641571887887
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.32077; theta =
#> (Intercept)           T 
#>    1.028496   -3.948833
#> 
#> Change in mu = 0.0316042804463024
#> Max change in theta = 0.000390148792937639
#> Max relative change in theta = 0.000379195483642646
#> 2021-05-21 18:15:31: starting EM iteration (E step) 65; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.33928
#> Change in log-likelihood = 0.0351737972569026
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.29006; theta =
#> (Intercept)           T 
#>    1.028117   -3.948992
#> 
#> Change in mu = 0.0307061825439234
#> Max change in theta = 0.000378423229118852
#> Max relative change in theta = 0.000367938632147251
#> 2021-05-21 18:15:31: starting EM iteration (E step) 66; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.30534
#> Change in log-likelihood = 0.0339371045637336
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.26023; theta =
#> (Intercept)           T 
#>    1.027750   -3.949147
#> 
#> Change in mu = 0.0298332001414536
#> Max change in theta = 0.000367058260687392
#> Max relative change in theta = 0.000357019903035592
#> 2021-05-21 18:15:32: starting EM iteration (E step) 67; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.27259
#> Change in log-likelihood = 0.0327517730071349
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.23125; theta =
#> (Intercept)           T 
#>    1.027394   -3.949299
#> 
#> Change in mu = 0.0289846751956446
#> Max change in theta = 0.000356045153529383
#> Max relative change in theta = 0.000346431666782558
#> 2021-05-21 18:15:33: starting EM iteration (E step) 68; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.24098
#> Change in log-likelihood = 0.0316155899587329
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.20309; theta =
#> (Intercept)           T 
#>    1.027049   -3.949448
#> 
#> Change in mu = 0.0281599677769862
#> Max change in theta = 0.000345375069195297
#> Max relative change in theta = 0.000336166141341729
#> 2021-05-21 18:15:33: starting EM iteration (E step) 69; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.21045
#> Change in log-likelihood = 0.0305264331290118
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.17573; theta =
#> (Intercept)           T 
#>    1.026714   -3.949594
#> 
#> Change in mu = 0.0273584544787155
#> Max change in theta = 0.000335039104164547
#> Max relative change in theta = 0.000326215432487202
#> 2021-05-21 18:15:34: starting EM iteration (E step) 70; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.18097
#> Change in log-likelihood = 0.0294822674871966
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.14915; theta =
#> (Intercept)           T 
#>    1.026389   -3.949738
#> 
#> Change in mu = 0.0265795271652962
#> Max change in theta = 0.000325028324356991
#> Max relative change in theta = 0.000316571569553168
#> 2021-05-21 18:15:35: starting EM iteration (E step) 71; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.15249
#> Change in log-likelihood = 0.0284811422385474
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.12333; theta =
#> (Intercept)           T 
#>    1.026073   -3.949878
#> 
#> Change in mu = 0.0258225919937587
#> Max change in theta = 0.000315333799652429
#> Max relative change in theta = 0.000307226541187454
#> 2021-05-21 18:15:35: starting EM iteration (E step) 72; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.12496
#> Change in log-likelihood = 0.0275211878589516
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.09824; theta =
#> (Intercept)           T 
#>    1.025767   -3.950015
#> 
#> Change in mu = 0.025087068609821
#> Max change in theta = 0.000305946632087828
#> Max relative change in theta = 0.000298172324941169
#> 2021-05-21 18:15:36: starting EM iteration (E step) 73; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.09836
#> Change in log-likelihood = 0.0266006131911354
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.07387; theta =
#> (Intercept)           T 
#>    1.025470   -3.950149
#> 
#> Change in mu = 0.0243723895233785
#> Max change in theta = 0.000296857983559828
#> Max relative change in theta = 0.000289400916353478
#> 2021-05-21 18:15:37: starting EM iteration (E step) 74; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.07265
#> Change in log-likelihood = 0.0257177026030604
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.05019; theta =
#> (Intercept)           T 
#>    1.025182   -3.950280
#> 
#> Change in mu = 0.0236779995873775
#> Max change in theta = 0.000288059098739302
#> Max relative change in theta = 0.000280904353338609
#> 2021-05-21 18:15:37: starting EM iteration (E step) 75; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.04778
#> Change in log-likelihood = 0.024870813211578
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.02718; theta =
#> (Intercept)           T 
#>    1.024903   -3.950409
#> 
#> Change in mu = 0.0230033556785543
#> Max change in theta = 0.000279541327694588
#> Max relative change in theta = 0.000272674740246495
#> 2021-05-21 18:15:38: starting EM iteration (E step) 76; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.02372
#> Change in log-likelihood = 0.0240583721715666
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 123.00484; theta =
#> (Intercept)           T 
#>    1.024632   -3.950534
#> 
#> Change in mu = 0.0223479262980533
#> Max change in theta = 0.000271296141564514
#> Max relative change in theta = 0.00026470426509665
#> 2021-05-21 18:15:39: starting EM iteration (E step) 77; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -643.00044
#> Change in log-likelihood = 0.0232788740327123
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.98313; theta =
#> (Intercept)           T 
#>    1.024368   -3.950656
#> 
#> Change in mu = 0.0217111914858492
#> Max change in theta = 0.000263315152224886
#> Max relative change in theta = 0.000256985220649491
#> 2021-05-21 18:15:39: starting EM iteration (E step) 78; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.97791
#> Change in log-likelihood = 0.0225308781660942
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.96203; theta =
#> (Intercept)           T 
#>    1.024113   -3.950776
#> 
#> Change in mu = 0.0210926424956455
#> Max change in theta = 0.000255590121899685
#> Max relative change in theta = 0.00024951001560829
#> 2021-05-21 18:15:40: starting EM iteration (E step) 79; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.95609
#> Change in log-likelihood = 0.0218130062598902
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.94154; theta =
#> (Intercept)           T 
#>    1.023864   -3.950892
#> 
#> Change in mu = 0.0204917817992651
#> Max change in theta = 0.000248112978546766
#> Max relative change in theta = 0.00024227119138856
#> 2021-05-21 18:15:41: starting EM iteration (E step) 80; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.93497
#> Change in log-likelihood = 0.0211239398832959
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.92163; theta =
#> (Intercept)           T 
#>    1.023624   -3.951006
#> 
#> Change in mu = 0.019908122853721
#> Max change in theta = 0.000240875822371756
#> Max relative change in theta = 0.000235261430162378
#> 2021-05-21 18:15:41: starting EM iteration (E step) 81; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.91451
#> Change in log-likelihood = 0.0204624181247937
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.90229; theta =
#> (Intercept)           T 
#>    1.023390   -3.951117
#> 
#> Change in mu = 0.0193411901055356
#> Max change in theta = 0.000233870935073544
#> Max relative change in theta = 0.000228473565497527
#> 2021-05-21 18:15:42: starting EM iteration (E step) 82; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.89468
#> Change in log-likelihood = 0.0198272352965887
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.8835; theta =
#> (Intercept)           T 
#>    1.023163   -3.951225
#> 
#> Change in mu = 0.0187905187863748
#> Max change in theta = 0.000227090784691075
#> Max relative change in theta = 0.000221900588631345
#> 2021-05-21 18:15:43: starting EM iteration (E step) 83; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.87546
#> Change in log-likelihood = 0.0192172387119172
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.86525; theta =
#> (Intercept)           T 
#>    1.022942   -3.951330
#> 
#> Change in mu = 0.0182556549946753
#> Max change in theta = 0.000220528031989575
#> Max relative change in theta = 0.000215535656177263
#> 2021-05-21 18:15:44: starting EM iteration (E step) 84; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.85683
#> Change in log-likelihood = 0.0186313265319313
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.84751; theta =
#> (Intercept)           T 
#>    1.022728   -3.951432
#> 
#> Change in mu = 0.0177361554890183
#> Max change in theta = 0.00021417553198666
#> Max relative change in theta = 0.000209372093013286
#> 2021-05-21 18:15:44: starting EM iteration (E step) 85; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.83876
#> Change in log-likelihood = 0.018068445680683
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.83028; theta =
#> (Intercept)           T 
#>    1.022520   -3.951532
#> 
#> Change in mu = 0.0172315876237548
#> Max change in theta = 0.000208026336245171
#> Max relative change in theta = 0.000203403395848687
#> 2021-05-21 18:15:45: starting EM iteration (E step) 86; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.82124
#> Change in log-likelihood = 0.0175275898295695
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.81354; theta =
#> (Intercept)           T 
#>    1.022318   -3.951629
#> 
#> Change in mu = 0.0167415293037578
#> Max change in theta = 0.000202073693999605
#> Max relative change in theta = 0.000197623235582738
#> 2021-05-21 18:15:46: starting EM iteration (E step) 87; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.80423
#> Change in log-likelihood = 0.0170077974494234
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.79727; theta =
#> (Intercept)           T 
#>    1.022122   -3.951723
#> 
#> Change in mu = 0.0162655688881017
#> Max change in theta = 0.00019631105306539
#> Max relative change in theta = 0.000192025459385172
#> 2021-05-21 18:15:46: starting EM iteration (E step) 88; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.78772
#> Change in log-likelihood = 0.0165081499295638
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.78147; theta =
#> (Intercept)           T 
#>    1.021931   -3.951815
#> 
#> Change in mu = 0.0158033050163482
#> Max change in theta = 0.000190732056942977
#> Max relative change in theta = 0.000186604088990715
#> 2021-05-21 18:15:47: starting EM iteration (E step) 89; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.77169
#> Change in log-likelihood = 0.016027769761763
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.76611; theta =
#> (Intercept)           T 
#>    1.021745   -3.951904
#> 
#> Change in mu = 0.0153543465534227
#> Max change in theta = 0.000185330544676399
#> Max relative change in theta = 0.000181353321624015
#> 2021-05-21 18:15:48: starting EM iteration (E step) 90; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.75613
#> Change in log-likelihood = 0.0155658187898098
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.75119; theta =
#> (Intercept)           T 
#>    1.021565   -3.951991
#> 
#> Change in mu = 0.014918312441992
#> Max change in theta = 0.000180100548085038
#> Max relative change in theta = 0.000176267528295537
#> 2021-05-21 18:15:49: starting EM iteration (E step) 91; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.741
#> Change in log-likelihood = 0.0151214965208055
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.7367; theta =
#> (Intercept)           T 
#>    1.021390   -3.952075
#> 
#> Change in mu = 0.0144948316043809
#> Max change in theta = 0.000175036290236852
#> Max relative change in theta = 0.000171341253254264
#> 2021-05-21 18:15:49: starting EM iteration (E step) 92; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.72631
#> Change in log-likelihood = 0.0146940385010339
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.72262; theta =
#> (Intercept)           T 
#>    1.021220   -3.952156
#> 
#> Change in mu = 0.0140835427129673
#> Max change in theta = 0.000170132179577953
#> Max relative change in theta = 0.00016656920913387
#> 2021-05-21 18:15:50: starting EM iteration (E step) 93; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.71203
#> Change in log-likelihood = 0.0142827147491289
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.70893; theta =
#> (Intercept)           T 
#>    1.021055   -3.952235
#> 
#> Change in mu = 0.0136840941603396
#> Max change in theta = 0.000165382809921732
#> Max relative change in theta = 0.000161946277780653
#> 2021-05-21 18:15:51: starting EM iteration (E step) 94; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.69814
#> Change in log-likelihood = 0.0138868282516569
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.69564; theta =
#> (Intercept)           T 
#>    1.020894   -3.952312
#> 
#> Change in mu = 0.0132961437690398
#> Max change in theta = 0.000160782952851601
#> Max relative change in theta = 0.000157467503605232
#> 2021-05-21 18:15:51: starting EM iteration (E step) 95; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.68464
#> Change in log-likelihood = 0.0135057135134957
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.68272; theta =
#> (Intercept)           T 
#>    1.020738   -3.952386
#> 
#> Change in mu = 0.0129193587683005
#> Max change in theta = 0.000156327557722102
#> Max relative change in theta = 0.000153128094324973
#> 2021-05-21 18:15:52: starting EM iteration (E step) 96; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.6715
#> Change in log-likelihood = 0.0131387351674448
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.67016; theta =
#> (Intercept)           T 
#>    1.020586   -3.952458
#> 
#> Change in mu = 0.0125534154718849
#> Max change in theta = 0.000152011742983849
#> Max relative change in theta = 0.00014892341316547
#> 2021-05-21 18:15:53: starting EM iteration (E step) 97; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.65871
#> Change in log-likelihood = 0.0127852866364719
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.65797; theta =
#> (Intercept)           T 
#>    1.020438   -3.952528
#> 
#> Change in mu = 0.0121979992141945
#> Max change in theta = 0.000147830795090842
#> Max relative change in theta = 0.000144848978443683
#> 2021-05-21 18:15:54: starting EM iteration (E step) 98; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.64627
#> Change in log-likelihood = 0.0124447888491659
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.64611; theta =
#> (Intercept)           T 
#>    1.020294   -3.952595
#> 
#> Change in mu = 0.0118528041168986
#> Max change in theta = 0.000143780162541463
#> Max relative change in theta = 0.000140900458344889
#> 2021-05-21 18:15:54: starting EM iteration (E step) 99; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.63415
#> Change in log-likelihood = 0.0121166890090763
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.63459; theta =
#> (Intercept)           T 
#>    1.020154   -3.952661
#> 
#> Change in mu = 0.0115175329330697
#> Max change in theta = 0.000139855451746884
#> Max relative change in theta = 0.000137073667450683
#> 2021-05-21 18:15:55: starting EM iteration (E step) 100; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.62235
#> Change in log-likelihood = 0.0118004594116883
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.6234; theta =
#> (Intercept)           T 
#>    1.020018   -3.952724
#> 
#> Change in mu = 0.0111918967995024
#> Max change in theta = 0.00013605242118242
#> Max relative change in theta = 0.000133364561547883
#> 2021-05-21 18:15:56: starting EM iteration (E step) 101; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.61085
#> Change in log-likelihood = 0.0114955963111925
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.61253; theta =
#> (Intercept)           T 
#>    1.019886   -3.952785
#> 
#> Change in mu = 0.0108756151252294
#> Max change in theta = 0.000132366978497167
#> Max relative change in theta = 0.000129769235302241
#> 2021-05-21 18:15:56: starting EM iteration (E step) 102; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.59965
#> Change in log-likelihood = 0.0112016188353437
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.60196; theta =
#> (Intercept)           T 
#>    1.019757   -3.952844
#> 
#> Change in mu = 0.0105684153494963
#> Max change in theta = 0.000128795174792584
#> Max relative change in theta = 0.000126283917125593
#> 2021-05-21 18:15:57: starting EM iteration (E step) 103; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.58873
#> Change in log-likelihood = 0.0109180679432939
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.59169; theta =
#> (Intercept)           T 
#>    1.019632   -3.952901
#> 
#> Change in mu = 0.0102700327626053
#> Max change in theta = 0.000125333200186262
#> Max relative change in theta = 0.000122904965271888
#> 2021-05-21 18:15:58: starting EM iteration (E step) 104; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.57809
#> Change in log-likelihood = 0.010644505430605
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.58171; theta =
#> (Intercept)           T 
#>    1.019510   -3.952955
#> 
#> Change in mu = 0.00998021030916618
#> Max change in theta = 0.000121977379182736
#> Max relative change in theta = 0.000119628863715532
#> 2021-05-21 18:15:59: starting EM iteration (E step) 105; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.56771
#> Change in log-likelihood = 0.0103805129741659
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.57201; theta =
#> (Intercept)           T 
#>    1.019391   -3.953008
#> 
#> Change in mu = 0.00969869839437365
#> Max change in theta = 0.00011872416623171
#> Max relative change in theta = 0.000116452218186615
#> 2021-05-21 18:15:59: starting EM iteration (E step) 106; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.55758
#> Change in log-likelihood = 0.0101256912198551
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.56258; theta =
#> (Intercept)           T 
#>    1.019275   -3.953059
#> 
#> Change in mu = 0.0094252547046807
#> Max change in theta = 0.000115570141576038
#> Max relative change in theta = 0.000113371752465208
#> 2021-05-21 18:16:00: starting EM iteration (E step) 107; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.5477
#> Change in log-likelihood = 0.00987965890897158
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.55342; theta =
#> (Intercept)           T 
#>    1.019163   -3.953109
#> 
#> Change in mu = 0.00915964401545466
#> Max change in theta = 0.000112512006413823
#> Max relative change in theta = 0.00011038430397926
#> 2021-05-21 18:16:01: starting EM iteration (E step) 108; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.53806
#> Change in log-likelihood = 0.00964205204411428
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.54452; theta =
#> (Intercept)           T 
#>    1.019053   -3.953156
#> 
#> Change in mu = 0.00890163798102606
#> Max change in theta = 0.000109546579129205
#> Max relative change in theta = 0.000107486820428473
#> 2021-05-21 18:16:02: starting EM iteration (E step) 109; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.52865
#> Change in log-likelihood = 0.00941252308928142
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.53587; theta =
#> (Intercept)           T 
#>    1.018947   -3.953202
#> 
#> Change in mu = 0.00865101497927867
#> Max change in theta = 0.000106670790972263
#> Max relative change in theta = 0.000104676355847132
#> 2021-05-21 18:16:02: starting EM iteration (E step) 110; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.51946
#> Change in log-likelihood = 0.00919074020885091
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.52746; theta =
#> (Intercept)           T 
#>    1.018843   -3.953246
#> 
#> Change in mu = 0.00840755991350761
#> Max change in theta = 0.000103881681908335
#> Max relative change in theta = 0.000101950066813516
#> 2021-05-21 18:16:03: starting EM iteration (E step) 111; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.51048
#> Change in log-likelihood = 0.00897638653680133
#> Starting M step, mem used = 165 MB
#> Ending M step; mu = 122.51929; theta =
#> (Intercept)           T 
#>    1.018742   -3.953288
#> 
#> Change in mu = 0.00817106401090939
#> Max change in theta = 0.000101176396531288
#> Max relative change in theta = 9.93052087037105e-05
#> 2021-05-21 18:16:04: starting EM iteration (E step) 112; mem used = 165 MB
#> Ending E step.
#> observed-data log-likelihood = -642.50171
#> EM algorithm converged, based on log-likelihood and coefs, to 0.00876915948265378 change in log-likelihood, in 112 iterations.

# extract the estimated mean window period duration from the algorithm's results:
mu_est_EM = EM_algorithm_outputs$Mu
```

Next, we perform alternative analyses using midpoint imputation and
uniform imputation:

``` r
max_iterations_for_glm_fits = 1000 
# bigglm's default maxit = 8, which is not large enough to ensure convergence for this data.
# I don't think any of the scenarios examined in our paper ever get close to 1000 iterations though; 
# this is effectively saying maxit = Inf.

# midpoint imputation:
{
  
  library(dplyr)
  library(magrittr)
  library(lubridate)
  library(biglm)
  
  sim_participant_data %<>%
    mutate(S_midpoint = L + (R - L) / ddays(2))
  
  sim_obs_data %<>%
    left_join(by = "ID",
              sim_participant_data %<>% dplyr::select(ID, S_midpoint)) %>%
    mutate(T_midpoint = (O - S_midpoint) / ddays(365))
  
  phi_model_est_midpoint =
    bigglm(
      epsilon = tolerance_for_glm_fits,
      maxit = max_iterations_for_glm_fits,
      quiet = TRUE,
      data = sim_obs_data,
      family = binomial(),
      Y ~ T_midpoint
    )
  
  mu_est_midpoint = compute_mu(coef(phi_model_est_midpoint))
  
}
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> 
#> Attaching package: 'lubridate'
#> The following objects are masked from 'package:base':
#> 
#>     date, intersect, setdiff, union
#> Loading required package: DBI

# uniform imputation:
{
  n_imputations = 100 # 10 would be enough
  
  # create a matrix to store the results from each imputed data set
  imputed_coef_ests = matrix(nrow = n_imputations,
                             ncol = 2,
                             dimnames = list(NULL, c("theta0", "theta1")))
  
  for (i in 1:n_imputations)
  {
    
    sim_participant_data %<>%
      mutate(S_imputed =
               L +
               runif(
                 n = n(),
                 min = 0,
                 max = (R - L) / ddays(1)
               ))
    
    sim_obs_data %<>%
      dplyr::select(-any_of("S_imputed")) %>%
      left_join(sim_participant_data %>% dplyr::select(ID, S_imputed),
                by = "ID") %>%
      mutate(T_imputed = (O - S_imputed) / ddays(365))
    
    phi_model_est_imputed =
      bigglm(
        epsilon = tolerance_for_glm_fits,
        maxit = max_iterations_for_glm_fits,
        quiet = TRUE,
        data = sim_obs_data,
        family = binomial(),
        Y ~ T_imputed
      )
    
    imputed_coef_ests[i, ] = coef(phi_model_est_imputed)
    
  }
  
  imputed_coef_ests_mean = colMeans(imputed_coef_ests)
  
  mu_est_imputed = compute_mu(imputed_coef_ests_mean)
  
}
```

Now, let’s graph the results. First, let’s plot the true and estimated
CDFs for the distribution of seroconversion date, for individuals who
enroll on the first calendar day of the cohort study:

``` r
library(ggplot2)
cum_haz_fn0 = function(years_since_study_start)
{
  hazard_alpha * years_since_study_start + hazard_beta / 2 * years_since_study_start^2
}

cum_haz_fn = function(years_since_study_start,
                      `years from study start to enrollment`)
{
  cum_haz_fn0(years_since_study_start) - cum_haz_fn0(`years from study start to enrollment`)
}

surv_fn = function(years_since_study_start,
                   `years from study start to enrollment`)
  exp(-cum_haz_fn(
    years_since_study_start,
    `years from study start to enrollment`
  ))

true_model_label = "Data-generating model"
est_model_label = "Estimated model"

lwd1 = 1
omega.hat = EM_algorithm_outputs$Omega %<>%
  mutate(
    "P(S>s|E=0)" = cumprod(`P(S>s|S>=s,E=e)`),
    "P(S>=s|E=0)" = lag(`P(S>s|E=0)`, default = 1) 
  )

plot1 = ggplot(
  aes(
    y = 1 - `P(S>=s|E=0)`,
    x = (S - ymd("2001-01-01")) / ddays(365)
  ),
  data = omega.hat %>% filter(S < max(S))) +
  
  geom_step(
    direction = "hv",
    aes(col = est_model_label,
        linetype = est_model_label),
    lwd = lwd1
  ) +
  
  xlab("Calendar time (years since start of study)") +
  ylab("Probability of seroconversion") +
  geom_function(
    fun = function(x)
      1 - surv_fn(x, 0),
    aes(col = true_model_label,
        linetype = true_model_label),
    lwd = lwd1
  ) +
  
  scale_colour_discrete("") +
  scale_linetype_discrete("") +
  theme(
    axis.title.x = element_text(size = 20),
    axis.text.x = element_text(size = 14),
    axis.title.y = element_text(size = 20),
    axis.text.y = element_text(size = 14),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    legend.position = "top",
    legend.text =
      element_text(size = 14,
                   margin = margin(r = 10, unit = "pt"))
  )

print(plot1)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

We can see that our joint modeling approach does not always estimate
this distribution very accurately at this sample size. Nevertheless, the
next graph will show us that the joint model very accurately estimates
the true distribution for *P*(*Y*\|*T*) and the true value of *μ*:

``` r
library(scales)


mu_true = compute_mu(theta_true)
phi_true = build_phi_function_from_coefs(theta_true)
phi_est_joint_modeling = build_phi_function_from_coefs(EM_algorithm_outputs$Theta)
phi_est_midpoint = build_phi_function_from_coefs(coef(phi_model_est_midpoint))
phi_est_imputed = build_phi_function_from_coefs(imputed_coef_ests_mean)

true_model_label2 = paste(sep = "",
                          "'   data-generating model;'~mu == '",
                          format(mu_true, digits = 1, nsmall = 1),
                          "'~days"
)

midpoint_label = paste(sep = "",
                       "` midpoint imputation;`~hat(mu) == '",
                       format(mu_est_midpoint, digits = 1, nsmall = 1),
                       "'~days"
)

uniform_label = paste(sep = "",
                      "`uniform imputation;`~hat(mu) == '",
                      format(mu_est_imputed, digits = 1, nsmall = 1),
                      "'~days"
)

joint_modeling_label = paste(sep = "",
                             "'  joint modeling;'~hat(mu) =='",
                             format(mu_est_EM, digits = 1, nsmall = 1),
                             "'~days"
)

lwd1 = 1


  plot2 = ggplot(data = NULL) +
    geom_function(
      fun = phi_true,
      lwd = lwd1,
      aes(colour = true_model_label2, linetype = true_model_label2)
    ) +
    geom_function(
      fun = phi_est_midpoint,
      lwd = lwd1,
      aes(colour = midpoint_label, linetype = midpoint_label)
    ) +
    geom_function(
      fun = phi_est_imputed,
      lwd = lwd1,
      aes(colour = uniform_label, linetype = uniform_label)
    ) +
    geom_function(
      fun = phi_est_joint_modeling,
      lwd = lwd1,
      aes(colour = joint_modeling_label, linetype = joint_modeling_label)
    ) +
    xlim(0, 2) +
    ylab("Probability of an MAA-positive blood sample") +
    xlab("Time since seroconversion (years)") +
    scale_colour_discrete("",   labels = label_parse()) +
    scale_linetype_discrete("", labels = label_parse()) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black")
    ) +
    theme(
      axis.title.x = element_text(size = 20),
      axis.text.x = element_text(size = 14),
      axis.title.y = element_text(size = 18),
      axis.text.y = element_text(size = 14),
      legend.text.align = 1,
      legend.box.just = "right",
      legend.text = element_text(size = 16),
      legend.position = c(.65, .85),
      legend.title = element_blank()
    )


print(plot2)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

This example can also be viewed via the R command
`vignette("how-to-use-rwicc")`).
