% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subset_SingleGrainData.R
\name{subset_SingleGrainData}
\alias{subset_SingleGrainData}
\title{Simple Subsetting of Single Grain Data from Risø BIN/BINX files}
\usage{
subset_SingleGrainData(object, selection)
}
\arguments{
\item{object}{\linkS4class{Risoe.BINfileData} (\strong{required}): input object with the
data to subset}

\item{selection}{\link{data.frame} (\strong{required}): selection table with two columns
for position (1st column) and grain (2nd column) (columns names do not matter)}
}
\value{
A subset \linkS4class{Risoe.BINfileData} object
}
\description{
Most measured single grains do not exhibit light and it makes
usually sense to subset single grain datasets using a table of
position and grain pairs
}
\section{Function version}{
 0.1.0
}

\examples{

## load example data
data(ExampleData.BINfileData, envir = environment())

## set POSITION/GRAIN pair dataset
selection <- data.frame(POSITION = c(1,5,7), GRAIN = c(0,0,0))

##subset
subset_SingleGrainData(object = CWOSL.SAR.Data, selection = selection)

}
\seealso{
\linkS4class{Risoe.BINfileData}, \link{read_BIN2R}, \link{verify_SingleGrainData}
}
\author{
Sebastian Kreutzer, Institute of Geography, Heidelberg University (Germany)
}
\keyword{datagen}
\keyword{manip}
