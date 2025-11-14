# how-to-use-rwicc

This vignette shows how to generate a simulated data set and analyze it
using the model and estimation algorithm described in “Regression with
Interval-Censored Covariates: Application to Cross-Sectional Incidence
Estimation” by Morrison, Laeyendecker, and Brookmeyer (2021) in
Biometrics: <https://onlinelibrary.wiley.com/doi/10.1111/biom.13472>.

First, we simulate some data:

``` r

set.seed(1)

library(rwicc)
theta_true = c(0.986, -3.88)
hazard_alpha = 1
hazard_beta = 0.5
sim_data = simulate_interval_censoring(
  "theta" = theta_true,
  "study_cohort_size" = 4500,
  "preconversion_interval_length" = 365,
  "hazard_alpha" = hazard_alpha,
  "hazard_beta" = hazard_beta)

# extract the participant-level and observation-level simulated data:
sim_participant_data = sim_data$pt_data
sim_obs_data = sim_data$obs_data
rm(sim_data)
```

Here’s a look at the first few rows of participant-level data:

``` r
library(pander)
pander(head(sim_participant_data))
```

| ID  |     E      |     L      |     R      |     S      |
|:---:|:----------:|:----------:|:----------:|:----------:|
|  1  | 2001-06-16 | 2001-06-16 | 2002-06-17 | 2002-03-11 |
|  2  | 2001-05-09 | 2001-05-09 | 2002-05-06 | 2001-05-18 |
|  3  | 2001-10-26 | 2001-10-26 | 2002-10-30 | 2002-02-18 |
|  4  | 2001-09-27 | 2001-09-27 | 2002-09-25 | 2002-01-08 |
|  5  | 2001-07-06 | 2001-07-06 | 2002-06-29 | 2002-04-23 |
|  6  | 2001-11-03 | 2001-11-03 | 2002-11-02 | 2002-06-01 |

- `E` is the individual’s enrollment date
- `L` is the date of the last HIV-negative test
- `R` is the date of the first HIV-positive test

Next, let’s look at the first few rows of observation-level
(longitudinal) data:

``` r
pander(head(sim_obs_data))
```

| ID  |     E      |     O      |  Y  |     S      | MAA status | Obs ID |
|:---:|:----------:|:----------:|:---:|:----------:|:----------:|:------:|
|  1  | 2001-06-16 | 2002-06-17 |  1  | 2002-03-11 |   Y = 1    |   1    |
|  1  | 2001-06-16 | 2002-07-15 |  0  | 2002-03-11 |   Y = 0    |   2    |
|  1  | 2001-06-16 | 2002-08-12 |  1  | 2002-03-11 |   Y = 1    |   3    |
|  1  | 2001-06-16 | 2002-09-09 |  0  | 2002-03-11 |   Y = 0    |   4    |
|  1  | 2001-06-16 | 2002-12-02 |  0  | 2002-03-11 |   Y = 0    |   5    |
|  1  | 2001-06-16 | 2003-02-24 |  0  | 2002-03-11 |   Y = 0    |   6    |

- `O` is the observation date
- `Y` is the MAA classification (1 = “recent infection”, 0 = “long-term
  infection”)

The two tables are linked by the variable `ID`.

Now, we will apply our proposed analysis (this takes a couple of
minutes; use argument `verbose = TRUE` to print progress messages):

