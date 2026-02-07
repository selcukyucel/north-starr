class NorthStarr < Formula
  desc "Your North Starr for Friction-Free Development — project bootstrapper for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "8cdcd202fcadbfdc63c5260cbbfc6f38c42b26ccecafc43eaea58b3c780c2a35"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
