require(matrixcalc)
require(corpcor)
require(roxygen2)

#' The following functions enable so called "caching" of the inverse of a
#' square matrix.
#' @author Jens Hooge jens.hooge@gmail.com

#' @title Caching a matrix.
#' 
#' @description \code{makeCacheMatrix} caches a matrix.
#' 
#' @details
#' \code{makeCacheMatrix} expects a matrix x. The inverse, as well as the original matrix
#' are then stored in a "cached" form. "Cached" means that they are stored in
#' variables that are visible in the global namespace outside of makeCacheMatrix.
#' The function returns a list of getter and setter functions which allow
#' access to the globally cached objects.
#' 
#' @param x matrix to be cashed
#' 
#' @examples
#' ncol <- 3
#' nrow <- 3
#' x <- matrix(rnorm(nrow*ncol), nrow=nrow, ncol=ncol)
#' makeCacheMatrix(x)
#' 
#' @return list{base}
makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL # local assignment (living in makeCacheMatrix environment)
  set <- function(y) {
    x <<- y # global assignment (living in global environment)
    inv <<- NULL # global assignment (living in makeCacheMatrix environment)
  }
  
  ## getters and setters
  get <- function() x
  setInverse <- function(inverse) inv <<- inverse
  getInverse <- function() inv
  
  ## returned values
  list(set = set, 
       get = get,
       setInverse = setInverse,
       getInverse = getInverse)
}

#' @title Cached matrix inversion
#' 
#' @description \code{cacheSolve} invertes a cached matrix
#' 
#' @details
#' \code{cacheSolve} computes the inverse of a cached matrix if the inverse
#' has not yet been cached. If a cached result already exists, it will be
#' returned. If x is a non-invertable (rectangular) matrix, an error will 
#' be displayed. If x is degenerate/singular, it is only possible to compute
#' the pseudo-inverse and a warning will be displayed.
#' @param x A list object to access a cached matrix x
#' @examples
#' 
#' Well-behaved input
#' x <- matrix(c(1, 0, 5, 2, 1, 6, 3, 4, 0), nrow=3, ncol=3)
#' cacheSolve(makeCacheMatrix(x))
#' 
#' Rectangular input
#' x <- matrix(c(1, 1, 1, 1, 1, 1), nrow=3, ncol=2)
#' cacheSolve(makeCacheMatrix(x))
#' 
#' Singular input
#' x <- matrix(c(0, 0, 0, 0, 0, 1, 1, 1, 1), nrow=3, ncol=3)
#' cacheSolve(makeCachedMatrix(x))
#' @return matrix{base}
cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    data <- x$get()
    inv <- x$getInverse()
    nrow <- dim(data)[1] # number of rows of matrix x
    ncol <- dim(data)[2] # number of columns of matrix x
    
    if( nrow != ncol )
        stop("Not a square matrix!") # a rectangular matrix is non-invertible
    
    if(!is.null(inv)) {
        message("getting cached data")
        return(inv)
    }
    
    if(is.null(inv)){
        if(is.singular.matrix(x$get())) {
            warning("Matrix is degenerate! Pseudoinverse has been computed!")
            inv <-pseudoinverse(data)
        } else {
            inv <- solve(data, ...)
        }
        x$setInverse(inv)
    } else {
        message("getting cached data")
    }
    inv
}