``` r
EM_algorithm_outputs = fit_joint_model(
  obs_level_data = sim_obs_data,
  participant_level_data = sim_participant_data,
  bin_width = 7,
  EM_max_iterations = 150,
  verbose = TRUE)
#> Starting `fit_joint_model();`, mem used = 193 MB
#> Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
#> dplyr 1.1.0.
#> ℹ Please use `reframe()` instead.
#> ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()`
#>   always returns an ungrouped data frame and adjust accordingly.
#> ℹ The deprecated feature was likely used in the rwicc package.
#>   Please report the issue at <https://github.com/d-morrison/rwicc/issues>.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> initial estimate for mu = 183.80818; initial estimate for theta:
#> (Intercept)           T 
#>    1.672487   -3.662889
#> 2025-11-14 00:01:00.505732: starting EM iteration (E step) 1; mem used = 204 MB
#> Ending E step.
#> observed-data log-likelihood = -680.21393
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 161.15437; theta =
#> (Intercept)           T 
#>    1.512951   -3.877556
#> 
#> Change in mu = 22.6538179668489
#> Max change in theta = 0.214666754177144
#> Max relative change in theta = 0.0953887132359044
#> 2025-11-14 00:01:01.830472: starting EM iteration (E step) 2; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -662.69257
#> Change in log-likelihood = 17.5213569989709
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 150.0032; theta =
#> (Intercept)           T 
#>    1.374246   -3.892790
#> 
#> Change in mu = 11.1511629003479
#> Max change in theta = 0.138704350454229
#> Max relative change in theta = 0.091678043894103
#> 2025-11-14 00:01:02.865132: starting EM iteration (E step) 3; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -657.93947
#> Change in log-likelihood = 4.75310193108726
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 142.92462; theta =
#> (Intercept)           T 
#>    1.274785   -3.884952
#> 
#> Change in mu = 7.07858479703688
#> Max change in theta = 0.09946122809697
#> Max relative change in theta = 0.0723751139713
#> 2025-11-14 00:01:04.054111: starting EM iteration (E step) 4; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -655.45714
#> Change in log-likelihood = 2.48232542811365
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 138.26116; theta =
#> (Intercept)           T 
#>    1.209389   -3.882035
#> 
#> Change in mu = 4.66346197338467
#> Max change in theta = 0.0653960213548002
#> Max relative change in theta = 0.0512996472729449
#> 2025-11-14 00:01:05.057481: starting EM iteration (E step) 5; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -653.90211
#> Change in log-likelihood = 1.55503320196215
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 135.09515; theta =
#> (Intercept)           T 
#>    1.166567   -3.884346
#> 
#> Change in mu = 3.16600222182348
#> Max change in theta = 0.0428220179083163
#> Max relative change in theta = 0.0354079773465974
#> 2025-11-14 00:01:06.058893: starting EM iteration (E step) 6; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -652.83407
#> Change in log-likelihood = 1.06804336387688
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 132.88527; theta =
#> (Intercept)           T 
#>     1.13794    -3.88919
#> 
#> Change in mu = 2.20988362243276
#> Max change in theta = 0.0286265254922047
#> Max relative change in theta = 0.0245391188107173
#> 2025-11-14 00:01:07.050195: starting EM iteration (E step) 7; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -652.05023
#> Change in log-likelihood = 0.783833302869539
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 131.30685; theta =
#> (Intercept)           T 
#>    1.118330   -3.894758
#> 
#> Change in mu = 1.57842549076605
#> Max change in theta = 0.0196104981774843
#> Max relative change in theta = 0.0172333255767456
#> 2025-11-14 00:01:08.05104: starting EM iteration (E step) 8; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -651.43641
#> Change in log-likelihood = 0.613827067332068
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 130.15855; theta =
#> (Intercept)           T 
#>    1.104620   -3.900191
#> 
#> Change in mu = 1.14829614846542
#> Max change in theta = 0.0137102861047576
#> Max relative change in theta = 0.0122596074104913
#> 2025-11-14 00:01:09.046514: starting EM iteration (E step) 9; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -650.92582
#> Change in log-likelihood = 0.510588391010856
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 129.30933; theta =
#> (Intercept)           T 
#>    1.094875   -3.905169
#> 
#> Change in mu = 0.849219366854413
#> Max change in theta = 0.00974491549092149
#> Max relative change in theta = 0.00882196455170923
#> 2025-11-14 00:01:10.035378: starting EM iteration (E step) 10; mem used = 207 MB
#> Ending E step.
#> observed-data log-likelihood = -650.48112
#> Change in log-likelihood = 0.444700615684269
#> Starting M step, mem used = 207 MB
#> Ending M step; mu = 128.67018; theta =
#> (Intercept)           T 
#>    1.087833   -3.909614
#> 
#> Change in mu = 0.639146697847735
#> Max change in theta = 0.00704131121833873
#> Max relative change in theta = 0.0064311568499907
#> 2025-11-14 00:01:10.923118: starting EM iteration (E step) 11; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -650.08212
#> Change in log-likelihood = 0.399000995584402
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 128.17909; theta =
#> (Intercept)           T 
#>    1.082641   -3.913540
#> 
#> Change in mu = 0.491090877639579
#> Max change in theta = 0.00519284107888951
#> Max relative change in theta = 0.00477356267608134
#> 2025-11-14 00:01:11.811091: starting EM iteration (E step) 12; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -649.7178
#> Change in log-likelihood = 0.364312745327652
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 127.79241; theta =
#> (Intercept)           T 
#>    1.078706   -3.916990
#> 
#> Change in mu = 0.386682587922053
#> Max change in theta = 0.00393500641630196
#> Max relative change in theta = 0.00363463779356654
#> 2025-11-14 00:01:12.704019: starting EM iteration (E step) 13; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -649.38177
#> Change in log-likelihood = 0.336037565163792
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 127.47944; theta =
#> (Intercept)           T 
#>    1.075620   -3.920016
#> 
#> Change in mu = 0.312967986410754
#> Max change in theta = 0.00308577460282322
#> Max relative change in theta = 0.00286062725649715
#> 2025-11-14 00:01:13.593181: starting EM iteration (E step) 14; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -649.06981
#> Change in log-likelihood = 0.311951840819688
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 127.21876; theta =
#> (Intercept)           T 
#>    1.073103   -3.922667
#> 
#> Change in mu = 0.260686004800803
#> Max change in theta = 0.00265092158006652
#> Max relative change in theta = 0.0023394316880278
#> 2025-11-14 00:01:14.490206: starting EM iteration (E step) 15; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -648.77885
#> Change in log-likelihood = 0.290961306473832
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.99553; theta =
#> (Intercept)           T 
#>    1.070968   -3.924990
#> 
#> Change in mu = 0.223230395341389
#> Max change in theta = 0.00232313482810032
#> Max relative change in theta = 0.00198984228617378
#> 2025-11-14 00:01:15.378885: starting EM iteration (E step) 16; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -648.50639
#> Change in log-likelihood = 0.272464432370043
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.79958; theta =
#> (Intercept)           T 
#>    1.069089   -3.927028
#> 
#> Change in mu = 0.195945904530731
#> Max change in theta = 0.0020385267442351
#> Max relative change in theta = 0.001754236308689
#> 2025-11-14 00:01:16.28293: starting EM iteration (E step) 17; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -648.25033
#> Change in log-likelihood = 0.256060371186322
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.62397; theta =
#> (Intercept)           T 
#>    1.067387   -3.928821
#> 
#> Change in mu = 0.175607395574303
#> Max change in theta = 0.0017928348709062
#> Max relative change in theta = 0.00159284106576834
#> 2025-11-14 00:01:17.17836: starting EM iteration (E step) 18; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -648.0089
#> Change in log-likelihood = 0.241432561303327
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.46395; theta =
#> (Intercept)           T 
#>    1.065808   -3.930403
#> 
#> Change in mu = 0.160019440459067
#> Max change in theta = 0.00158159183515538
#> Max relative change in theta = 0.00147900156733783
#> 2025-11-14 00:01:18.075328: starting EM iteration (E step) 19; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -647.78058
#> Change in log-likelihood = 0.228310654477696
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.31624; theta =
#> (Intercept)           T 
#>    1.064321   -3.931803
#> 
#> Change in mu = 0.147709624697768
#> Max change in theta = 0.00148717318852887
#> Max relative change in theta = 0.00139534827775555
#> 2025-11-14 00:01:18.975329: starting EM iteration (E step) 20; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -647.56412
#> Change in log-likelihood = 0.216461162308633
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.17854; theta =
#> (Intercept)           T 
#>    1.062904   -3.933048
#> 
#> Change in mu = 0.137699912026079
#> Max change in theta = 0.0014164360005573
#> Max relative change in theta = 0.00133083570833687
#> 2025-11-14 00:01:19.892865: starting EM iteration (E step) 21; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -647.35844
#> Change in log-likelihood = 0.205685368486911
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 126.0492; theta =
#> (Intercept)           T 
#>    1.061545   -3.934159
#> 
#> Change in mu = 0.129342245505612
#> Max change in theta = 0.0013589999970991
#> Max relative change in theta = 0.00127857233766246
#> 2025-11-14 00:01:20.803467: starting EM iteration (E step) 22; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -647.16262
#> Change in log-likelihood = 0.195817274587966
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.927; theta =
#> (Intercept)           T 
#>    1.060235   -3.935156
#> 
#> Change in mu = 0.122204605728101
#> Max change in theta = 0.00131027479194135
#> Max relative change in theta = 0.00123430891651027
#> 2025-11-14 00:01:21.704695: starting EM iteration (E step) 23; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.9759
#> Change in log-likelihood = 0.186720255530417
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.811; theta =
#> (Intercept)           T 
#>    1.058968   -3.936053
#> 
#> Change in mu = 0.115994629542541
#> Max change in theta = 0.00126743895975379
#> Max relative change in theta = 0.00119543211229404
#> 2025-11-14 00:01:22.594659: starting EM iteration (E step) 24; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.79762
#> Change in log-likelihood = 0.178282916505623
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.70049; theta =
#> (Intercept)           T 
#>    1.057739   -3.936865
#> 
#> Change in mu = 0.110509821623936
#> Max change in theta = 0.00122874186984778
#> Max relative change in theta = 0.00116032059971127
#> 2025-11-14 00:01:23.483322: starting EM iteration (E step) 25; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.6272
#> Change in log-likelihood = 0.170414846215408
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.59489; theta =
#> (Intercept)           T 
#>    1.056546   -3.937602
#> 
#> Change in mu = 0.105605795614593
#> Max change in theta = 0.00119307321461881
#> Max relative change in theta = 0.00112794689812939
#> 2025-11-14 00:01:24.546744: starting EM iteration (E step) 26; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.46416
#> Change in log-likelihood = 0.163042719702503
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.49371; theta =
#> (Intercept)           T 
#>    1.055386   -3.938274
#> 
#> Change in mu = 0.10117630515343
#> Max change in theta = 0.00115970491505535
#> Max relative change in theta = 0.00109763815229228
#> 2025-11-14 00:01:25.62015: starting EM iteration (E step) 27; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.30805
#> Change in log-likelihood = 0.156106948825141
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.39657; theta =
#> (Intercept)           T 
#>    1.054258   -3.938890
#> 
#> Change in mu = 0.0971407636806418
#> Max change in theta = 0.00112813979021209
#> Max relative change in theta = 0.00106893567997886
#> 2025-11-14 00:01:26.504115: starting EM iteration (E step) 28; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.15849
#> Change in log-likelihood = 0.149558913452665
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.30313; theta =
#> (Intercept)           T 
#>    1.053160   -3.939455
#> 
#> Change in mu = 0.0934364144815021
#> Max change in theta = 0.00109802412630144
#> Max relative change in theta = 0.00104151377957271
#> 2025-11-14 00:01:27.390731: starting EM iteration (E step) 29; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -646.01514
#> Change in log-likelihood = 0.143358724071277
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.21312; theta =
#> (Intercept)           T 
#>    1.052091   -3.939977
#> 
#> Change in mu = 0.0900133447970148
#> Max change in theta = 0.00106909737893157
#> Max relative change in theta = 0.00101513303639778
#> 2025-11-14 00:01:28.444623: starting EM iteration (E step) 30; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.87766
#> Change in log-likelihood = 0.137473436358164
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.12629; theta =
#> (Intercept)           T 
#>     1.05105    -3.94046
#> 
#> Change in mu = 0.0868312254789743
#> Max change in theta = 0.00104116289491452
#> Max relative change in theta = 0.000989613177665238
#> 2025-11-14 00:01:29.505564: starting EM iteration (E step) 31; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.74579
#> Change in log-likelihood = 0.131875635300844
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 125.04243; theta =
#> (Intercept)           T 
#>    1.050036   -3.940910
#> 
#> Change in mu = 0.0838571001029891
#> Max change in theta = 0.0010140703029724
#> Max relative change in theta = 0.000964816780688167
#> 2025-11-14 00:01:30.692442: starting EM iteration (E step) 32; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.61924
#> Change in log-likelihood = 0.12654231514091
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.96137; theta =
#> (Intercept)           T 
#>    1.049048   -3.941330
#> 
#> Change in mu = 0.0810638213677208
#> Max change in theta = 0.000987704305970283
#> Max relative change in theta = 0.000940638927701867
#> 2025-11-14 00:01:31.75954: starting EM iteration (E step) 33; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.49779
#> Change in log-likelihood = 0.121453993616569
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.88294; theta =
#> (Intercept)           T 
#>    1.048086   -3.941723
#> 
#> Change in mu = 0.0784288977717154
#> Max change in theta = 0.000961977009566128
#> Max relative change in theta = 0.000917000136026659
#> 2025-11-14 00:01:32.816387: starting EM iteration (E step) 34; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.3812
#> Change in log-likelihood = 0.116594010958693
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.807; theta =
#> (Intercept)           T 
#>    1.047149   -3.942093
#> 
#> Change in mu = 0.0759336113874269
#> Max change in theta = 0.000936822262542991
#> Max relative change in theta = 0.000893841142195582
#> 2025-11-14 00:01:34.043972: starting EM iteration (E step) 35; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.26925
#> Change in log-likelihood = 0.111947974446025
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.73344; theta =
#> (Intercept)           T 
#>    1.046237   -3.942442
#> 
#> Change in mu = 0.0735623239530554
#> Max change in theta = 0.000912191232131265
#> Max relative change in theta = 0.000871118817803463
#> 2025-11-14 00:01:35.100234: starting EM iteration (E step) 36; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.16175
#> Change in log-likelihood = 0.107503317779219
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.66214; theta =
#> (Intercept)           T 
#>    1.045349   -3.942773
#> 
#> Change in mu = 0.071301920541984
#> Max change in theta = 0.000888048809218889
#> Max relative change in theta = 0.000848802842186096
#> 2025-11-14 00:01:36.161466: starting EM iteration (E step) 37; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -645.0585
#> Change in log-likelihood = 0.103248951194701
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.593; theta =
#> (Intercept)           T 
#>    1.044484   -3.943087
#> 
#> Change in mu = 0.0691413586504268
#> Max change in theta = 0.00086437064053202
#> Max relative change in theta = 0.000826872946273613
#> 2025-11-14 00:01:37.229784: starting EM iteration (E step) 38; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.95932
#> Change in log-likelihood = 0.0991749834612392
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.52593; theta =
#> (Intercept)           T 
#>    1.043643   -3.943388
#> 
#> Change in mu = 0.0670713004630841
#> Max change in theta = 0.000841140668407903
#> Max relative change in theta = 0.000805316619692829
#> 2025-11-14 00:01:38.304046: starting EM iteration (E step) 39; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.86405
#> Change in log-likelihood = 0.0952725009268534
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.46084; theta =
#> (Intercept)           T 
#>    1.042825   -3.943675
#> 
#> Change in mu = 0.0650838125107214
#> Max change in theta = 0.000818349101706195
#> Max relative change in theta = 0.00078412721290723
#> 2025-11-14 00:01:39.387495: starting EM iteration (E step) 40; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.77252
#> Change in log-likelihood = 0.0915333919263048
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.39767; theta =
#> (Intercept)           T 
#>    1.042029   -3.943951
#> 
#> Change in mu = 0.0631721203248645
#> Max change in theta = 0.000795990763566623
#> Max relative change in theta = 0.000763302386461955
#> 2025-11-14 00:01:40.480831: starting EM iteration (E step) 41; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.68457
#> Change in log-likelihood = 0.0879502072941705
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.33634; theta =
#> (Intercept)           T 
#>    1.041255   -3.944217
#> 
#> Change in mu = 0.0613304081706474
#> Max change in theta = 0.000774063756069143
#> Max relative change in theta = 0.000742842853248557
#> 2025-11-14 00:01:41.556302: starting EM iteration (E step) 42; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.60005
#> Change in log-likelihood = 0.0845160496254493
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.27679; theta =
#> (Intercept)           T 
#>    1.040502   -3.944474
#> 
#> Change in mu = 0.0595536559343088
#> Max change in theta = 0.000752568403216358
#> Max relative change in theta = 0.000722751379525204
#> 2025-11-14 00:01:42.648297: starting EM iteration (E step) 43; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.51882
#> Change in log-likelihood = 0.0812244854313349
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.21895; theta =
#> (Intercept)           T 
#>    1.039771   -3.944722
#> 
#> Change in mu = 0.0578375059452725
#> Max change in theta = 0.000731506416469463
#> Max relative change in theta = 0.000703031993412393
#> 2025-11-14 00:01:43.74491: starting EM iteration (E step) 44; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.44076
#> Change in log-likelihood = 0.0780694755067088
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.16277; theta =
#> (Intercept)           T 
#>    1.039060   -3.944963
#> 
#> Change in mu = 0.0561781546947628
#> Max change in theta = 0.00071088026041588
#> Max relative change in theta = 0.000683689381099409
#> 2025-11-14 00:01:44.835695: starting EM iteration (E step) 45; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.36571
#> Change in log-likelihood = 0.0750453197695151
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.1082; theta =
#> (Intercept)           T 
#>    1.038369   -3.945197
#> 
#> Change in mu = 0.0545722641504369
#> Max change in theta = 0.00069069266152133
#> Max relative change in theta = 0.000664728417369117
#> 2025-11-14 00:01:45.919057: starting EM iteration (E step) 46; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.29356
#> Change in log-likelihood = 0.0721466135738638
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.05518; theta =
#> (Intercept)           T 
#>    1.037698   -3.945426
#> 
#> Change in mu = 0.0530168891977922
#> Max change in theta = 0.000670946249690996
#> Max relative change in theta = 0.000646153821615207
#> 2025-11-14 00:01:47.005612: starting EM iteration (E step) 47; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.22419
#> Change in log-likelihood = 0.0693682130954585
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 124.00367; theta =
#> (Intercept)           T 
#>    1.037047   -3.945648
#> 
#> Change in mu = 0.0515094179251179
#> Max change in theta = 0.000651643294081961
#> Max relative change in theta = 0.000627969903107023
#> 2025-11-14 00:01:48.100675: starting EM iteration (E step) 48; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.15749
#> Change in log-likelihood = 0.0667052078678125
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.95363; theta =
#> (Intercept)           T 
#>    1.036414   -3.945866
#> 
#> Change in mu = 0.0500475222692529
#> Max change in theta = 0.000632785518194456
#> Max relative change in theta = 0.000610180381695175
#> 2025-11-14 00:01:49.188443: starting EM iteration (E step) 49; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.09334
#> Change in log-likelihood = 0.0641528989332301
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.905; theta =
#> (Intercept)           T 
#>    1.035799   -3.946079
#> 
#> Change in mu = 0.0486291167900106
#> Max change in theta = 0.000614373973779836
#> Max relative change in theta = 0.000592788264708243
#> 2025-11-14 00:01:50.275938: starting EM iteration (E step) 50; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -644.03163
#> Change in log-likelihood = 0.0617067813809626
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.85774; theta =
#> (Intercept)           T 
#>    1.035203   -3.946287
#> 
#> Change in mu = 0.0472523242714402
#> Max change in theta = 0.0005964089624515
#> Max relative change in theta = 0.000575795769656339
#> 2025-11-14 00:01:51.365531: starting EM iteration (E step) 51; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.97227
#> Change in log-likelihood = 0.0593625302973351
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.81183; theta =
#> (Intercept)           T 
#>    1.034624   -3.946491
#> 
#> Change in mu = 0.0459154467051519
#> Max change in theta = 0.000578889994325982
#> Max relative change in theta = 0.000559204282688073
#> 2025-11-14 00:01:52.452485: starting EM iteration (E step) 52; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.91515
#> Change in log-likelihood = 0.0571159893554523
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.76721; theta =
#> (Intercept)           T 
#>    1.034062   -3.946692
#> 
#> Change in mu = 0.0446169404341106
#> Max change in theta = 0.000561815769291041
#> Max relative change in theta = 0.000543014339059227
#> 2025-11-14 00:01:53.540873: starting EM iteration (E step) 53; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.86019
#> Change in log-likelihood = 0.054963161432056
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.72386; theta =
#> (Intercept)           T 
#>    1.033517   -3.946888
#> 
#> Change in mu = 0.0433553952529877
#> Max change in theta = 0.000545184185058556
#> Max relative change in theta = 0.000527225629729983
#> 2025-11-14 00:01:54.629689: starting EM iteration (E step) 54; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.80729
#> Change in log-likelihood = 0.0529002007739336
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.68173; theta =
#> (Intercept)           T 
#>    1.032988   -3.947081
#> 
#> Change in mu = 0.0421295162507107
#> Max change in theta = 0.000528992355834701
#> Max relative change in theta = 0.000511837018546836
#> 2025-11-14 00:01:55.717513: starting EM iteration (E step) 55; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.75636
#> Change in log-likelihood = 0.0509234063382564
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.64079; theta =
#> (Intercept)           T 
#>    1.032475   -3.947271
#> 
#> Change in mu = 0.0409381082243527
#> Max change in theta = 0.000513236645262038
#> Max relative change in theta = 0.000496846573567743
#> 2025-11-14 00:01:56.805807: starting EM iteration (E step) 56; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.70734
#> Change in log-likelihood = 0.0490292160194485
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.60101; theta =
#> (Intercept)           T 
#>    1.031977   -3.947457
#> 
#> Change in mu = 0.0397800622914559
#> Max change in theta = 0.000497912706258319
#> Max relative change in theta = 0.000482251605416729
#> 2025-11-14 00:01:57.716045: starting EM iteration (E step) 57; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.66012
#> Change in log-likelihood = 0.0472142015356667
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.56235; theta =
#> (Intercept)           T 
#>    1.031494   -3.947640
#> 
#> Change in mu = 0.0386543443245415
#> Max change in theta = 0.000483015529319619
#> Max relative change in theta = 0.000468048714182472
#> 2025-11-14 00:01:58.62802: starting EM iteration (E step) 58; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.61465
#> Change in log-likelihood = 0.0454750638095902
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.52479; theta =
#> (Intercept)           T 
#>    1.031025   -3.947820
#> 
#> Change in mu = 0.0375599848544965
#> Max change in theta = 0.00046853949157355
#> Max relative change in theta = 0.00045423383738103
#> 2025-11-14 00:01:59.544327: starting EM iteration (E step) 59; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.57084
#> Change in log-likelihood = 0.0438086287116448
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.4883; theta =
#> (Intercept)           T 
#>    1.030571   -3.947996
#> 
#> Change in mu = 0.0364960705233273
#> Max change in theta = 0.000454478411608061
#> Max relative change in theta = 0.000440802303826272
#> 2025-11-14 00:02:00.461927: starting EM iteration (E step) 60; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.52863
#> Change in log-likelihood = 0.042211843073801
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.45284; theta =
#> (Intercept)           T 
#>     1.03013    -3.94817
#> 
#> Change in mu = 0.035461736558787
#> Max change in theta = 0.000440825602918249
#> Max relative change in theta = 0.000427748886450453
#> 2025-11-14 00:02:01.554951: starting EM iteration (E step) 61; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.48794
#> Change in log-likelihood = 0.0406817709018696
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.41838; theta =
#> (Intercept)           T 
#>    1.029703   -3.948340
#> 
#> Change in mu = 0.03445616051836
#> Max change in theta = 0.000427573930987801
#> Max relative change in theta = 0.000415067858908099
#> 2025-11-14 00:02:02.648587: starting EM iteration (E step) 62; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.44873
#> Change in log-likelihood = 0.039215589735818
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.3849; theta =
#> (Intercept)           T 
#>    1.029288   -3.948508
#> 
#> Change in mu = 0.033478556744484
#> Max change in theta = 0.00041471586655506
#> Max relative change in theta = 0.000402753048709986
#> 2025-11-14 00:02:03.738791: starting EM iteration (E step) 63; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.41092
#> Change in log-likelihood = 0.037810587124568
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.35237; theta =
#> (Intercept)           T 
#>    1.028886   -3.948672
#> 
#> Change in mu = 0.0325281717768036
#> Max change in theta = 0.000402243539873171
#> Max relative change in theta = 0.000390797891518897
#> 2025-11-14 00:02:04.833688: starting EM iteration (E step) 64; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.37445
#> Change in log-likelihood = 0.0364641571889024
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.32077; theta =
#> (Intercept)           T 
#>    1.028496   -3.948833
#> 
#> Change in mu = 0.0316042804462171
#> Max change in theta = 0.000390148792937861
#> Max relative change in theta = 0.000379195483642859
#> 2025-11-14 00:02:05.924601: starting EM iteration (E step) 65; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.33928
#> Change in log-likelihood = 0.0351737972567889
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.29006; theta =
#> (Intercept)           T 
#>    1.028117   -3.948992
#> 
#> Change in mu = 0.0307061825440371
#> Max change in theta = 0.00037842322912085
#> Max relative change in theta = 0.000367938632149192
#> 2025-11-14 00:02:07.019186: starting EM iteration (E step) 66; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.30534
#> Change in log-likelihood = 0.0339371045638472
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.26023; theta =
#> (Intercept)           T 
#>    1.027750   -3.949147
#> 
#> Change in mu = 0.0298332001414678
#> Max change in theta = 0.00036705826068939
#> Max relative change in theta = 0.000357019903037534
#> 2025-11-14 00:02:08.119408: starting EM iteration (E step) 67; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.27259
#> Change in log-likelihood = 0.0327517730070213
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.23125; theta =
#> (Intercept)           T 
#>    1.027394   -3.949299
#> 
#> Change in mu = 0.0289846751957157
#> Max change in theta = 0.00035604515353227
#> Max relative change in theta = 0.000346431666785366
#> 2025-11-14 00:02:09.237936: starting EM iteration (E step) 68; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.24098
#> Change in log-likelihood = 0.0316155899587329
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.20309; theta =
#> (Intercept)           T 
#>    1.027049   -3.949448
#> 
#> Change in mu = 0.0281599677769719
#> Max change in theta = 0.000345375069194409
#> Max relative change in theta = 0.000336166141340865
#> 2025-11-14 00:02:10.165637: starting EM iteration (E step) 69; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.21045
#> Change in log-likelihood = 0.0305264331288981
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.17573; theta =
#> (Intercept)           T 
#>    1.026714   -3.949594
#> 
#> Change in mu = 0.0273584544786161
#> Max change in theta = 0.000335039104161661
#> Max relative change in theta = 0.000326215432484391
#> 2025-11-14 00:02:11.095215: starting EM iteration (E step) 70; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.18097
#> Change in log-likelihood = 0.0294822674873103
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.14915; theta =
#> (Intercept)           T 
#>    1.026389   -3.949738
#> 
#> Change in mu = 0.0265795271653104
#> Max change in theta = 0.000325028324357435
#> Max relative change in theta = 0.0003165715695536
#> 2025-11-14 00:02:12.014261: starting EM iteration (E step) 71; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.15249
#> Change in log-likelihood = 0.0284811422385474
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.12333; theta =
#> (Intercept)           T 
#>    1.026073   -3.949878
#> 
#> Change in mu = 0.0258225919936308
#> Max change in theta = 0.000315333799647766
#> Max relative change in theta = 0.00030722654118291
#> 2025-11-14 00:02:12.931106: starting EM iteration (E step) 72; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.12496
#> Change in log-likelihood = 0.0275211878589516
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.09824; theta =
#> (Intercept)           T 
#>    1.025767   -3.950015
#> 
#> Change in mu = 0.0250870686099489
#> Max change in theta = 0.00030594663208694
#> Max relative change in theta = 0.000298172324940302
#> 2025-11-14 00:02:13.848617: starting EM iteration (E step) 73; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.09836
#> Change in log-likelihood = 0.0266006131911354
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.07387; theta =
#> (Intercept)           T 
#>    1.025470   -3.950149
#> 
#> Change in mu = 0.0243723895235917
#> Max change in theta = 0.000296857983567822
#> Max relative change in theta = 0.000289400916361269
#> 2025-11-14 00:02:15.115041: starting EM iteration (E step) 74; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.07265
#> Change in log-likelihood = 0.0257177026030604
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.05019; theta =
#> (Intercept)           T 
#>    1.025182   -3.950280
#> 
#> Change in mu = 0.0236779995874059
#> Max change in theta = 0.000288059098740412
#> Max relative change in theta = 0.000280904353339692
#> 2025-11-14 00:02:16.204236: starting EM iteration (E step) 75; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.04778
#> Change in log-likelihood = 0.0248708132116917
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.02718; theta =
#> (Intercept)           T 
#>    1.024903   -3.950409
#> 
#> Change in mu = 0.0230033556784122
#> Max change in theta = 0.000279541327690369
#> Max relative change in theta = 0.00027267474024238
#> 2025-11-14 00:02:17.115329: starting EM iteration (E step) 76; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.02372
#> Change in log-likelihood = 0.0240583721714529
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 123.00484; theta =
#> (Intercept)           T 
#>    1.024632   -3.950534
#> 
#> Change in mu = 0.0223479262980817
#> Max change in theta = 0.000271296141566513
#> Max relative change in theta = 0.000264704265098599
#> 2025-11-14 00:02:18.031818: starting EM iteration (E step) 77; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -643.00044
#> Change in log-likelihood = 0.0232788740327123
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.98313; theta =
#> (Intercept)           T 
#>    1.024368   -3.950656
#> 
#> Change in mu = 0.0217111914858776
#> Max change in theta = 0.000263315152223997
#> Max relative change in theta = 0.000256985220648624
#> 2025-11-14 00:02:18.9415: starting EM iteration (E step) 78; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.97791
#> Change in log-likelihood = 0.0225308781660942
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.96203; theta =
#> (Intercept)           T 
#>    1.024113   -3.950776
#> 
#> Change in mu = 0.0210926424955744
#> Max change in theta = 0.000255590121899907
#> Max relative change in theta = 0.000249510015608506
#> 2025-11-14 00:02:19.859025: starting EM iteration (E step) 79; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.95609
#> Change in log-likelihood = 0.0218130062598902
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.94154; theta =
#> (Intercept)           T 
#>    1.023864   -3.950892
#> 
#> Change in mu = 0.0204917817993078
#> Max change in theta = 0.000248112978546766
#> Max relative change in theta = 0.00024227119138856
#> 2025-11-14 00:02:20.776585: starting EM iteration (E step) 80; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.93497
#> Change in log-likelihood = 0.0211239398832959
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.92163; theta =
#> (Intercept)           T 
#>    1.023624   -3.951006
#> 
#> Change in mu = 0.0199081228538915
#> Max change in theta = 0.000240875822375086
#> Max relative change in theta = 0.00023526143016563
#> 2025-11-14 00:02:21.866375: starting EM iteration (E step) 81; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.91451
#> Change in log-likelihood = 0.0204624181247937
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.90229; theta =
#> (Intercept)           T 
#>    1.023390   -3.951117
#> 
#> Change in mu = 0.0193411901055072
#> Max change in theta = 0.000233870935071767
#> Max relative change in theta = 0.000228473565495792
#> 2025-11-14 00:02:22.955919: starting EM iteration (E step) 82; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.89468
#> Change in log-likelihood = 0.0198272352965887
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.8835; theta =
#> (Intercept)           T 
#>    1.023163   -3.951225
#> 
#> Change in mu = 0.0187905187863606
#> Max change in theta = 0.000227090784689299
#> Max relative change in theta = 0.000221900588629609
#> 2025-11-14 00:02:24.047767: starting EM iteration (E step) 83; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.87546
#> Change in log-likelihood = 0.0192172387119172
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.86525; theta =
#> (Intercept)           T 
#>    1.022942   -3.951330
#> 
#> Change in mu = 0.0182556549949595
#> Max change in theta = 0.000220528031991574
#> Max relative change in theta = 0.000215535656179215
#> 2025-11-14 00:02:25.140137: starting EM iteration (E step) 84; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.85683
#> Change in log-likelihood = 0.0186313265319313
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.84751; theta =
#> (Intercept)           T 
#>    1.022728   -3.951432
#> 
#> Change in mu = 0.0177361554889046
#> Max change in theta = 0.00021417553198666
#> Max relative change in theta = 0.000209372093013286
#> 2025-11-14 00:02:26.230575: starting EM iteration (E step) 85; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.83876
#> Change in log-likelihood = 0.018068445680683
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.83028; theta =
#> (Intercept)           T 
#>    1.022520   -3.951532
#> 
#> Change in mu = 0.0172315876238258
#> Max change in theta = 0.000208026336246947
#> Max relative change in theta = 0.000203403395850424
#> 2025-11-14 00:02:27.326159: starting EM iteration (E step) 86; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.82124
#> Change in log-likelihood = 0.0175275898295695
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.81354; theta =
#> (Intercept)           T 
#>    1.022318   -3.951629
#> 
#> Change in mu = 0.0167415293038715
#> Max change in theta = 0.000202073694000937
#> Max relative change in theta = 0.000197623235584042
#> 2025-11-14 00:02:28.41703: starting EM iteration (E step) 87; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.80423
#> Change in log-likelihood = 0.0170077974494234
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.79727; theta =
#> (Intercept)           T 
#>    1.022122   -3.951723
#> 
#> Change in mu = 0.0162655688877607
#> Max change in theta = 0.000196311053062947
#> Max relative change in theta = 0.000192025459382783
#> 2025-11-14 00:02:29.510286: starting EM iteration (E step) 88; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.78772
#> Change in log-likelihood = 0.0165081499295638
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.78147; theta =
#> (Intercept)           T 
#>    1.021931   -3.951815
#> 
#> Change in mu = 0.0158033050162913
#> Max change in theta = 0.000190732056944531
#> Max relative change in theta = 0.000186604088992236
#> 2025-11-14 00:02:30.611362: starting EM iteration (E step) 89; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.77169
#> Change in log-likelihood = 0.016027769761763
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.76611; theta =
#> (Intercept)           T 
#>    1.021745   -3.951904
#> 
#> Change in mu = 0.0153543465534369
#> Max change in theta = 0.00018533054467329
#> Max relative change in theta = 0.000181353321620974
#> 2025-11-14 00:02:31.71102: starting EM iteration (E step) 90; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.75613
#> Change in log-likelihood = 0.0155658187898098
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.75119; theta =
#> (Intercept)           T 
#>    1.021565   -3.951991
#> 
#> Change in mu = 0.0149183124418073
#> Max change in theta = 0.000180100548082596
#> Max relative change in theta = 0.000176267528293146
#> 2025-11-14 00:02:32.802871: starting EM iteration (E step) 91; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.741
#> Change in log-likelihood = 0.0151214965208055
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.7367; theta =
#> (Intercept)           T 
#>    1.021390   -3.952075
#> 
#> Change in mu = 0.0144948316042104
#> Max change in theta = 0.000175036290233077
#> Max relative change in theta = 0.000171341253250569
#> 2025-11-14 00:02:33.714534: starting EM iteration (E step) 92; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.72631
#> Change in log-likelihood = 0.0146940385010339
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.72262; theta =
#> (Intercept)           T 
#>    1.021220   -3.952156
#> 
#> Change in mu = 0.0140835427130384
#> Max change in theta = 0.000170132179579729
#> Max relative change in theta = 0.000166569209135608
#> 2025-11-14 00:02:34.631583: starting EM iteration (E step) 93; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.71203
#> Change in log-likelihood = 0.0142827147491289
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.70893; theta =
#> (Intercept)           T 
#>    1.021055   -3.952235
#> 
#> Change in mu = 0.0136840941606948
#> Max change in theta = 0.000165382809929282
#> Max relative change in theta = 0.000161946277788045
#> 2025-11-14 00:02:35.538554: starting EM iteration (E step) 94; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.69814
#> Change in log-likelihood = 0.0138868282515432
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.69564; theta =
#> (Intercept)           T 
#>    1.020894   -3.952312
#> 
#> Change in mu = 0.0132961437689829
#> Max change in theta = 0.000160782952851823
#> Max relative change in theta = 0.00015746750360545
#> 2025-11-14 00:02:36.445272: starting EM iteration (E step) 95; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.68464
#> Change in log-likelihood = 0.0135057135136094
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.68272; theta =
#> (Intercept)           T 
#>    1.020738   -3.952386
#> 
#> Change in mu = 0.0129193587682295
#> Max change in theta = 0.000156327557719438
#> Max relative change in theta = 0.000153128094322364
#> 2025-11-14 00:02:37.351095: starting EM iteration (E step) 96; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.6715
#> Change in log-likelihood = 0.0131387351675585
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.67016; theta =
#> (Intercept)           T 
#>    1.020586   -3.952458
#> 
#> Change in mu = 0.0125534154720128
#> Max change in theta = 0.000152011742987179
#> Max relative change in theta = 0.000148923413168733
#> 2025-11-14 00:02:38.257419: starting EM iteration (E step) 97; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.65871
#> Change in log-likelihood = 0.0127852866363583
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.65797; theta =
#> (Intercept)           T 
#>    1.020438   -3.952528
#> 
#> Change in mu = 0.0121979992138534
#> Max change in theta = 0.00014783079508085
#> Max relative change in theta = 0.000144848978433893
#> 2025-11-14 00:02:39.160335: starting EM iteration (E step) 98; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.64627
#> Change in log-likelihood = 0.0124447888491659
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.64611; theta =
#> (Intercept)           T 
#>    1.020294   -3.952595
#> 
#> Change in mu = 0.0118528041171402
#> Max change in theta = 0.00014378016254657
#> Max relative change in theta = 0.000140900458349893
#> 2025-11-14 00:02:40.240685: starting EM iteration (E step) 99; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.63415
#> Change in log-likelihood = 0.0121166890091899
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.63459; theta =
#> (Intercept)           T 
#>    1.020154   -3.952661
#> 
#> Change in mu = 0.0115175329332828
#> Max change in theta = 0.000139855451750437
#> Max relative change in theta = 0.000137073667454165
#> 2025-11-14 00:02:41.315779: starting EM iteration (E step) 100; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.62235
#> Change in log-likelihood = 0.0118004594115746
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.6234; theta =
#> (Intercept)           T 
#>    1.020018   -3.952724
#> 
#> Change in mu = 0.0111918967994455
#> Max change in theta = 0.000136052421186417
#> Max relative change in theta = 0.000133364561551801
#> 2025-11-14 00:02:42.39833: starting EM iteration (E step) 101; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.61085
#> Change in log-likelihood = 0.0114955963111925
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.61253; theta =
#> (Intercept)           T 
#>    1.019886   -3.952785
#> 
#> Change in mu = 0.0108756151248883
#> Max change in theta = 0.000132366978488063
#> Max relative change in theta = 0.000129769235293316
#> 2025-11-14 00:02:43.48028: starting EM iteration (E step) 102; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.59965
#> Change in log-likelihood = 0.0112016188353437
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.60196; theta =
#> (Intercept)           T 
#>    1.019757   -3.952844
#> 
#> Change in mu = 0.010568415349681
#> Max change in theta = 0.000128795174794138
#> Max relative change in theta = 0.000126283917127116
#> 2025-11-14 00:02:44.570104: starting EM iteration (E step) 103; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.58873
#> Change in log-likelihood = 0.0109180679432939
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.59169; theta =
#> (Intercept)           T 
#>    1.019632   -3.952901
#> 
#> Change in mu = 0.0102700327626906
#> Max change in theta = 0.000125333200187816
#> Max relative change in theta = 0.000122904965273412
#> 2025-11-14 00:02:45.658139: starting EM iteration (E step) 104; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.57809
#> Change in log-likelihood = 0.0106445054307187
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.58171; theta =
#> (Intercept)           T 
#>    1.019510   -3.952955
#> 
#> Change in mu = 0.00998021030903828
#> Max change in theta = 0.000121977379182292
#> Max relative change in theta = 0.000119628863715096
#> 2025-11-14 00:02:46.741564: starting EM iteration (E step) 105; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.56771
#> Change in log-likelihood = 0.0103805129740522
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.57201; theta =
#> (Intercept)           T 
#>    1.019391   -3.953008
#> 
#> Change in mu = 0.00969869839454418
#> Max change in theta = 0.000118724166235262
#> Max relative change in theta = 0.000116452218190099
#> 2025-11-14 00:02:47.832761: starting EM iteration (E step) 106; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.55758
#> Change in log-likelihood = 0.0101256912198551
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.56258; theta =
#> (Intercept)           T 
#>    1.019275   -3.953059
#> 
#> Change in mu = 0.0094252547046807
#> Max change in theta = 0.000115570141577592
#> Max relative change in theta = 0.000113371752466734
#> 2025-11-14 00:02:48.927801: starting EM iteration (E step) 107; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.5477
#> Change in log-likelihood = 0.00987965890897158
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.55342; theta =
#> (Intercept)           T 
#>    1.019163   -3.953109
#> 
#> Change in mu = 0.00915964401529834
#> Max change in theta = 0.00011251200640805
#> Max relative change in theta = 0.000110384303973596
#> 2025-11-14 00:02:50.008401: starting EM iteration (E step) 108; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.53806
#> Change in log-likelihood = 0.00964205204400059
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.54452; theta =
#> (Intercept)           T 
#>    1.019053   -3.953156
#> 
#> Change in mu = 0.00890163798115395
#> Max change in theta = 0.000109546579133868
#> Max relative change in theta = 0.000107486820433048
#> 2025-11-14 00:02:51.09226: starting EM iteration (E step) 109; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.52865
#> Change in log-likelihood = 0.00941252308939511
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.53587; theta =
#> (Intercept)           T 
#>    1.018947   -3.953202
#> 
#> Change in mu = 0.00865101497927867
#> Max change in theta = 0.000106670790971597
#> Max relative change in theta = 0.000104676355846478
#> 2025-11-14 00:02:52.179353: starting EM iteration (E step) 110; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.51946
#> Change in log-likelihood = 0.00919074020885091
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.52746; theta =
#> (Intercept)           T 
#>    1.018843   -3.953246
#> 
#> Change in mu = 0.00840755991355024
#> Max change in theta = 0.000103881681907891
#> Max relative change in theta = 0.00010195006681308
#> 2025-11-14 00:02:53.261721: starting EM iteration (E step) 111; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.51048
#> Change in log-likelihood = 0.00897638653680133
#> Starting M step, mem used = 208 MB
#> Ending M step; mu = 122.51929; theta =
#> (Intercept)           T 
#>    1.018742   -3.953288
#> 
#> Change in mu = 0.0081710640107957
#> Max change in theta = 0.000101176396527514
#> Max relative change in theta = 9.93052087000058e-05
#> 2025-11-14 00:02:54.521454: starting EM iteration (E step) 112; mem used = 208 MB
#> Ending E step.
#> observed-data log-likelihood = -642.50171
#> EM algorithm converged, based on log-likelihood and coefs, to 0.00876915948265378 change in log-likelihood, in 112 iterations.
```

The output of
[`fit_joint_model()`](https://d-morrison.github.io/rwicc/reference/fit_joint_model.md)
is a list with several components:

``` r
names(EM_algorithm_outputs)
#> [1] "Theta"               "Mu"                  "Omega"              
#> [4] "converged"           "iterations"          "convergence_metrics"
```

`Theta` is the vector of estimated logistic regression coefficients for
$P\left( Y|T \right)$ (intercept and slope):

``` r

