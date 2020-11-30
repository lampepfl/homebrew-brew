class Dotty < Formula
  desc "Experimental Scala Compiler"
  homepage "http://dotty.epfl.ch/"
  url "https://github.com/lampepfl/dotty/releases/download/3.0.0-M2/scala3-3.0.0-M2.tar.gz"
  sha256 "ec71104112749d0efdf1127f9c2ce9722f732181518be7e983a9f754a698c281"
  # mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"

  bottle :unneeded

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
