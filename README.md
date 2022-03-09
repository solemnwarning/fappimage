# FAppImage - Fat AppImage creator

## What is this?

This is a shell script that generates an architecture-independent "AppImage" by combining normal AppImages into a single file with a leading shell script that unpacks and executes the appropriate one for the architecture running it.

This tool was quickly put together as a proof-of-concept, it works, but has some shortcomings compared to distributing individual AppImage files:

- The resulting image combines the size of each architecture's AppImage with no further compression or consolidation.

- Each time the resulting program is run, the entire AppImage for the architecture is written out to a temporary file before executing, rather than mounting the internal image directly via FUSE as an AppImage normally does.

- There might be some software that relies on the AppImage format - for example to display metadata or icons from inside the AppImage, this would likely no longer work since the output does **not** conform to the AppImage specification.

**NOTE**: Since the tool is currently completely oblivious to any AppImage specifics, it can also be used to bundle up any executable program (statically linked or otherwise), or even scripts if you had some weird use case for that.

I'm not even sure this is a *good* idea for most use cases - it is just a proof-of-concept and most people using AppImage seem content with having one for each architecture. Something like [FatELF](https://icculus.org/fatelf/) could even become a part of AppImage in the future.

## Possible improvements

### Consolidation/compression of AppImages

Each AppImage contains a SquashFS filesystem of the entire application and any dependencies, the combined image size could be improved by (somehow) reversing the SquashFS compression and then compressing all of the images together with a separate compression tool.

Downsides of this would be as follows:

- Image creation and potentially startup would be slower.

- The unpacked AppImage would no longer by byte-identical with the input.

- The unpacked AppImage would take more disk space when running.
