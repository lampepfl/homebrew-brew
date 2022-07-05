class Dotty < Formula
  desc "Experimental Scala Compiler"
  homepage "http://dotty.epfl.ch/"
  url "https://github.com/lampepfl/dotty/releases/download/3.1.3/scala3-3.1.3.tar.gz"
  sha256 "9e1eefdcab77b2d2a9057b3d6f78301591e9c27513c92413f3c353a77093f2d7"
  # mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"

  depends_on "openjdk@8"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install "bin", "lib"
  end

  test do
    # test scalac and scala:
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) = {
          println(s"${2 + 2}")
        }
      }
    EOS

    shell_output("#{bin}/scalac #{file}")
    out = shell_output("#{bin}/scala Test").strip

    assert_equal "4", out

    # test scalad:
    Dir.mkdir "#{testpath}/site"
    index_out = testpath/"site"/"index.md"
    index_out.write <<~EOS
    Hello, world!
    =============
    EOS
    shell_output("#{bin}/scalad -siteroot #{testpath}/site -project Hello #{file}")
    index_file = File.open("#{testpath}/site/_site/index.html", "rb").read
    assert index_file.include? 'Hello, world!'
  end
end
