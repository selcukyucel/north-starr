class NorthStarr < Formula
  desc "Your Development Partner — Friction-Free Development for AI coding tools"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "8376c162cbfd8958b58fc228b68ab149fad2bc910e482f8d3e2c50c9572c980d"
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
