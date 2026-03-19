class NorthStarr < Formula
  desc "Your Development Partner — Friction-Free Development for AI coding tools"
  homepage "https://github.com/selcukyucel/north-starr"
  url "https://github.com/selcukyucel/north-starr/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "37d7065ee1a0e630c39b62e4416290cc572c7e634fd91c32b6bdf0271811cc7b"
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
