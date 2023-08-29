; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

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
@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 55, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 65, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double (double)* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 74, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 90, i8* null }], section "llvm.metadata"

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

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !12 {
  %1 = load double, double* @get_a.a, align 8, !dbg !43
  %2 = fadd double %1, 1.000000e+00, !dbg !43
  store double %2, double* @get_a.a, align 8, !dbg !43
  %3 = load double, double* @get_a.a, align 8, !dbg !44
  ret double %3, !dbg !45
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !46
  %2 = load double, double* @get_b.b, align 8, !dbg !47
  %3 = fadd double %2, %1, !dbg !47
  store double %3, double* @get_b.b, align 8, !dbg !47
  %4 = load double, double* @get_b.b, align 8, !dbg !48
  ret double %4, !dbg !49
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma(double noundef %0) #0 !dbg !50 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %2, align 8
  call void @llvm.dbg.declare(metadata double* %2, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata double* %3, metadata !55, metadata !DIExpression()), !dbg !56
  %6 = bitcast double* %3 to i8*, !dbg !57
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 79, i8* null), !dbg !57
  call void @llvm.dbg.declare(metadata double* %4, metadata !58, metadata !DIExpression()), !dbg !59
  %7 = bitcast double* %4 to i8*, !dbg !57
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 79, i8* null), !dbg !57
  call void @llvm.dbg.declare(metadata double* %5, metadata !60, metadata !DIExpression()), !dbg !61
  %8 = bitcast double* %5 to i8*, !dbg !57
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 79, i8* null), !dbg !57
  %9 = load double, double* %2, align 8, !dbg !62
  store double %9, double* %3, align 8, !dbg !63
  %10 = call double @get_b(), !dbg !64
  store double %10, double* %4, align 8, !dbg !65
  %11 = load double, double* %3, align 8, !dbg !66
  %12 = load double, double* %4, align 8, !dbg !67
  %13 = call double @calc_ewma(double noundef %11, double noundef %12), !dbg !68
  store double %13, double* %5, align 8, !dbg !69
  %14 = load double, double* %5, align 8, !dbg !70
  ret double %14, !dbg !71
}

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !72 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !76, metadata !DIExpression()), !dbg !77
  call void @llvm.dbg.declare(metadata double* %2, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata double* %3, metadata !80, metadata !DIExpression()), !dbg !81
  call void @llvm.dbg.declare(metadata i32* %4, metadata !82, metadata !DIExpression()), !dbg !84
  store i32 0, i32* %4, align 4, !dbg !84
  br label %5, !dbg !85

5:                                                ; preds = %15, %0
  %6 = load i32, i32* %4, align 4, !dbg !86
  %7 = icmp slt i32 %6, 10, !dbg !88
  br i1 %7, label %8, label %18, !dbg !89

8:                                                ; preds = %5
  %9 = call double @get_a(), !dbg !90
  store double %9, double* %1, align 8, !dbg !92
  %10 = load double, double* %1, align 8, !dbg !93
  store double %10, double* %2, align 8, !dbg !94
  %11 = load double, double* %2, align 8, !dbg !95
  %12 = call double @get_ewma(double noundef %11), !dbg !96
  store double %12, double* %3, align 8, !dbg !97
  %13 = load double, double* %3, align 8, !dbg !98
  %14 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), double noundef %13), !dbg !99
  br label %15, !dbg !100

15:                                               ; preds = %8
  %16 = load i32, i32* %4, align 4, !dbg !101
  %17 = add nsw i32 %16, 1, !dbg !101
  store i32 %17, i32* %4, align 4, !dbg !101
  br label %5, !dbg !102, !llvm.loop !103

