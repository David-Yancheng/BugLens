# Analyzers

## BugLens Currently Tests on two analyzers:

- [Suture](https://github.com/seclab-ucr/SUTURE) ([paper](https://www.cs.ucr.edu/%7Ezhiyunq/pub/ccs21_static_high_order.pdf))
- CodeQL-OOB (see `cfu.ql` and `overflow.ql` in `ql-src`) (based on https://securitylab.github.com/research/stack-buffer-overflow-qualcomm-msm/)

## Analysis Target:

To compare the performance of BugLens w.r.t. the two analyzers, we reuse their codebases:

Android Linux Kernel
- snapshot for ql: https://github.com/github/securitylab/releases/download/qualcomm-msm-codeql-database/msm-4.4-revision-2017-May-07--08-33-56.zip
- snapshot for Suture:
    - [msm](https://android.googlesource.com/kernel/msm/+/refs/tags/android-10.0.0_r0.56)
    - [msm-extra](https://android.googlesource.com/kernel/msm-extra/+archive/ed716fd749931264bb9dde8d8b1434446568b8c9.tar.gz)
    - [techpack] `src-techpack.tar.gz` (extracted from aosp `android-10.0.0_r45` branch)

## Analysis Results (from two original analyzers):

It is feasible to run these two analyzers directly on the codebases, we also directly put our results in `res`

### Suture

running on suture is complex, refer their [README](https://github.com/seclab-ucr/SUTURE) for details.



### CodeQL-OOB

```
codeql database analyze {ql-snapshot-path}  {ql-src-file}   --format=sarif-latest \
--output=output.serif --rerun -J-Xmx1024G
```

it will generate a `output.sarif` file, which is the result of CodeQL analysis.
