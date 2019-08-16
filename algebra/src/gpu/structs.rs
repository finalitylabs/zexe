use crate::curves::{AffineCurve, ProjectiveCurve};
use crate::fields::PrimeField;
use ocl::traits::OclPrm;
use std::marker::PhantomData;

#[derive(PartialEq, Debug, Clone, Copy)]
pub struct PrimeFieldStruct<T>(T, PhantomData<T>);
impl<T> Default for PrimeFieldStruct<T> where T: PrimeField {
    fn default() -> Self { PrimeFieldStruct::<T>(T::zero(), PhantomData::<T>) }
}
unsafe impl<T> OclPrm for PrimeFieldStruct<T> where T: PrimeField { }

#[derive(PartialEq, Debug, Clone, Copy)]
pub struct AffineCurveStruct<T>(T, PhantomData<T>);
impl<T> Default for AffineCurveStruct<T> where T: AffineCurve {
    fn default() -> Self { AffineCurveStruct::<T>(T::zero(), PhantomData::<T>) }
}
unsafe impl<T> OclPrm for AffineCurveStruct<T> where T: AffineCurve { }

#[derive(PartialEq, Debug, Clone, Copy)]
pub struct ProjectiveCurveStruct<T>(T, PhantomData<T>);
impl<T> Default for ProjectiveCurveStruct<T> where T: ProjectiveCurve {
    fn default() -> Self { ProjectiveCurveStruct::<T>(T::zero(), PhantomData::<T>) }
}
unsafe impl<T> OclPrm for ProjectiveCurveStruct<T> where T: ProjectiveCurve { }
