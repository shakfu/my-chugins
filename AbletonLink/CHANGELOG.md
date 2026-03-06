# AbletonLink Chugin Changelog

## [Unreleased]

### Added

- `updateInterval` setter and getter: configurable number of samples between Link timeline polls. Default is 64 samples (~1.45ms at 44.1kHz), which significantly reduces CPU usage compared to per-sample polling while maintaining sub-perceptual timing precision. Set to 1 to restore original per-sample behavior.

### Fixed

- High CPU usage and audio dropouts caused by acquiring the Link timeline on every single sample tick. The timeline is now polled every `updateInterval` samples (default 64), with cached values held between updates.
- Integer division in step boundary detection (`quantum / 2` changed to `quantum / 2.0`).
