# Homebrew formula for tock. make formula renders it from this template
# (v5.5.1, 7d6c90dd872b1383ce8b49258d9d6d2d3ea5dc02869642de668fbdd99e8e5a9c); the release attaches the result. It goes in the tap
# repo homebrew-tock as Formula/tock.rb:
#   brew tap confuserdotcom/tock && brew trust confuserdotcom/tock
#   brew install tock && tock setup
class Tock < Formula
  desc "Time tracker that lives in your menu bar and notch"
  homepage "https://github.com/confuserdotcom/tock"
  url "https://github.com/confuserdotcom/tock/releases/download/v5.5.1/tock-v5.5.1-src.tar.gz"
  sha256 "7d6c90dd872b1383ce8b49258d9d6d2d3ea5dc02869642de668fbdd99e8e5a9c"
  license "MIT"

  depends_on "go" => :build

  def install
    # Go's caches inside the build folder: the build may not write to ~.
    ENV["GOPATH"] = buildpath/".gopath"
    ENV["GOCACHE"] = buildpath/".gocache"
    target = OS.mac? ? "dist-mac" : "dist-linux"
    system "make", target, "PREFIX=#{prefix}", "VERSION=v5.5.1"
  end

  def caveats
    <<~EOS
      Finish installing with:
        tock setup
      Run it again after each brew upgrade tock: it puts the new version in place.
      On macOS it makes a code-signing certificate that stays on this Mac (macOS
      asks for your password once), so Accessibility and Screen Recording stay
      granted across updates.
    EOS
  end

  test do
    assert_match "tock v5.5.1", shell_output("#{bin}/tock version")
  end
end
