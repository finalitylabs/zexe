use algebra::Field;
use r1cs_core::{ConstraintSynthesizer, ConstraintSystem, SynthesisError};

pub struct DummyCircuit<F: Field> {
    pub xx: Option<F>
}

impl<ConstraintF: Field> ConstraintSynthesizer<ConstraintF> for DummyCircuit<ConstraintF> {
    fn generate_constraints<CS: ConstraintSystem<ConstraintF>>(
        self,
        cs: &mut CS,
    ) -> Result<(), SynthesisError> {

        let mut x_val = Some(ConstraintF::one().double());
        let mut x = cs.alloc(|| "", || {
            x_val.ok_or(SynthesisError::AssignmentMissing)
        })?;

        for k in 0..10_000 {
            // Allocate: x * x = x2
            let x2_val = x_val.map(|mut e| {
                e.square();
                e
            });
            let x2 = cs.alloc(|| "", || {
                x2_val.ok_or(SynthesisError::AssignmentMissing)
            })?;

            // Enforce: x * x = x2
            cs.enforce(
                || "",
                |lc| lc + x,
                |lc| lc + x,
                |lc| lc + x2
            );

            x = x2;
            x_val = x2_val;
        }

        cs.enforce(
            || "",
            |lc| lc + (x_val.unwrap(), CS::one()),
            |lc| lc + CS::one(),
            |lc| lc + x
        );

        Ok(())
    }
}
