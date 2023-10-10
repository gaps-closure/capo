; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 55, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 65, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double (double)* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 74, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 90, i8* null }], section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !10
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str.2 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [17 x i8] c"PURPLE_SHAREABLE\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma(double noundef %0) #0 !dbg !27 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %2, align 8
  call void @llvm.dbg.declare(metadata double* %2, metadata !30, metadata !DIExpression()), !dbg !31
  call void @llvm.dbg.declare(metadata double* %3, metadata !32, metadata !DIExpression()), !dbg !33
  %6 = bitcast double* %3 to i8*, !dbg !34
  %7 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.3, i32 0, i32 0
  %8 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %6, i8* %7, i8* %8, i32 79, i8* null), !dbg !34
  call void @llvm.dbg.declare(metadata double* %4, metadata !35, metadata !DIExpression()), !dbg !36
  %9 = bitcast double* %4 to i8*, !dbg !34
  %10 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.3, i32 0, i32 0
  %11 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %9, i8* %10, i8* %11, i32 79, i8* null), !dbg !34
  call void @llvm.dbg.declare(metadata double* %5, metadata !37, metadata !DIExpression()), !dbg !38
  %12 = bitcast double* %5 to i8*, !dbg !34
  %13 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.3, i32 0, i32 0
  %14 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %12, i8* %13, i8* %14, i32 79, i8* null), !dbg !34
  %15 = load double, double* %2, align 8, !dbg !39
  store double %15, double* %3, align 8, !dbg !40
  %16 = call double @get_b(), !dbg !41
  store double %16, double* %4, align 8, !dbg !42
  %17 = load double, double* %3, align 8, !dbg !43
  %18 = load double, double* %4, align 8, !dbg !44
  %19 = call double @calc_ewma(double noundef %17, double noundef %18), !dbg !45
  store double %19, double* %5, align 8, !dbg !46
  %20 = load double, double* %5, align 8, !dbg !47
  ret double %20, !dbg !48
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !49 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata double* %2, metadata !55, metadata !DIExpression()), !dbg !56
  call void @llvm.dbg.declare(metadata double* %3, metadata !57, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.declare(metadata i32* %4, metadata !59, metadata !DIExpression()), !dbg !61
  store i32 0, i32* %4, align 4, !dbg !61
  br label %5, !dbg !62

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %4, align 4, !dbg !63
  %7 = icmp slt i32 %6, 10, !dbg !65
  br i1 %7, label %8, label %19, !dbg !66

8:                                                ; preds = %5
  %9 = call double @get_a(), !dbg !67
  store double %9, double* %1, align 8, !dbg !69
  %10 = load double, double* %1, align 8, !dbg !70
  store double %10, double* %2, align 8, !dbg !71
  %11 = load double, double* %2, align 8, !dbg !72
  %12 = call double @get_ewma(double noundef %11), !dbg !73
  store double %12, double* %3, align 8, !dbg !74
  %13 = load double, double* %3, align 8, !dbg !75
  %14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.5, i64 0, i64 0
  %15 = call i32 (i8*, ...) @printf(i8* noundef %14, double noundef %13), !dbg !76
  br label %16, !dbg !77

16:                                               ; preds = %8
  %17 = load i32, i32* %4, align 4, !dbg !78
  %18 = add nsw i32 %17, 1, !dbg !78
  store i32 %18, i32* %4, align 4, !dbg !78
  br label %5, !dbg !79, !llvm.loop !80

19:                                               ; preds = %5
  ret i32 0, !dbg !83
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !12 {
  %1 = load double, double* @get_a.a, align 8, !dbg !84
  %2 = fadd double %1, 1.000000e+00, !dbg !84
  store double %2, double* @get_a.a, align 8, !dbg !84
  %3 = load double, double* @get_a.a, align 8, !dbg !85
  ret double %3, !dbg !86
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !87
  %2 = load double, double* @get_b.b, align 8, !dbg !88
  %3 = fadd double %2, %1, !dbg !88
  store double %3, double* @get_b.b, align 8, !dbg !88
  %4 = load double, double* @get_b.b, align 8, !dbg !89
  ret double %4, !dbg !90
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double noundef %0, double noundef %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !91, metadata !DIExpression()), !dbg !92
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !93, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.declare(metadata double* %5, metadata !95, metadata !DIExpression()), !dbg !97
  store double 2.500000e-01, double* %5, align 8, !dbg !97
  %6 = load double, double* %3, align 8, !dbg !98
  %7 = load double, double* %4, align 8, !dbg !99
  %8 = fadd double %6, %7, !dbg !100
  %9 = load double, double* @calc_ewma.c, align 8, !dbg !101
  %10 = fmul double 7.500000e-01, %9, !dbg !102
  %11 = call double @llvm.fmuladd.f64(double 2.500000e-01, double %8, double %10), !dbg !103
  store double %11, double* @calc_ewma.c, align 8, !dbg !104
  %12 = load double, double* @calc_ewma.c, align 8, !dbg !105
  ret double %12, !dbg !106
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !107 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ewma_main(), !dbg !108
  ret i32 %2, !dbg !109
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblememonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!7}
!llvm.ident = !{!19}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 47, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 45, type: !4, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!3 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "f682946c7268aca9f39a4a7333cbc554")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "f682946c7268aca9f39a4a7333cbc554")
!9 = !{!0, !10, !16}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "a", scope: !12, file: !3, line: 55, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 52, type: !13, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !{}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 65, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 62, type: !13, scopeLine: 62, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!19 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 7, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 74, type: !28, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!28 = !DISubroutineType(types: !29)
!29 = !{!6, !6}
!30 = !DILocalVariable(name: "x", arg: 1, scope: !27, file: !3, line: 74, type: !6)
!31 = !DILocation(line: 74, column: 24, scope: !27)
!32 = !DILocalVariable(name: "x1", scope: !27, file: !3, line: 79, type: !6)
!33 = !DILocation(line: 79, column: 10, scope: !27)
!34 = !DILocation(line: 79, column: 3, scope: !27)
!35 = !DILocalVariable(name: "y1", scope: !27, file: !3, line: 79, type: !6)
!36 = !DILocation(line: 79, column: 14, scope: !27)
!37 = !DILocalVariable(name: "z1", scope: !27, file: !3, line: 79, type: !6)
!38 = !DILocation(line: 79, column: 18, scope: !27)
!39 = !DILocation(line: 82, column: 8, scope: !27)
!40 = !DILocation(line: 82, column: 6, scope: !27)
!41 = !DILocation(line: 83, column: 8, scope: !27)
!42 = !DILocation(line: 83, column: 6, scope: !27)
!43 = !DILocation(line: 84, column: 18, scope: !27)
!44 = !DILocation(line: 84, column: 22, scope: !27)
!45 = !DILocation(line: 84, column: 8, scope: !27)
!46 = !DILocation(line: 84, column: 6, scope: !27)
!47 = !DILocation(line: 85, column: 10, scope: !27)
!48 = !DILocation(line: 85, column: 3, scope: !27)
!49 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 90, type: !50, scopeLine: 90, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!50 = !DISubroutineType(types: !51)
!51 = !{!52}
!52 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!53 = !DILocalVariable(name: "x", scope: !49, file: !3, line: 93, type: !6)
!54 = !DILocation(line: 93, column: 10, scope: !49)
!55 = !DILocalVariable(name: "y", scope: !49, file: !3, line: 94, type: !6)
!56 = !DILocation(line: 94, column: 10, scope: !49)
!57 = !DILocalVariable(name: "ewma", scope: !49, file: !3, line: 95, type: !6)
!58 = !DILocation(line: 95, column: 10, scope: !49)
!59 = !DILocalVariable(name: "i", scope: !60, file: !3, line: 96, type: !52)
!60 = distinct !DILexicalBlock(scope: !49, file: !3, line: 96, column: 3)
!61 = !DILocation(line: 96, column: 12, scope: !60)
!62 = !DILocation(line: 96, column: 8, scope: !60)
!63 = !DILocation(line: 96, column: 17, scope: !64)
!64 = distinct !DILexicalBlock(scope: !60, file: !3, line: 96, column: 3)
!65 = !DILocation(line: 96, column: 19, scope: !64)
!66 = !DILocation(line: 96, column: 3, scope: !60)
!67 = !DILocation(line: 97, column: 9, scope: !68)
!68 = distinct !DILexicalBlock(scope: !64, file: !3, line: 96, column: 30)
!69 = !DILocation(line: 97, column: 7, scope: !68)
!70 = !DILocation(line: 98, column: 9, scope: !68)
!71 = !DILocation(line: 98, column: 7, scope: !68)
!72 = !DILocation(line: 99, column: 21, scope: !68)
!73 = !DILocation(line: 99, column: 12, scope: !68)
!74 = !DILocation(line: 99, column: 10, scope: !68)
!75 = !DILocation(line: 100, column: 20, scope: !68)
!76 = !DILocation(line: 100, column: 5, scope: !68)
!77 = !DILocation(line: 101, column: 3, scope: !68)
!78 = !DILocation(line: 96, column: 26, scope: !64)
!79 = !DILocation(line: 96, column: 3, scope: !64)
!80 = distinct !{!80, !66, !81, !82}
!81 = !DILocation(line: 101, column: 3, scope: !60)
!82 = !{!"llvm.loop.mustprogress"}
!83 = !DILocation(line: 102, column: 3, scope: !49)
!84 = !DILocation(line: 58, column: 5, scope: !12)
!85 = !DILocation(line: 59, column: 10, scope: !12)
!86 = !DILocation(line: 59, column: 3, scope: !12)
!87 = !DILocation(line: 68, column: 8, scope: !18)
!88 = !DILocation(line: 68, column: 5, scope: !18)
!89 = !DILocation(line: 69, column: 10, scope: !18)
!90 = !DILocation(line: 69, column: 3, scope: !18)
!91 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 45, type: !6)
!92 = !DILocation(line: 45, column: 25, scope: !2)
!93 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 45, type: !6)
!94 = !DILocation(line: 45, column: 35, scope: !2)
!95 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 46, type: !96)
!96 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!97 = !DILocation(line: 46, column: 17, scope: !2)
!98 = !DILocation(line: 48, column: 16, scope: !2)
!99 = !DILocation(line: 48, column: 20, scope: !2)
!100 = !DILocation(line: 48, column: 18, scope: !2)
!101 = !DILocation(line: 48, column: 39, scope: !2)
!102 = !DILocation(line: 48, column: 37, scope: !2)
!103 = !DILocation(line: 48, column: 23, scope: !2)
!104 = !DILocation(line: 48, column: 5, scope: !2)
!105 = !DILocation(line: 49, column: 10, scope: !2)
!106 = !DILocation(line: 49, column: 3, scope: !2)
!107 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 105, type: !50, scopeLine: 105, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!108 = !DILocation(line: 106, column: 10, scope: !107)
!109 = !DILocation(line: 106, column: 3, scope: !107)
