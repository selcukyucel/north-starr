class NorthStarr < Formula
  desc "Your Development Partner — Friction-Free Development for AI coding tools"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "5a5b7211a92845840cf63817f30b08519428a24aaac5d84628e273c83e644053"
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
