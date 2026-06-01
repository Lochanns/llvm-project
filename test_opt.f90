program test_opt
  implicit none

  integer, parameter :: n = 1000000
  real, allocatable :: A(:), B(:), C(:)
  integer :: i

  allocate(A(n), B(n), C(n))

  B = 1.0
  C = 2.0

  do i = 1, n
     A(i) = B(i) + C(i)
  end do

  print *, sum(A)

end program test_opt
