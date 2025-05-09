test_that("Test combine_De_Dr", {
  testthat::skip_on_cran()

  ## set seed
  set.seed(1276)

  ## simple test using the example
  ## set parameters
  Dr <- stats::rlnorm(1000, 0, 0.3)
  De <- 50*sample(Dr, 50, replace = TRUE)
  s <- stats::rnorm(50, 10, 2)

  ## break function
  SW({
  expect_error(combine_De_Dr(
    Dr = Dr,
    int_OD = 0.1,
    De,
    s[-1]), "'De' and 's' should have the same length")

  ## simple run with standard settings
  results <- expect_s4_class(combine_De_Dr(
    Dr = Dr,
    int_OD = 0.1,
    De,
    s,
    outlier_analysis_plot = TRUE,
    Age_range = c(0, 100),
    cdf_ADr_quantiles = FALSE,
    legend.pos = "topright",
    legend = TRUE,
    method_control = list(n.iter = 100,
                          n.chains = 1)), "RLum.Results")
  })

  ## check whether mcmc is NULL
  expect_null(results$mcmc_IAM)
  expect_null(results$mcmc_BCAM)

  ## run the same with different par settings
  oldpar <- par(mfrow = c(2,2))
  SW({
  results <- expect_s4_class(combine_De_Dr(
    Dr = Dr,
    int_OD = 0.1,
    De,
    s,
    outlier_analysis_plot = TRUE,
    par_local = FALSE,
    Age_range = c(0, 100),
    method_control = list(
      n.iter = 100,
      n.chains = 1,
      return_mcmc = TRUE
      )), "RLum.Results")
  })

  ## check the length of the output
  expect_length(results, 9)

  ## check whether we have the MCMC plots
  expect_s3_class(results$mcmc_IAM, "mcmc.list")
  expect_s3_class(results$mcmc_BCAM, "mcmc.list")

  ## try to plot the results again
  SW({
  plot_OSLAgeSummary(results)
  })

  ## diag = TRUE
  SW({
  expect_error(combine_De_Dr(
    Dr = Dr, int_OD = 0.1, De, s, Age_range = c(0, 100),
    method_control = list(n.iter = 100, n.chains = 1, diag = TRUE)),
    "You need at least two chains")
  expect_s4_class(combine_De_Dr(
    Dr = Dr, int_OD = 0.1, De, s, Age_range = c(0, 100),
    method_control = list(n.iter = 100, n.chains = 2, diag = TRUE)),
    "RLum.Results")
  })

  ## cdf_ADr_quantiles = TRUE and outlier_method = "RousseeuwCroux1993"
  SW({
  expect_s4_class(combine_De_Dr(
    Dr = Dr, int_OD = 0.1, De, s, Age_range = c(0, 100),
    cdf_ADr_quantiles = TRUE,
    outlier_method = "RousseeuwCroux1993",
    method_control = list(n.iter = 100, n.chains = 1)),
    "RLum.Results")
  })

  ## meaningless data for coverage
  set.seed(1)
  Dr.short <- stats::rlnorm(10, 0, 0.3)
  De.short <- 50 * sample(Dr, 2, replace = TRUE)
  s.short <- stats::rnorm(2, 10, 2)

  SW({
  combine_De_Dr(
    Dr = Dr.short,
    int_OD = 0.1,
    De.short,
    s.short,
    outlier_analysis_plot = TRUE,
    Age_range = c(0, 100),
    cdf_ADr_quantiles = FALSE)
  })

  ## reset the graphical parameters to the original values
  par(oldpar)
})
