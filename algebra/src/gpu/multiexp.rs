use ocl::{ProQue, Buffer, MemFlags};
use crate::curves::PairingEngine;
use crate::fields::PrimeField;
use crate::curves::AffineCurve;
use super::error::{GPUResult, GPUError};
use super::sources;
use super::structs;

const NUM_GROUPS : usize = 224;
const WINDOW_SIZE : usize = 8;
const NUM_WINDOWS : usize = 32;
const LOCAL_WORK_SIZE : usize = 256;
const BUCKET_LEN : usize = 1 << WINDOW_SIZE;

pub struct MultiexpKernel<E> where E: PairingEngine {
    proque: ProQue,

    g1_base_buffer: Buffer<structs::AffineCurveStruct<E::G1Affine>>,
    g1_bucket_buffer: Buffer<structs::ProjectiveCurveStruct<E::G1Projective>>,
    g1_result_buffer: Buffer<structs::ProjectiveCurveStruct<E::G1Projective>>,

    exp_buffer: Buffer<structs::PrimeFieldStruct<E::Fr>>
}

impl<E> MultiexpKernel<E> where E: PairingEngine {

    pub fn create(n: u32) -> GPUResult<MultiexpKernel<E>> {
        let src = sources::multiexp_kernel::<E>();
        let pq = ProQue::builder().src(src).dims(n).build()?;

        let g1basebuff = Buffer::builder().queue(pq.queue().clone()).flags(MemFlags::new().read_write()).len(n).build()?;
        let g1buckbuff = Buffer::builder().queue(pq.queue().clone()).flags(MemFlags::new().read_write()).len(BUCKET_LEN * NUM_WINDOWS * NUM_GROUPS).build()?;
        let g1resbuff = Buffer::builder().queue(pq.queue().clone()).flags(MemFlags::new().read_write()).len(NUM_WINDOWS * NUM_GROUPS).build()?;

        let expbuff = Buffer::builder().queue(pq.queue().clone()).flags(MemFlags::new().read_write()).len(n).build()?;

        Ok(MultiexpKernel {proque: pq,
            g1_base_buffer: g1basebuff, g1_bucket_buffer: g1buckbuff, g1_result_buffer: g1resbuff,
            exp_buffer: expbuff})
    }

    pub fn multiexp<G: AffineCurve>(
        &mut self,
        bases: &[G],
        scalars: &[<G::ScalarField as PrimeField>::BigInt],
    ) -> GPUResult<G::Projective> {

        /*let exp_bits = std::mem::size_of::<E::Fr>() * 8;
        let n = exps.len();

        let mut res = [<G as AffineCurve>::Projective::zero(); NUM_WINDOWS * NUM_GROUPS];
        let exps = unsafe { std::mem::transmute::<Arc<Vec<<<G::Engine as ScalarEngine>::Fr as PrimeField>::Repr>>,Arc<Vec<<E::Fr as PrimeField>::Repr>>>(exps) }.to_vec();
        let texps = unsafe { std::mem::transmute::<&[<E::Fr as PrimeField>::Repr], &[structs::PrimeFieldStruct::<E::Fr>]>(&exps[..]) };
        self.exp_buffer.write(texps).enq()?;

        let mut gws = NUM_WINDOWS * NUM_GROUPS;
        gws += (LOCAL_WORK_SIZE - (gws % LOCAL_WORK_SIZE)) % LOCAL_WORK_SIZE;

        let sz = std::mem::size_of::<G>(); // Trick, used for dispatching between G1 and G2!
        if sz == std::mem::size_of::<E::G1Affine>() {
            let tbases = unsafe { std::mem::transmute::<&[G], &[structs::AffineCurveStruct<E::G1Affine>]>(&bases) };
            self.g1_base_buffer.write(tbases).enq()?;
            let kernel = self.proque.kernel_builder("G1_bellman_multiexp")
                .global_work_size([gws])
                .local_work_size([LOCAL_WORK_SIZE])
                .arg(&self.g1_base_buffer)
                .arg(&self.g1_bucket_buffer)
                .arg(&self.g1_result_buffer)
                .arg(&self.exp_buffer)
                .arg(&self.dm_buffer)
                .arg(skip as u32)
                .arg(n as u32)
                .arg(NUM_GROUPS as u32)
                .arg(NUM_WINDOWS as u32)
                .arg(WINDOW_SIZE as u32)
                .build()?;
            unsafe { kernel.enq()?; }
            let tres = unsafe { std::mem::transmute::<&mut [<G as AffineCurve>::Projective], &mut [structs::ProjectiveCurveStruct::<E::G1>]>(&mut res) };
            self.g1_result_buffer.read(tres).enq()?;

        } else {
            return Err(GPUError {msg: "Only E::G1!".to_string()} );
        }

        let mut acc = <G as AffineCurve>::Projective::zero();
        let mut bits = 0;
        for i in 0..NUM_WINDOWS {
            let w = std::cmp::min(WINDOW_SIZE, exp_bits - bits);
            for _ in 0..w { acc.double(); }
            for g in 0..NUM_GROUPS {
                acc.add_assign(&res[g * NUM_WINDOWS + i]);
            }
            bits += w;
        }

        Ok(acc)*/

        return Err(GPUError {msg: "Not implemented yet!".to_string()} );
    }
}
