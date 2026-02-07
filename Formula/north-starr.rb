class NorthStarr < Formula
  desc "Your North Star for Friction-Free Development — Idea Flow workflow for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "3fc95157a9341485bbe3298423f7f1c7026627af7560e796aca32da57c3bd5a5"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
