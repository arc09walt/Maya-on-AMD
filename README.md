# Maya-on-AMD

Project Maya's GLM-5.3-Flash (321B MoE, about 18B active) running on a single AMD RX 6800 under Windows - the hardware square their own docs leave unvalidated - packaged as a one-press app.

Proofed by Songwright

## The proof

Machine:

- GPU: AMD RX 6800, 16 GB (gfx1030 / RDNA 2)
- CPU: Ryzen 7 3700X
- RAM: 64 GB
- Storage: NVMe SSD
- OS: Windows

Software:

- Project Maya v1.1.82, HIP backend
- ROCm 7.14.1 (multi-arch wheel, gfx1030 device package)
- Model: GLM-5.3-Flash - Maya-XS (IQ1_S, 73.4 GB), 32K context

Where the brain lives while it runs (the engine's own dashboard):

- VRAM: 1,209 experts, 7.0 GB
- Pinned RAM: 6,093 experts, 27.0 GB
- SSD only: about 5,800 experts

Measured on the machine (the engine's own request ledger):

- Cold, "hi", thinking on max: 813 tokens out at 3.2 tok/s decode - 256.1 s total, 250.9 s of it thinking
- Warm, short answer: 12 tokens at 4.1 tok/s, 58.1% of experts served from VRAM, 8.7 s
- Sustained, an essay with thinking off: 434 tokens at 3.1 tok/s, 48.1% VRAM hit, 141.5 s

The rate is fetch-bound, not compute-bound: every token pulls experts from RAM and SSD. The engine's own advice on this machine: more RAM helps. These are baseline numbers, untuned.

## The road

1. Make one folder for the whole thing. This package lives at its root.
2. Clone Project Maya into it as `project-maya`. The setup builds the engine, so a C++ build toolchain (Visual Studio 2022 Build Tools) needs to be on the machine first.
3. First check, from inside `project-maya`: `START-MAYA.bat --backend hip --gpu 0 --check`. On an RX 6800 it passes everything except one gap: no ROCm device package for gfx1030.
4. Fill the gap with the venv's own pip: `project-maya\.venv\Scripts\pip.exe install --index-url https://repo.amd.com/rocm/whl-multi-arch/ "rocm[libraries,devel,device-gfx1030]==7.14.1"`
5. Re-run the check - all green. Their warning stands: RDNA 2 is experimental and unvalidated. That is the gap this repo closes.
6. Setup: `START-MAYA.bat --backend hip --gpu 0 --setup --model glm-maya-xs`, and pick 32K context when asked. It downloads the 73.4 GB model and finishes the build.
7. Copy Start-Maya.cmd and Stop-Maya.cmd from this package to the root folder, next to `project-maya`.

## The app

- Press **Start-Maya.cmd**: if Maya is already up it just opens the window; if not, it starts the engine hidden, waits for it to answer, then opens one app window. No console windows.
- Press **Stop-Maya.cmd** to stop the engine. Closing the window alone does not stop it.
- Folder icon: drop maya-app.ico beside MAKE-FOLDER-ICON.cmd and run it - the folder wears the M. (The icon file is added to this repo by hand; the push road used here carries text only.)

## Notes

- Text only on RDNA 2: the setup check turns vision off on this card.
- AMD's own Windows ROCm support list skips gfx1030. Everything above runs anyway; that is the point of the proof.
- Project Maya is MIT (mw00/project-maya). This repo is only the proof and the packaging.
