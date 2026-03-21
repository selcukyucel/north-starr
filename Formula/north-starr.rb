class NorthStarr < Formula
  desc "Your Development Partner — Friction-Free Development for AI coding tools"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "7a2d25e2601736da37de1029d179e15eebca0fff5211a2334bcf91791b9db19f"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
    (share/"north-starr").install "skills"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