pander(EM_algorithm_outputs$Theta)
```

| (Intercept) |   T    |
|:-----------:|:------:|
|    1.019    | -3.953 |

`Mu` is the corresponding $\widehat{\mu}$ estimate:

``` r
mu_est_EM = EM_algorithm_outputs$Mu
print(mu_est_EM)
#> [1] 122.5193
```

`converged` indicates whether the algorithm reached its convergence
criterion (= 1 if converged, = 0 if not).

``` r
EM_algorithm_outputs$converged
#> [1] 1
```

`iterations` is the number of EM iterations that the algorithm
performed:

``` r
EM_algorithm_outputs$iterations
#> [1] 112
```

`convergence_metrics` gives the values of all four metrics that we might
use to evaluate convergence:

- `diff logL`: change in log-likelihood between iterations
- `diff mu`: change in $\widehat{\mu}$
- `max abs diff coefs`:
  $\max_{j \in 0:1}\{\left| {\widehat{\theta}}_{j}^{(k)} - {\widehat{\theta}}_{j}^{(k - 1)} \right|\}$
- `max abs rel diff coefs`:
  $\max_{j \in 0:1}\{\left| \left( {\widehat{\theta}}_{j}^{(k)} - {\widehat{\theta}}_{j}^{(k - 1)} \right)/{\widehat{\theta}}_{j}^{(k - 1)} \right|\}$

By default, the convergence criterion is: `diff logL` \< 0.1 and
`max abs rel diff coefs` \< 0.0001.

``` r
pander(EM_algorithm_outputs$convergence_metrics)
```

| diff logL | diff mu  | max abs diff coefs | max abs rel diff coefs |
|:---------:|:--------:|:------------------:|:----------------------:|
| 0.008769  | 0.008171 |     0.0001012      |       9.931e-05        |

Next, we perform an alternative analysis using midpoint imputation:

``` r

