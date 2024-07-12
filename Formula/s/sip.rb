class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6e/52/36987b182711104d5e9f8831dd989085b1241fc627829c36ddf81640c372/sip-6.8.6.tar.gz"
  sha256 "7fc959e48e6ec5d5af8bd026f69f5e24d08b3cb8abb342176f5ab8030cc07d7a"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4efa47c9d2d33bf5897fe994aef25905611c59d3d80db8f8591aadfee43bdb4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4efa47c9d2d33bf5897fe994aef25905611c59d3d80db8f8591aadfee43bdb4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4efa47c9d2d33bf5897fe994aef25905611c59d3d80db8f8591aadfee43bdb4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0838e9d57c425db439eef5bde3707c0b7ddc09e4f222a6e8f0f3e5a519b0339"
    sha256 cellar: :any_skip_relocation, ventura:        "f0838e9d57c425db439eef5bde3707c0b7ddc09e4f222a6e8f0f3e5a519b0339"
    sha256 cellar: :any_skip_relocation, monterey:       "f0838e9d57c425db439eef5bde3707c0b7ddc09e4f222a6e8f0f3e5a519b0339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c3e5fffd8754227f3c8938e0cebcc6b30d17d80a99abb22fa909055b851463"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    EOS

    (testpath/"fib.sip").write <<~EOS
      // Define the SIP wrapper to the (theoretical) fib library.

      %Module(name=fib, language="C")

      int fib_n(int n);
      %MethodCode
          if (a0 <= 0)
          {
              sipRes = 0;
          }
          else
          {
              int a = 0, b = 1, c, i;

              for (i = 2; i <= a0; i++)
              {
                  c = a + b;
                  a = b;
                  b = c;
              }

              sipRes = b;
          }
      %End
    EOS

    system "#{bin}/sip-install", "--target-dir", "."
  end
end
