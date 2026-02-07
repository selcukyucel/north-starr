class NorthStarr < Formula
  desc "Your North Star for Friction-Free Development — Idea Flow workflow for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7fdfc35a759b6665fc684375034589267ec1d119a1af40a4f1711cdd4245f3c1"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
