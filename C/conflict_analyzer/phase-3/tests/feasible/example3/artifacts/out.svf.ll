; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [5 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double (double, double)* @calc_ewma to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 50, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 62, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 72, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double ()* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 81, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 91, i8* null }], section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"EWMA_SHAREABLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str.3 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double noundef %0, double noundef %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !27, metadata !DIExpression()), !dbg !28
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !29, metadata !DIExpression()), !dbg !30
  call void @llvm.dbg.declare(metadata double* %5, metadata !31, metadata !DIExpression()), !dbg !33
  store double 2.500000e-01, double* %5, align 8, !dbg !33
  %6 = load double, double* %3, align 8, !dbg !34
  %7 = load double, double* %4, align 8, !dbg !35
  %8 = fadd double %6, %7, !dbg !36
  %9 = load double, double* @calc_ewma.c, align 8, !dbg !37
  %10 = fmul double 7.500000e-01, %9, !dbg !38
  %11 = call double @llvm.fmuladd.f64(double 2.500000e-01, double %8, double %10), !dbg !39
  store double %11, double* @calc_ewma.c, align 8, !dbg !40
  %12 = load double, double* @calc_ewma.c, align 8, !dbg !41
  ret double %12, !dbg !42
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma() #0 !dbg !43 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  call void @llvm.dbg.declare(metadata double* %1, metadata !44, metadata !DIExpression()), !dbg !45
  %3 = call double @get_a(), !dbg !46
  store double %3, double* %1, align 8, !dbg !45
  call void @llvm.dbg.declare(metadata double* %2, metadata !47, metadata !DIExpression()), !dbg !48
  %4 = call double @get_b(), !dbg !49
  store double %4, double* %2, align 8, !dbg !48
  %5 = load double, double* %1, align 8, !dbg !50
  %6 = load double, double* %2, align 8, !dbg !51
  %7 = call double @calc_ewma(double noundef %5, double noundef %6), !dbg !52
  ret double %7, !dbg !53
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !54 {
  %1 = alloca double, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !58, metadata !DIExpression()), !dbg !59
  call void @llvm.dbg.declare(metadata i32* %2, metadata !60, metadata !DIExpression()), !dbg !62
  store i32 0, i32* %2, align 4, !dbg !62
  br label %3, !dbg !63

3:                                                ; preds = %11, %0
  %4 = load i32, i32* %2, align 4, !dbg !64
  %5 = icmp slt i32 %4, 10, !dbg !66
  br i1 %5, label %6, label %14, !dbg !67

6:                                                ; preds = %3
  %7 = call double @get_ewma(), !dbg !68
  store double %7, double* %1, align 8, !dbg !70
  %8 = load double, double* %1, align 8, !dbg !71
  %9 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.4, i64 0, i64 0
  %10 = call i32 (i8*, ...) @printf(i8* noundef %9, double noundef %8), !dbg !72
  br label %11, !dbg !73

11:                                               ; preds = %6
  %12 = load i32, i32* %2, align 4, !dbg !74
  %13 = add nsw i32 %12, 1, !dbg !74
  store i32 %13, i32* %2, align 4, !dbg !74
  br label %3, !dbg !75, !llvm.loop !76

