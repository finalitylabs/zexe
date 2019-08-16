use gm17::{
    create_random_proof, generate_random_parameters, prepare_verifying_key, verify_proof,
};

use algebra::{curves::bls12_377::Bls12_377, fields::bls12_377::Fr, fields::Field};
use rand::thread_rng;

mod dummy;
use dummy::DummyCircuit;

fn main() {
    let rng = &mut thread_rng();

    println!("Generating params...");
    let params =
        generate_random_parameters::<Bls12_377, _, _>(DummyCircuit { xx: None }, rng)
            .unwrap();
    println!("Done!");

    let pvk = prepare_verifying_key::<Bls12_377>(&params.vk);

    println!("Generating proof...");
    let proof = create_random_proof(
        DummyCircuit {
            xx: Some(Fr::one())
        },
        &params,
        rng,
    )
    .unwrap();
    println!("Done!");

    println!("Correct? {}", verify_proof(&pvk, &proof, &[]).unwrap());
}
