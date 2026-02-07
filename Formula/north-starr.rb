class NorthStarr < Formula
  desc "Your North Starr for Friction-Free Development — project bootstrapper for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f3003eff09736df23fdd4c593d6a704d8ffaeef1d2f35af6830eb5351c8e544a"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