14:                                               ; preds = %3
  ret i32 0, !dbg !79
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !12 {
  %1 = load double, double* @get_a.a, align 8, !dbg !80
  %2 = fadd double %1, 1.000000e+00, !dbg !80
  store double %2, double* @get_a.a, align 8, !dbg !80
  %3 = load double, double* @get_a.a, align 8, !dbg !81
  ret double %3, !dbg !82
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !83
  %2 = load double, double* @get_b.b, align 8, !dbg !84
  %3 = fadd double %2, %1, !dbg !84
  store double %3, double* @get_b.b, align 8, !dbg !84
  %4 = load double, double* @get_b.b, align 8, !dbg !85
  ret double %4, !dbg !86
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !87 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ewma_main(), !dbg !88
  ret i32 %2, !dbg !89
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.ident = !{!19}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 54, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 50, type: !4, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!3 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "e78274ba498e8bf8f4a06b5cdb246bb2")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "e78274ba498e8bf8f4a06b5cdb246bb2")
!9 = !{!0, !10, !16}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "a", scope: !12, file: !3, line: 62, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 59, type: !13, scopeLine: 59, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !{}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 72, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 69, type: !13, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!19 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 7, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 50, type: !6)
!28 = !DILocation(line: 50, column: 25, scope: !2)
!29 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 50, type: !6)
!30 = !DILocation(line: 50, column: 35, scope: !2)
!31 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 53, type: !32)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!33 = !DILocation(line: 53, column: 17, scope: !2)
!34 = !DILocation(line: 55, column: 16, scope: !2)
!35 = !DILocation(line: 55, column: 20, scope: !2)
!36 = !DILocation(line: 55, column: 18, scope: !2)
!37 = !DILocation(line: 55, column: 39, scope: !2)
!38 = !DILocation(line: 55, column: 37, scope: !2)
!39 = !DILocation(line: 55, column: 23, scope: !2)
!40 = !DILocation(line: 55, column: 5, scope: !2)
!41 = !DILocation(line: 56, column: 10, scope: !2)
!42 = !DILocation(line: 56, column: 3, scope: !2)
!43 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 81, type: !13, scopeLine: 81, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!44 = !DILocalVariable(name: "x", scope: !43, file: !3, line: 84, type: !6)
!45 = !DILocation(line: 84, column: 10, scope: !43)
!46 = !DILocation(line: 84, column: 14, scope: !43)
!47 = !DILocalVariable(name: "y", scope: !43, file: !3, line: 85, type: !6)
!48 = !DILocation(line: 85, column: 10, scope: !43)
!49 = !DILocation(line: 85, column: 14, scope: !43)
!50 = !DILocation(line: 86, column: 20, scope: !43)
!51 = !DILocation(line: 86, column: 23, scope: !43)
!52 = !DILocation(line: 86, column: 10, scope: !43)
!53 = !DILocation(line: 86, column: 3, scope: !43)
!54 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 91, type: !55, scopeLine: 91, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!55 = !DISubroutineType(types: !56)
!56 = !{!57}
!57 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!58 = !DILocalVariable(name: "ewma", scope: !54, file: !3, line: 94, type: !6)
!59 = !DILocation(line: 94, column: 10, scope: !54)
!60 = !DILocalVariable(name: "i", scope: !61, file: !3, line: 95, type: !57)
!61 = distinct !DILexicalBlock(scope: !54, file: !3, line: 95, column: 3)
!62 = !DILocation(line: 95, column: 12, scope: !61)
!63 = !DILocation(line: 95, column: 8, scope: !61)
!64 = !DILocation(line: 95, column: 17, scope: !65)
!65 = distinct !DILexicalBlock(scope: !61, file: !3, line: 95, column: 3)
!66 = !DILocation(line: 95, column: 19, scope: !65)
!67 = !DILocation(line: 95, column: 3, scope: !61)
!68 = !DILocation(line: 96, column: 12, scope: !69)
!69 = distinct !DILexicalBlock(scope: !65, file: !3, line: 95, column: 30)
!70 = !DILocation(line: 96, column: 10, scope: !69)
!71 = !DILocation(line: 97, column: 20, scope: !69)
!72 = !DILocation(line: 97, column: 5, scope: !69)
!73 = !DILocation(line: 98, column: 3, scope: !69)
!74 = !DILocation(line: 95, column: 26, scope: !65)
!75 = !DILocation(line: 95, column: 3, scope: !65)
!76 = distinct !{!76, !67, !77, !78}
!77 = !DILocation(line: 98, column: 3, scope: !61)
!78 = !{!"llvm.loop.mustprogress"}
!79 = !DILocation(line: 99, column: 3, scope: !54)
!80 = !DILocation(line: 65, column: 5, scope: !12)
!81 = !DILocation(line: 66, column: 10, scope: !12)
!82 = !DILocation(line: 66, column: 3, scope: !12)
!83 = !DILocation(line: 75, column: 8, scope: !18)
!84 = !DILocation(line: 75, column: 5, scope: !18)
!85 = !DILocation(line: 76, column: 10, scope: !18)
!86 = !DILocation(line: 76, column: 3, scope: !18)
!87 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 102, type: !55, scopeLine: 102, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!88 = !DILocation(line: 103, column: 10, scope: !87)
!89 = !DILocation(line: 103, column: 3, scope: !87)
