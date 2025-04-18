test_that("check function", {
  testthat::skip_on_cran()

  ##load data
  data(ExampleData.XSYG, envir = environment())

  ##create efficiency data
  eff_data <- data.frame(WAVELENGTH = 1:1000, runif(1000))

  ##break function
  expect_error(apply_EfficiencyCorrection(object = "ERROR"),
               "'object' should be of class 'RLum.Data.Spectrum'")
  expect_error(apply_EfficiencyCorrection(object = TL.Spectrum, spectral.efficiency = "ERROR"),
               "'spectral.efficiency' should be of class 'data.frame'")

  eff_data_false <- eff_data
  eff_data_false[1,2] <- 2
  expect_error(apply_EfficiencyCorrection(
    object = TL.Spectrum,
    spectral.efficiency = eff_data_false),
    "Relative quantum efficiency values > 1 are not allowed")

  ##run tests
  expect_s4_class(apply_EfficiencyCorrection(TL.Spectrum,spectral.efficiency = eff_data),
                  "RLum.Data.Spectrum")

  ##run list test
  expect_warning(
    apply_EfficiencyCorrection(list(a = "test", TL.Spectrum), spectral.efficiency = eff_data),
    "Skipping 'character' object in input list")

  ##run test with RLum.Analysis objects
  expect_s4_class(
    apply_EfficiencyCorrection(set_RLum("RLum.Analysis",
                                        records = list(TL.Spectrum)), spectral.efficiency = eff_data),
    "RLum.Analysis")
  expect_warning(
      apply_EfficiencyCorrection(set_RLum("RLum.Analysis",
                                          records = list(TL.Spectrum, "test")),
                                 spectral.efficiency = eff_data),
      "Skipping 'character' object in input list")

  ##run test with everything combined
  input <- list(a = "test", TL.Spectrum,set_RLum("RLum.Analysis", records = list(TL.Spectrum)))
  expect_warning(apply_EfficiencyCorrection(input, eff_data),
                 "Skipping 'character' object in input list")
})
