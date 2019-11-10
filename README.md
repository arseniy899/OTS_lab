# OTS_lab
## Requirements
You will need MatLab version of R2016b or newer.
## Setup env.
Start with copying any `Setup.m` file from `setups.ex` to the root of project. Change it correspondingly to your requirements.
If you don't know exact parameters, look at `src/SetParams.m`

## Starting up
Change your working directory in MatLab to root of repository and type 
```
>> Main
```
in 'Command Window'
Wait some time and you will see finish message.

## Viewing results
By default, output data is stored within `out` directory. To view them - type 
```
>> Draw('<Results Name>')
% or to draw Ideal Frame Error Rate for QAM-16 and QPKS
Draw('<Results Name>', 'drawIdealBER', true))
% or you can export images witg required extensions
Draw('<Results Name>', 'drawIdealBER', true, 'exportExts',{'png', 'svg'}) % it will export your figures to PNG and SVG
```
## Setup
You can edit your main Setup file with [these available parameters](params_all.txt)
## TODO
- [x] Convolutional encoding
- [x] LDPC
- [ ] RRC-filter
- [ ] Signal synchronisation with small error
- [ ] VCDMA
