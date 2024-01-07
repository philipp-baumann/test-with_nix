# install_github("b-rodrigues/rix", ref = "71-with-nix")
library("rix")
library("dplyr")
library("data.table")

# main function to run
nrow_mtcars <- function(m = mtcars) {
  a <- m |> filter(cyl == 6L)
  stopifnot(test_df(a))
  cat("Object outside of function scope is of class: ", class(env_a))
  nrow_impl(a)
}

nrow_impl <- function(a) {
  not_returned <- data.table(a = 1:3)
  # `not_used` below should produce code check warning
  cat("`not_returned`", "has", nrow(not_returned), "rows.")
  df_check(a)
  nrow(a)
}

env_a <- new.env(parent = baseenv()) # enclosure package:base

env_a$key <- "value"

df_check <- function(x) stopifnot("x must be data.frame" = is_df(x))
# that does not work both in host an nix R session, which is expected,
# since function is in an environment
env_a$df_check <- function(x) stopifnot("x must be data.frame" = is_df(x))

# no downstream
is_df <- function(x) is.data.frame(x)

test_df <- function(a) is_df_a(a)
is_df_a <- function(a) is.data.frame(a)

out_nix <- with_nix(
  expr = nrow_mtcars,
  exec_mode = "non-blocking",
  project_path = "./with_nix"
)

