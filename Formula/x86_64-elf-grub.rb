class X8664ElfGrub < Formula
  desc "GNU GRUB bootloader for x86_64-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.06.tar.xz"
  sha256 "b79ea44af91b93d17cd3fe80bdae6ed43770678a9a5ae192ccea803ebb657ee1"
  license "GPL-3.0-or-later"

  depends_on "help2man" => :build
  depends_on "objconv" => :build
  depends_on "texinfo" => :build
  depends_on "x86_64-elf-binutils" => :build
  depends_on "x86_64-elf-gcc" => [:build, :test]
  depends_on "gettext"
  depends_on "xorriso"
  depends_on "xz"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  def install
    target = "x86_64-elf"
    ENV["CFLAGS"] = "-Os -Wno-error=incompatible-pointer-types"

    mkdir "build" do
      args = %W[
        --disable-werror
        --target=#{target}
        --prefix=#{prefix}/#{target}
        --libdir=#{lib}/#{target}
        --with-fontsdir=#{prefix}/#{target}/share/grub
        --with-platform=efi
        --program-prefix=#{target}-
      ]

      system "../configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    target = "x86_64-elf"
    (testpath/"boot.c").write <<~C
      __asm__(
        ".align 4\\n"
        ".long 0x1BADB002\\n"
        ".long 0x0\\n"
        ".long -(0x1BADB002 + 0x0)\\n"
      );
    C
    system Formula["#{target}-gcc"].bin/"#{target}-gcc", "-c", "-o", "boot", "boot.c"
    assert_match "0",
      shell_output("#{bin}/#{target}-grub-file --is-x86-multiboot boot; echo -n $?")
  end
end
