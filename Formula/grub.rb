class Grub < Formula
  desc "GNU GRUB bootloader for i386-elf"
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
  depends_on "binutils" => :build
  depends_on "make" => :build
  depends_on "objconv" => :build

  def install
    mkdir "build" do
      if build.head?
        system "../bootstrap"
        system "../autogen.sh"
      end

      system "../configure",
             "--disable-werror",
             "--target=i686-elf",
             "--prefix=#{prefix}",
             "TARGET_CC=i686-elf-gcc",
             "TARGET_OBJCOPY=i686-elf-objcopy",
             "TARGET_STRIP=i686-elf-strip",
             "TARGET_NM=i686-elf-nm",
             "TARGET_RANLIB=i686-elf-ranlib"

      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/grub-file", "--is-x86-multiboot", "#{bin}/grub-mkimage"
  end
end
