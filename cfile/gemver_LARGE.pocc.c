#include <math.h>



void kernel_gemver(int n,float alpha,float beta,float A[2000][2000],float u1[2000],float v1[2000],float u2[2000],float v2[2000],float w[2000],float x[2000],float y[2000],float z[2000])
{
  int i;
  int j;
{
    
    
#ifdef ceild
# undef ceild
#endif
#ifdef floord
# undef floord
#endif
#ifdef max
# undef max
#endif
#ifdef min
# undef min
#endif
#define ceild(n,d) (((n) < 0) ? -((-(n))/(d)) : ((n)+(d)-1)/(d))
#define floord(x,y) (((x) < 0)? -((-(x)+(y)-1)/(y)) : (x)/(y))
#define max(x,y)    ((x) > (y)? (x) : (y))
#define min(x,y)    ((x) < (y)? (x) : (y))
/* Copyright (C) 1991-2022 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */
/* This header is separate from features.h so that the compiler can
   include it implicitly at the start of every compilation.  It must
   not itself include <features.h> or any other header that includes
   <features.h> because the implicit include comes before any feature
   test macros that may be defined in a source file before it first
   explicitly includes a system header.  GCC knows the name of this
   header in order to preinclude it.  */
/* glibc's intent is to support the IEC 559 math functionality, real
   and complex.  If the GCC (4.9 and later) predefined macros
   specifying compiler intent are available, use them to determine
   whether the overall intent is to support these features; otherwise,
   presume an older compiler has intent to support these features and
   define these macros by default.  */
/* wchar_t uses Unicode 10.0.0.  Version 10.0 of the Unicode Standard is
   synchronized with ISO/IEC 10646:2017, fifth edition, plus
   the following additions from Amendment 1 to the fifth edition:
   - 56 emoji characters
   - 285 hentaigana
   - 3 additional Zanabazar Square characters */
  register int lbv, ubv, lb, ub, lb1, ub1, lb2, ub2;
  register int c1, c3;
#pragma scop
for (c1 = 0; c1 <= 1999; c1++) {
  {
    for (c3 = 0; c3 <= 1999; c3++) {
      {
        A[c1][c3] = A[c1][c3] + u1[c1] * v1[c3] + u2[c1] * v2[c3];
      }
    }
  }
}
for (c1 = 0; c1 <= 1999; c1++) {
  {
    for (c3 = 0; c3 <= 1999; c3++) {
      {
        x[c1] = x[c1] + beta * A[c3][c1] * y[c3];
      }
    }
  }
}
for (c1 = 0; c1 <= 1999; c1++) {
  {
    x[c1] = x[c1] + z[c1];
  }
}
for (c1 = 0; c1 <= 1999; c1++) {
  {
    for (c3 = 0; c3 <= 1999; c3++) {
      {
        w[c1] = w[c1] + alpha * A[c1][c3] * x[c3];
      }
    }
  }
}
#pragma endscop
  }

}
