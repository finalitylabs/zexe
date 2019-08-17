#define FIELD2_ZERO ((FIELD2){FIELD_ZERO, FIELD_ZERO})
#define FIELD2_ONE ((FIELD2){FIELD_ONE, FIELD_ZERO})

typedef struct {
  FIELD c0;
  FIELD c1;
} FIELD2;

bool FIELD2_eq(FIELD2 a, FIELD2 b) {
  return FIELD_eq(a.c0, b.c0) && FIELD_eq(a.c1, b.c1);
}
FIELD2 FIELD2_sub(FIELD2 a, FIELD2 b) {
  a.c0 = FIELD_sub(a.c0, b.c0);
  a.c1 = FIELD_sub(a.c1, b.c1);
  return a;
}
FIELD2 FIELD2_add(FIELD2 a, FIELD2 b) {
  a.c0 = FIELD_add(a.c0, b.c0);
  a.c1 = FIELD_add(a.c1, b.c1);
  return a;
}
FIELD2 FIELD2_double(FIELD2 a) {
  a.c0 = FIELD_double(a.c0);
  a.c1 = FIELD_double(a.c1);
  return a;
}
FIELD2 FIELD2_mul(FIELD2 a, FIELD2 b) {
  FIELD v0 = FIELD_mul(a.c0, b.c0);
  FIELD v1 = FIELD_mul(a.c1, b.c1);
  a.c1 = FIELD_add(a.c1, a.c0);
  a.c1 = FIELD_mul(a.c1, FIELD_add(b.c0, b.c1));
  a.c1 = FIELD_sub(a.c1, v0);
  a.c1 = FIELD_sub(a.c1, v1);
  a.c0 = FIELD_add(v0, FIELD_mul(v1, FIELD2_NONRESIDUE));
  return a;
}
FIELD2 FIELD2_sqr(FIELD2 a) {
  FIELD v0 = FIELD_sub(a.c0, a.c1);
  FIELD v3 = FIELD_sub(a.c0, FIELD_mul(a.c1, FIELD2_NONRESIDUE));
  FIELD2 v2 = FIELD_mul(a.c0, a.c1);
  v0 = FIELD_add(FIELD_mul(v0, v3), v2);
  a.c1 = FIELD_double(v2);
  a.c0 = FIELD_add(v0, FIELD_mul(v2, FIELD2_NONRESIDUE));
  return a;
}
