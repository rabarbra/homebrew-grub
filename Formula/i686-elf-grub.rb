class I686ElfGrub < Formula
  desc "GNU GRUB bootloader for i686-elf"
  homepage "https://www.gnu.org/software/grub/"
  url "https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz"
  sha256 "b79ea44af91b93d17cd3fe80bdae6ed43770678a9a5ae192ccea803ebb657ee1"
  license "GPL-3.0-or-later"

  head do
    url "https://git.savannah.gnu.org/git/grub.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "texinfo" => :build
  depends_on "help2man" => :build
  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "objconv" => :build
  depends_on "i686-elf-gcc" => :build
  depends_on "i686-elf-binutils" => :build

  def install
    target = "i686-elf"
    ENV["CC"] = "gcc"
    ENV["CFLAGS"] = "-Os -Wno-error=incompatible-pointer-types"

    mkdir "build" do
      if build.head?
        system "../bootstrap"
        system "../autogen.sh"
      end

      args = %W[
        --disable-werror
        --target=#{target}
        --prefix=#{prefix}
        --libdir=#{lib}/#{target}
        --infodir=#{info}/#{target}
        --sysconfdir=#{etc}/#{target}
        --datarootdir=#{share}/#{target}
        --disable-nls
        --disable-efiemu 
        --disable-device-mapper
        --disable-grub-mount
        --disable-lua
        --disable-liblzma
        --disable-libzfs
        --disable-grub-mkfont
        --disable-grub-themes
        --with-platform=pc
        --program-prefix=#{target}-
        TARGET_CC=#{target}-gcc
        TARGET_OBJCOPY=#{target}-objcopy
        TARGET_STRIP=#{target}-strip
        TARGET_NM=#{target}-nm
        TARGET_RANLIB=#{target}-ranlib
      ]

      system "../configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    target = "i686-elf"
    system "#{bin}/#{target}-grub-file", "--is-x86-multiboot", "#{bin}/#{target}-grub-mkimage"
  end
end
