class NorthStarr < Formula
  desc "Your North Starr for Friction-Free Development — project bootstrapper for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "5f672bfbfefc6ab1aec88cf4be7c356381d10a9e66b03b04f1b061e7170520e7"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
