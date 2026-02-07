class NorthStarr < Formula
  desc "Your North Star for Friction-Free Development — Idea Flow workflow for Claude Code"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "71cc6ab1f91acf5bc9ff45c5ddd6f22fe1b6de36794a311d8ccb9acc1fdc4477"
  license "MIT"

  def install
    bin.install "bin/north-starr"
    (share/"north-starr").install "templates"
  end

  test do
    assert_match "north-starr v", shell_output("#{bin}/north-starr version")
  end
end
