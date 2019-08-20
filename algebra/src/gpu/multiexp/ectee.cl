// Twisted Edwards Extended

#define POINT_ZERO ((POINT_projective){FIELD_ZERO, FIELD_ONE, FIELD_ZERO, FIELD_ONE})

typedef struct {
  FIELD x;
  FIELD y;
} POINT_affine;

typedef struct {
  FIELD x;
  FIELD y;
  FIELD t;
  FIELD z;
} POINT_projective;

POINT_projective POINT_double(POINT_projective inp) {
  return POINT_ZERO;
}

POINT_projective POINT_add_mixed(POINT_projective a, POINT_affine b) {
  return POINT_ZERO;
}

POINT_projective POINT_add(POINT_projective a, POINT_projective b) {
  return POINT_ZERO;
}
