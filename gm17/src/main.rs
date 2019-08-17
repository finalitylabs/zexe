use gm17::{
    create_random_proof, generate_random_parameters, prepare_verifying_key, verify_proof,
};

use algebra::{curves::mnt6::MNT6, fields::mnt6::Fr, fields::Field};
use rand::thread_rng;

mod dummy;
use dummy::DummyCircuit;

fn main() {
    let rng = &mut thread_rng();

    println!("Generating params...");
    let params =
        generate_random_parameters::<MNT6, _, _>(DummyCircuit { xx: None }, rng)
            .unwrap();
    println!("Done!");

    let pvk = prepare_verifying_key::<MNT6>(&params.vk);

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
