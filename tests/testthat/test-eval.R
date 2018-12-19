library(logger)
library(testthat)

## save current settings so that we can reset later
layout <- log_layout()
threshold <- log_threshold()
log_layout(layout_glue_generator('{level} {msg}'))

context('log_eval')
test_that('single line', {
    expect_output(log_eval(4, INFO), "INFO '4' => '4'")
})

test_that('multi line', {
    expect_output(log_eval(4, INFO, multiline = TRUE), "Running expression")
    expect_output(log_eval(4, INFO, multiline = TRUE), "Results:")
    expect_output(log_eval(4, INFO, multiline = TRUE), "INFO 4")
})

test_that('invisible return', {
    expect_output(log_eval(require(logger), INFO), "INFO 'require\\(logger\\)' => 'TRUE'")
})

log_threshold(TRACE)
test_that('lower log level', {
    expect_output(log_eval(4), "TRACE '4' => '4'")
})

## reset settings
log_threshold(threshold)
log_layout(layout)