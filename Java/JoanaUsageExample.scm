(import "java.io.FileOutputStream")
(import "java.io.IOException")
(import "java.util.Collection")

(import "com.ibm.wala.ipa.cha.ClassHierarchyException")
(import "com.ibm.wala.util.CancelException")
(import "com.ibm.wala.util.NullProgressMonitor")
(import "com.ibm.wala.util.graph.GraphIntegrity.UnsoundGraphException")

(import "edu.kit.joana.api.IFCAnalysis")
(import "edu.kit.joana.api.lattice.BuiltinLattices")
(import "edu.kit.joana.api.sdg.SDGConfig")
(import "edu.kit.joana.api.sdg.SDGProgram")
(import "edu.kit.joana.api.sdg.SDGProgramPart")
(import "edu.kit.joana.ifc.sdg.core.SecurityNode")
(import "edu.kit.joana.ifc.sdg.core.violations.IViolation")
(import "edu.kit.joana.ifc.sdg.graph.SDGSerializer")
(import "edu.kit.joana.ifc.sdg.mhpoptimization.MHPType")
(import "edu.kit.joana.ifc.sdg.util.JavaMethodSignature")
(import "edu.kit.joana.util.Stubs")

(import "edu.kit.joana.wala.core.SDGBuilder.PointsToPrecision")
(import "edu.kit.joana.wala.core.SDGBuilder.ExceptionAnalysis")
(import "gnu.trove.map.TObjectIntMap")

(define (main args)
  (let* ((classPath   "./testprog/dist/TESTPROGRAM.jar")
         (entryMethod (JavaMethodSignature.mainMethodOfClass "com.peratonlabs.closure.testprog.TestProgram"))
         (config      (SDGConfig. classPath (.toBCString entryMethod) Stubs.JRE_15$))
        )
    (.setComputeInterferences config #t)
    (.setMhpType              config MHPType.PRECISE$)
    ;(.setPointsToPrecision    config PointsToPrecision.INSTANCE_BASED$)
    ;(.setExceptionAnalysis    config ExceptionAnalysis.INTERPROC$)
    (let ((program (SDGProgram.createSDGProgram config System.out$ (NullProgressMonitor.))))
      (SDGSerializer.toPDGFormat (.getSDG program) (FileOutputStream. "yourSDGFile.pdg"))
    )
  )
  (display "PDG Generated\n")
)
