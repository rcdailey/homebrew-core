class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.30/downloads/wayland-protocols-1.30.tar.xz"
  sha256 "3c1498fb65fd2b80b0376d7e87cf215e6ae957b2ccdba5da45a448718831bc60"
  license "MIT"

  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland-protocols[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ecf5c109f8c8bd7db6c874f90d39449d8a2c188ef680f6b6bedd162a4f498c0b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.11" => :build
  depends_on "wayland" => :build
  depends_on :linux

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
