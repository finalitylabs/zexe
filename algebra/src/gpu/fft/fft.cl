uint bitreverse(uint n, uint bits) {
  uint r = 0;
  for(int i = 0; i < bits; i++) {
    r = (r << 1) | (n & 1);
    n >>= 1;
  }
  return r;
}

__kernel void radix_fft(__global FIELD* x,
                        __global FIELD* y,
                        __global FIELD* pq,
                        __global FIELD* omegas,
                        __local FIELD* u,
                        uint n,
                        uint lgp,
                        uint deg, // 1=>radix2, 2=>radix4, 3=>radix8, ...
                        uint max_deg)
{
  uint lid = get_local_id(0);
  uint lsize = get_local_size(0);
  uint index = get_group_id(0);
  uint t = n >> deg;
  uint p = 1 << lgp;
  uint k = index & (p - 1);

  x += index;
  y += ((index - k) << deg) + k;

  uint count = 1 << deg; // 2^deg
  uint counth = count >> 1; // Half of count

  uint counts = count / lsize * lid;
  uint counte = counts + count / lsize;

  //////// ~30% of total time
  FIELD twiddle = FIELD_pow_lookup(omegas, (n >> lgp >> deg) * k);
  ////////

  //////// ~35% of total time
  FIELD tmp = FIELD_pow(twiddle, counts);
  for(uint i = counts; i < counte; i++) {
    u[i] = FIELD_mul(tmp, x[i*t]);
    tmp = FIELD_mul(tmp, twiddle);
  }
  barrier(CLK_LOCAL_MEM_FENCE);
  ////////

  //////// ~35% of total time
  uint pqshift = max_deg - deg;
  for(uint rnd = 0; rnd < deg; rnd++) {
    uint bit = counth >> rnd;
    for(uint i = counts >> 1; i < counte >> 1; i++) {
      uint di = i & (bit - 1);
      uint i0 = (i << 1) - di;
      uint i1 = i0 + bit;
      tmp = u[i0];
      u[i0] = FIELD_add(u[i0], u[i1]);
      u[i1] = FIELD_sub(tmp, u[i1]);
      if(di != 0) u[i1] = FIELD_mul(pq[di << rnd << pqshift], u[i1]);
    }

    barrier(CLK_LOCAL_MEM_FENCE);
  }
  ////////

  for(uint i = counts >> 1; i < counte >> 1; i++) {
    y[i*p] = u[bitreverse(i, deg)];
    y[(i+counth)*p] = u[bitreverse(i + counth, deg)];
  }
}