#define FIELD3_ZERO ((FIELD3){FIELD_ZERO, FIELD_ZERO, FIELD_ZERO})
#define FIELD3_ONE ((FIELD3){FIELD_ONE, FIELD_ZERO, FIELD_ZERO})

typedef struct {
  FIELD c0;
  FIELD c1;
  FIELD c2;
} FIELD3;

bool FIELD3_eq(FIELD3 a, FIELD3 b) {
  return FIELD_eq(a.c0, b.c0) && FIELD_eq(a.c1, b.c1) && FIELD_eq(a.c2, b.c2);
}
FIELD3 FIELD3_sub(FIELD3 a, FIELD3 b) {
  a.c0 = FIELD_sub(a.c0, b.c0);
  a.c1 = FIELD_sub(a.c1, b.c1);
  a.c2 = FIELD_sub(a.c2, b.c2);
  return a;
}
FIELD3 FIELD3_add(FIELD3 a, FIELD3 b) {
  a.c0 = FIELD_add(a.c0, b.c0);
  a.c1 = FIELD_add(a.c1, b.c1);
  a.c2 = FIELD_add(a.c2, b.c2);
  return a;
}
FIELD3 FIELD3_double(FIELD3 a) {
  a.c0 = FIELD_double(a.c0);
  a.c1 = FIELD_double(a.c1);
  a.c2 = FIELD_double(a.c2);
  return a;
}
FIELD3 FIELD3_mul(FIELD3 a, FIELD3 b) {
  FIELD ad = FIELD_mul(a.c0, b.c0);
  FIELD be = FIELD_mul(a.c1, b.c1);
  FIELD cf = FIELD_mul(a.c2, b.c2);
  FIELD x = FIELD_sub(FIELD_sub(FIELD_mul(FIELD_add(a.c1, a.c2), FIELD_add(b.c1, b.c2)), be), cf);
  FIELD y = FIELD_sub(FIELD_sub(FIELD_mul(FIELD_add(a.c0, a.c1), FIELD_add(b.c0, b.c1)), ad), be);
  FIELD z = FIELD_sub(FIELD_sub(FIELD_sub(FIELD_mul(FIELD_add(a.c0, a.c2), FIELD_add(b.c0, b.c2)), ad), be), cf);
  a.c0 = FIELD_add(ad, FIELD_mul(x, FIELD3_NONRESIDUE));
  a.c1 = FIELD_add(y, FIELD_mul(cf, FIELD3_NONRESIDUE));
  a.c2 = z;
  return a;
}
FIELD3 FIELD3_sqr(FIELD3 a) {
  FIELD s0 = FIELD_sqr(a.c0);
  FIELD ab = FIELD_mul(a.c0, a.c1);
  FIELD s1 = FIELD_double(ab);
  FIELD s2 = FIELD_sqr(FIELD_add(FIELD_sub(a.c0, a.c1), a.c2));
  FIELD bc = FIELD_mul(a.c1, a.c2);
  FIELD s3 = FIELD_double(bc);
  FIELD s4 = FIELD_sqr(c);
  a.c0 = FIELD_add(s0, FIELD_mul(s3, FIELD3_NONRESIDUE));
  a.c1 = FIELD_add(s1, FIELD_mul(s4, FIELD3_NONRESIDUE));
  a.c2 = FIELD_sub(FIELD_sub(FIELD_add(FIELD_add(s1, s2), s3), s0), s4);
  return a;
}
