class Grub < Formula
  desc "GNU GRUB bootloader for i386-elf"
  homepage "https://www.gnu.org/software/grub/"
  url "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz"
  sha256 "b79ea44af91b93d17cd3fe80bdae6ed43770678a9a5ae192ccea803ebb657ee1"
  license "GPL-3.0-or-later"

  head do
    url "https://git.savannah.gnu.org/git/grub.git"
  end

  depends_on "nativeos/i386-elf-toolchain/i386-elf-binutils" => :build
  depends_on "nativeos/i386-elf-toolchain/i386-elf-gcc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "texinfo" => :build
  depends_on "help2man" => :build
  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "objconv" => :build

  def install
    ENV.prepend_path "PATH", Formula["nativeos/i386-elf-toolchain/i386-elf-gcc"].bin
    ENV.prepend_path "PATH", Formula["nativeos/i386-elf-toolchain/i386-elf-binutils"].bin

    # Use native compiler for build tools
    ENV["CC"] = "gcc"
    ENV["CFLAGS"] = "-Os -Wno-error=incompatible-pointer-types"

    mkdir "build" do
      if build.head?
        system "../bootstrap"
        system "../autogen.sh"
      end

      args = %W[
        --disable-werror
        --target=i386-elf
        --prefix=#{prefix}
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
        --program-prefix=i386-elf-
        TARGET_CC=i386-elf-gcc
        TARGET_OBJCOPY=i386-elf-objcopy
        TARGET_STRIP=i386-elf-strip
        TARGET_NM=i386-elf-nm
        TARGET_RANLIB=i386-elf-ranlib
      ]

      system "../configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/i386-elf-grub-file", "--is-x86-multiboot", "#{bin}/i386-elf-grub-mkimage"
  end
end