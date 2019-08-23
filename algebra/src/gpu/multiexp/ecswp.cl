// Short Weierstrass Projective (Used in MNT6, SW6)

#define POINT_ZERO ((POINT_projective){FIELD_ZERO, FIELD_ONE, FIELD_ZERO})

typedef struct {
  FIELD x;
  FIELD y;
  bool inf;
} POINT_affine;

typedef struct {
  FIELD x;
  FIELD y;
  FIELD z;
} POINT_projective;

POINT_projective POINT_double(POINT_projective inp) {
  if(FIELD_eq(inp.z, FIELD_ZERO)) return inp;
  FIELD xx = FIELD_sqr(inp.x); // XX = X1^2
  FIELD zz = FIELD_sqr(inp.z); // ZZ = Z1^2
  // w = a*ZZ + 3*XX
  FIELD w = FIELD_add(FIELD_mul(zz, POINT_COEFF_A), FIELD_add(xx, FIELD_double(xx)));
  FIELD s = FIELD_double(FIELD_mul(inp.y, inp.z)); // s = 2*Y1*Z1
  FIELD sss = FIELD_mul(FIELD_sqr(s), s); // sss = s^3
  FIELD r = FIELD_mul(inp.y, s); // R = Y1*s
  FIELD rr = FIELD_sqr(r); // RR = R2
  // B = (X1+R)^2-XX-RR
  FIELD b = FIELD_sub(FIELD_sub(FIELD_sqr(FIELD_add(inp.x, r)), xx), rr);
  FIELD h = FIELD_sub(FIELD_sqr(w), FIELD_double(b, b)); // h = w2-2*B
  inp.x = FIELD_mul(h, s); // X3 = h*s
  // Y3 = w*(B-h)-2*RR
  inp.y = FIELD_sub(FIELD_mul(w, FIELD_sub(b, h)), FIELD_double(rr, rr));
  inp.z = sss; // Z3 = sss
  return inp;
}

POINT_projective POINT_add_mixed(POINT_projective a, POINT_affine b) {
  if(b.inf) return a;

  if(FIELD_eq(a.z, FIELD_ZERO)) {
    a.x = b.x;
    a.y = b.y;
    a.z = FIELD_ONE;
    return a;
  }

  FIELD v = FIELD_mul(b.x, a.z);
  FIELD u = FIELD_mul(b.y, a.z);
  if(FIELD_eq(u, a.y) && FIELD_eq(v, a.x)) {
    return POINT_double(a);
  } else {
    u = FIELD_sub(u, a.y); // u = Y2*Z1-Y1
    FIELD uu = FIELD_sqr(u); // uu = u^2
    v = FIELD_sub(v, a.x); // v = X2*Z1-X1
    FIELD vv = FIELD_sqr(v); // vv = v2
    FIELD vvv = FIELD_mul(v, vv); // vvv = v*vv
    FIELD r = FIELD_mul(vv, a.x); // r = vv*X1
    // a = uu*Z1-vvv-2*r
    FIELD a = FIELD_sub(FIELD_sub(FIELD_mul(uu, a.z), vvv), FIELD_double(r));
    a.x = FIELD_mul(v, a); // X3 = v*a
    // Y3 = u*(R-A)-vvv*Y1
    a.y = FIELD_sub(FIELD_mul(u, FIELD_sub(r, a)), FIELD_mul(vvv, a.y));
    a.z = FIELD_mul(vvv, a.z); // Z3 = vvv*Z1
    return a;
  }
}

POINT_projective POINT_add(POINT_projective a, POINT_projective b) {
  if(FIELD_eq(a.z, FIELD_ZERO)) return b;
  if(FIELD_eq(b.z, FIELD_ZERO)) return a;

  FIELD y1z2 = FIELD_mul(a.y, b.z); // Y1Z2 = Y1*Z2
  FIELD x2z1 = FIELD_mul(b.x, a.z); // X2Z1 = X2*Z1
  FIELD x1z2 = FIELD_mul(a.x, b.z); // X1Z2 = X1*Z2
  FIELD y2z1 = FIELD_mul(b.y, a.z); // Y2Z1 = Y2*Z1

  if(FIELD_eq(x1z2, x2z1) && int768_eq(y1z2, y2z1)) {
    return POINT_double(a);
  } else {
    FIELD z1z2 = FIELD_mul(a.z, b.z); // Z1Z2 = Z1*Z2
    FIELD u = FIELD_sub(y2z1, y1z2); // u = Y2Z1-Y1Z2
    FIELD uu = FIELD_sqr(u); // uu = u^2
    FIELD v = FIELD_sub(x2z1, x1z2); // v = X2Z1-X1Z2
    FIELD vv = FIELD_sqr(v); // vv = v^2
    FIELD vvv = FIELD_mul(v, vv); // vvv = v*vv
    FIELD r = FIELD_mul(vv, x1z2); // R = vv*X1Z2
     // A = uu*Z1Z2-vvv-2*R
    FIELD a = FIELD_sub(FIELD_mul(uu, z1z2), FIELD_add(vvv, FIELD_double(r)));
    a.x = FIELD_mul(v, a); // X3 = v*A
    // Y3 = u*(R-A)-vvv*Y1Z2
    a.y = FIELD_sub(FIELD_mul(FIELD_sub(r, a), u), FIELD_mul(vvv, y1z2));
    a.z = FIELD_mul(vvv, z1z2); // Z3 = vvv*Z1Z2
    return a;
  }
}
