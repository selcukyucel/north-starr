class NorthStarr < Formula
  desc "Your North Starr for Friction-Free Development — project bootstrapper for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "a923a1980245979ef6e6c7142124cd65f2d60a05e182f771abe57b9b04d5d005"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
