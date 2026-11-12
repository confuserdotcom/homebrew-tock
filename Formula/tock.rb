# Homebrew formula for tock. make formula renders it from this template
# (v5.4.0-rc2, 5ec33b06a9edbb601cf2a2d6dda30be0350c857463361f595f8b39c09c8e39c9); the release attaches the result. It goes in the tap
# repo homebrew-tock as Formula/tock.rb:
#   brew tap confuserdotcom/tock && brew trust confuserdotcom/tock
#   brew install tock && tock setup
class Tock < Formula
  desc "Time tracker that lives in your menu bar and notch"
  homepage "https://github.com/confuserdotcom/tock"
  url "https://github.com/confuserdotcom/tock/releases/download/v5.4.0-rc2/tock-v5.4.0-rc2-src.tar.gz"
  sha256 "5ec33b06a9edbb601cf2a2d6dda30be0350c857463361f595f8b39c09c8e39c9"
  license "MIT"

  depends_on "go" => :build

  def install
    # Go's caches inside the build folder: the build may not write to ~.
    ENV["GOPATH"] = buildpath/".gopath"
    ENV["GOCACHE"] = buildpath/".gocache"
    target = OS.mac? ? "dist-mac" : "dist-linux"
    system "make", target, "PREFIX=#{prefix}", "VERSION=v5.4.0-rc2"
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
    assert_match "tock v5.4.0-rc2", shell_output("#{bin}/tock version")
  end
end
