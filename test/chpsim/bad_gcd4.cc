// "bad_gcd4.cc"
// extra library function provided for chpsim

#include "sim/chpsim/chpsim_dlfunction.h"
// #include "libhackt/sim/chpsim/chpsim_dlfunction.h"

USING_CHPSIM_DLFUNCTION_PROLOGUE

// wrong number of arguments -- run-time error?
// actually additional arguments are just dropped!
// doesn't result in run-time error
static
int_value_type
gcd(const int_value_type a) {
	return 666;
}

CHP_DLFUNCTION_LOAD_DEFAULT("my_gcd", gcd)
