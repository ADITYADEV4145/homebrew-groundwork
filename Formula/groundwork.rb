class Groundwork < Formula
  desc "Live, local codebase map for coding agents"
  homepage "https://github.com/ADITYADEV4145/GroundWork"
  url "https://registry.npmjs.org/groundwork-agent/-/groundwork-agent-0.0.1.tgz"
  sha256 "9f2fdbd933f3be9e1425afc37b230921ce62fcf18e89f37bb5092ca1e28c8e01"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    platform = OS.mac? ? "darwin" : "linux"
    node_modules = libexec/"lib/node_modules/groundwork-agent/node_modules"
    node_modules.glob("**/prebuilds/*").each do |prebuild|
      rm_r prebuild if prebuild.basename.to_s != "#{platform}-#{arch}"
    end
    (node_modules/"onnxruntime-node/bin").glob("napi-v*/*/*").each do |prebuild|
      rm_r prebuild if prebuild.parent.basename.to_s != platform || prebuild.basename.to_s != arch
    end
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gw --version").strip
  end
end
