class NorthStarr < Formula
  desc "Your North Star for Friction-Free Development — Idea Flow workflow for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e16e3ce091f6c9d40730c6f99b4d9732bd2d9a9c1269cc349e2a95647ab21505"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
