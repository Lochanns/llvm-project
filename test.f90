program hidden_allocations
  implicit none

  integer, parameter :: n = 1000000
  real, allocatable :: A(:), B(:), C(:)
  real, allocatable :: D(:,:), E(:,:)
  real :: s

  integer :: i

  ! Explicit heap allocations
  allocate(A(n), B(n), C(n))
  allocate(D(1000,1000), E(1000,1000))

  B = 1.0
  C = 2.0

  ! ---------------------------------------------------
  ! CASE 1: Array expression temporary
  ! Likely hidden allocation
  ! ---------------------------------------------------
  A = B + C

  ! ---------------------------------------------------
  ! CASE 2: Nested expression
  ! More temporaries possible
  ! ---------------------------------------------------
  A = sin(B + C) * 2.0

  ! ---------------------------------------------------
  ! CASE 3: Array section temporary
  ! Slice often creates temp
  ! ---------------------------------------------------
  A(1:n/2) = B(2:n/2+1) + C(1:n/2)

  ! ---------------------------------------------------
  ! CASE 4: MATMUL may allocate temporary
  ! ---------------------------------------------------
  D = matmul(D, E)

  ! ---------------------------------------------------
  ! CASE 5: Reduction operation
  ! ---------------------------------------------------
  s = sum(B + C)

  ! ---------------------------------------------------
  ! CASE 6: Reallocation due to shape mismatch
  ! ---------------------------------------------------
  deallocate(A)
  allocate(A(n/2))

  A = B(1:n/2)

  ! ---------------------------------------------------
  ! CASE 7: Manual loop version
  ! Should avoid temporaries
  ! ---------------------------------------------------
  do i = 1, n
     B(i) = B(i) + C(i)
  end do

  print *, "Done", s

  deallocate(A, B, C, D, E)

end program hidden_allocations