theta_est_midpoint = fit_midpoint_model(
  obs_level_data = sim_obs_data,
  participant_level_data = sim_participant_data
)

pander(theta_est_midpoint)
```

| (Intercept) | T_midpoint |
|:-----------:|:----------:|
|   0.7572    |   -3.662   |

Here, we perform an alternative analysis using uniform imputation:

``` r
# uniform imputation:
theta_est_uniform = fit_uniform_model(
  obs_level_data = sim_obs_data,
  participant_level_data = sim_participant_data
)

pander(theta_est_uniform)
```

| theta0 | theta1 |
|:------:|:------:|
| -0.549 | -2.037 |

Now, let’s graph the results. First, let’s plot the true and estimated
CDFs for the distribution of seroconversion date, for individuals who
enroll on the first calendar day of the cohort study:

``` r

plot1 = plot_CDF(
  true_hazard_alpha = hazard_alpha,
  true_hazard_beta = hazard_beta,
  omega.hat = EM_algorithm_outputs$Omega)

print(plot1)
```

![](how-to-use-rwicc_files/figure-html/unnamed-chunk-14-1.png)

We can see that our joint modeling approach hasn’t estimated this
distribution very accurately for this particular simulated dataset.
Nevertheless, the next graph will show us that the joint model very
accurately estimates the true distribution $P\left( Y|T \right)$ and the
true value of $\mu$:

``` r

plot2 = plot_phi_curves(
  theta_true = theta_true,
  theta.hat_uniform = theta_est_uniform,
  theta.hat_midpoint = theta_est_midpoint,
  theta.hat_joint = EM_algorithm_outputs$Theta)

print(plot2)
```

![](how-to-use-rwicc_files/figure-html/unnamed-chunk-15-1.png)
