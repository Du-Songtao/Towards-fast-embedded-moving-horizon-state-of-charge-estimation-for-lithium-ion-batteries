# Towards fast embedded moving horizon state-of-charge estimation for lithium-ion batteries [[paper]](https://www.sciencedirect.com/science/article/pii/S2352152X23034230)
Wan, Yiming, Songtao Du, Jiayu Yan, and Zhuo Wang. 

"Towards fast embedded moving horizon state-of-charge estimation for lithium-ion batteries." 

Journal of Energy Storage 78 (2024): 110024.

## Abstract
For state-of-charge (SOC) estimation with high precision, moving horizon estimation (MHE) has recently emerged as a competitive alternative to various Kalman filters or observers due to its significantly improved accuracy and robustness. However, MHE demands considerably higher computational complexity, preventing its deployment on a low-cost embedded microcontroller. To address this challenge, we propose a fast moving horizon SOC estimation algorithm to retain the benefits of MHE at a vastly reduced computational cost. In particular, we consider joint SOC and parameter estimation for an SOC-dependent equivalent circuit model subject to model mismatch. The proposed fast joint MHE (jMHE) algorithm performs a fixed number of Gauss–Newton (GN) iterations to approximate the fully converged solution. At each iteration, the GN Hessian matrix is factorized by exploiting its block tridiagonal structure to construct computationally efficient forward–backward recursions. To further speed up computations, another fast jMHE algorithm wtih an Event-Triggered Relinearization strategy (jMHE-ETR) is proposed to avoid refactorizing the GN Hessian matrix at each iteration. Using experimental datasets under different operating conditions, it is verified on both laptop and Raspberry Pi microcontroller that compared to the conventional optimal MHE solved with an off-the-shelf solver, the proposed fast jMHE and jMHE-ETR algorithms both have a slight loss of performance (still significantly better than extended Kalman filtering) while reducing its computational cost by an order of magnitude.

## Keywords
* State-of-charge estimation
* Moving horizon estimation
* Real-time computation
* Lithium-ion battery

## Steps to run
### Set Paths in Matlab/Octave
* Open Matlab or Octave.
* Set ./matlabcode or  ./octavecode as the current working directory.
### Implement different estimation algorithms
* Run the main_ekf.m to implement the joint EKF.
* Run the main_optimalMHE.m to implement the optimal jMHE.
* Run the main_fastMHE.m to implement the fast jMHE.
* Run the main_fasterMHE.m to implement the fast jMHE with ETR.

## Citation
If you find our work useful in your research or publications, please consider citing:
```
@article{wan2024towards,
  title={Towards fast embedded moving horizon state-of-charge estimation for lithium-ion batteries},
  author={Wan, Yiming and Du, Songtao and Yan, Jiayu and Wang, Zhuo},
  journal={Journal of Energy Storage},
  volume={78},
  pages={110024},
  year={2024},
  publisher={Elsevier}
}
```


