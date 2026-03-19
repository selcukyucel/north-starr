class NorthStarr < Formula
  desc "Your Development Partner — Friction-Free Development for AI coding tools"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4a1fa8a7d39007ee9d28495250094637faf803e02275320e329c725f1fad509b"
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
