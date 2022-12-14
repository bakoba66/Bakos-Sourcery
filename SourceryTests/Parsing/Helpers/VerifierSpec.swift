import Quick
import Nimble
#if SWIFT_PACKAGE
@testable import SourceryLib
#else
@testable import Sourcery
#endif
@testable import SourceryFramework
@testable import SourceryRuntime
import SourceryUtils

class VerifierSpec: QuickSpec {
    override func spec() {
        describe("Verifier") {
            it("allows empty strings") {
                expect(Verifier.canParse(content: "", path: Path("/"), generationMarker: Sourcery.generationMarker)).to(equal(Verifier.Result.approved))
            }

            it("rejects files generated by Sourcery") {
                let content = Sourcery.generationMarker + "\n something\n is\n there"

                expect(Verifier.canParse(content: content, path: Path("/"), generationMarker: Sourcery.generationMarker)).to(equal(Verifier.Result.isCodeGenerated))
            }

            it("rejects files generated by Sourcery when a force parse extension is defined but doesn't match file") {
                let content = Sourcery.generationMarker + "\n something\n is\n there"

                expect(Verifier.canParse(content: content, path: Path("/file.swift"), generationMarker: Sourcery.generationMarker, forceParse: ["toparse"])).to(equal(Verifier.Result.isCodeGenerated))
            }

            it("doesn't reject files generated by Sourcery but that we want to force the parsing for") {
                let content = Sourcery.generationMarker + "\n something\n is\n there"

                expect(Verifier.canParse(content: content, path: Path("/file.toparse.swift"), generationMarker: Sourcery.generationMarker, forceParse: ["toparse"])).to(equal(Verifier.Result.approved))
            }

            it("rejects file containing conflict marker") {
                let content = ["\n<<<<<\n", "\n>>>>>\n"]

                content.forEach { expect(Verifier.canParse(content: $0, path: Path("/"), generationMarker: Sourcery.generationMarker)).to(equal(Verifier.Result.containsConflictMarkers)) }
            }
        }
    }
}