18:                                               ; preds = %5
  ret i32 0, !dbg !106
}

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !107 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ewma_main(), !dbg !108
  ret i32 %2, !dbg !109
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

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
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{i32 7, !"PIC Level", i32 2}
!23 = !{i32 7, !"PIE Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 1}
!25 = !{i32 7, !"frame-pointer", i32 2}
!26 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!27 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 45, type: !6)
!28 = !DILocation(line: 45, column: 25, scope: !2)
!29 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 45, type: !6)
!30 = !DILocation(line: 45, column: 35, scope: !2)
!31 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 46, type: !32)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!33 = !DILocation(line: 46, column: 17, scope: !2)
!34 = !DILocation(line: 48, column: 16, scope: !2)
!35 = !DILocation(line: 48, column: 20, scope: !2)
!36 = !DILocation(line: 48, column: 18, scope: !2)
!37 = !DILocation(line: 48, column: 39, scope: !2)
!38 = !DILocation(line: 48, column: 37, scope: !2)
!39 = !DILocation(line: 48, column: 23, scope: !2)
!40 = !DILocation(line: 48, column: 5, scope: !2)
!41 = !DILocation(line: 49, column: 10, scope: !2)
!42 = !DILocation(line: 49, column: 3, scope: !2)
!43 = !DILocation(line: 58, column: 5, scope: !12)
!44 = !DILocation(line: 59, column: 10, scope: !12)
!45 = !DILocation(line: 59, column: 3, scope: !12)
!46 = !DILocation(line: 68, column: 8, scope: !18)
!47 = !DILocation(line: 68, column: 5, scope: !18)
!48 = !DILocation(line: 69, column: 10, scope: !18)
!49 = !DILocation(line: 69, column: 3, scope: !18)
!50 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 74, type: !51, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!51 = !DISubroutineType(types: !52)
!52 = !{!6, !6}
!53 = !DILocalVariable(name: "x", arg: 1, scope: !50, file: !3, line: 74, type: !6)
!54 = !DILocation(line: 74, column: 24, scope: !50)
!55 = !DILocalVariable(name: "x1", scope: !50, file: !3, line: 79, type: !6)
!56 = !DILocation(line: 79, column: 10, scope: !50)
!57 = !DILocation(line: 79, column: 3, scope: !50)
!58 = !DILocalVariable(name: "y1", scope: !50, file: !3, line: 79, type: !6)
!59 = !DILocation(line: 79, column: 14, scope: !50)
!60 = !DILocalVariable(name: "z1", scope: !50, file: !3, line: 79, type: !6)
!61 = !DILocation(line: 79, column: 18, scope: !50)
!62 = !DILocation(line: 82, column: 8, scope: !50)
!63 = !DILocation(line: 82, column: 6, scope: !50)
!64 = !DILocation(line: 83, column: 8, scope: !50)
!65 = !DILocation(line: 83, column: 6, scope: !50)
!66 = !DILocation(line: 84, column: 18, scope: !50)
!67 = !DILocation(line: 84, column: 22, scope: !50)
!68 = !DILocation(line: 84, column: 8, scope: !50)
!69 = !DILocation(line: 84, column: 6, scope: !50)
!70 = !DILocation(line: 85, column: 10, scope: !50)
!71 = !DILocation(line: 85, column: 3, scope: !50)
!72 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 90, type: !73, scopeLine: 90, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!73 = !DISubroutineType(types: !74)
!74 = !{!75}
!75 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!76 = !DILocalVariable(name: "x", scope: !72, file: !3, line: 93, type: !6)
!77 = !DILocation(line: 93, column: 10, scope: !72)
!78 = !DILocalVariable(name: "y", scope: !72, file: !3, line: 94, type: !6)
!79 = !DILocation(line: 94, column: 10, scope: !72)
!80 = !DILocalVariable(name: "ewma", scope: !72, file: !3, line: 95, type: !6)
!81 = !DILocation(line: 95, column: 10, scope: !72)
!82 = !DILocalVariable(name: "i", scope: !83, file: !3, line: 96, type: !75)
!83 = distinct !DILexicalBlock(scope: !72, file: !3, line: 96, column: 3)
!84 = !DILocation(line: 96, column: 12, scope: !83)
!85 = !DILocation(line: 96, column: 8, scope: !83)
!86 = !DILocation(line: 96, column: 17, scope: !87)
!87 = distinct !DILexicalBlock(scope: !83, file: !3, line: 96, column: 3)
!88 = !DILocation(line: 96, column: 19, scope: !87)
!89 = !DILocation(line: 96, column: 3, scope: !83)
!90 = !DILocation(line: 97, column: 9, scope: !91)
!91 = distinct !DILexicalBlock(scope: !87, file: !3, line: 96, column: 30)
!92 = !DILocation(line: 97, column: 7, scope: !91)
!93 = !DILocation(line: 98, column: 9, scope: !91)
!94 = !DILocation(line: 98, column: 7, scope: !91)
!95 = !DILocation(line: 99, column: 21, scope: !91)
!96 = !DILocation(line: 99, column: 12, scope: !91)
!97 = !DILocation(line: 99, column: 10, scope: !91)
!98 = !DILocation(line: 100, column: 20, scope: !91)
!99 = !DILocation(line: 100, column: 5, scope: !91)
!100 = !DILocation(line: 101, column: 3, scope: !91)
!101 = !DILocation(line: 96, column: 26, scope: !87)
!102 = !DILocation(line: 96, column: 3, scope: !87)
!103 = distinct !{!103, !89, !104, !105}
!104 = !DILocation(line: 101, column: 3, scope: !83)
!105 = !{!"llvm.loop.mustprogress"}
!106 = !DILocation(line: 102, column: 3, scope: !72)
!107 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 105, type: !73, scopeLine: 105, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!108 = !DILocation(line: 106, column: 10, scope: !107)
!109 = !DILocation(line: 106, column: 3, scope: !107)
