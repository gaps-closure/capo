; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !10
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !15
@.str.2 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [17 x i8] c"PURPLE_SHAREABLE\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@llvm.global.annotations = appending global [3 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 43 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 53 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double (double)* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 62 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !22, metadata !DIExpression()), !dbg !23
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata double* %5, metadata !26, metadata !DIExpression()), !dbg !28
  store double 2.500000e-01, double* %5, align 8, !dbg !28
  %6 = load double, double* %3, align 8, !dbg !29
  %7 = load double, double* %4, align 8, !dbg !30
  %8 = fadd double %6, %7, !dbg !31
  %9 = fmul double 2.500000e-01, %8, !dbg !32
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !33
  %11 = fmul double 7.500000e-01, %10, !dbg !34
  %12 = fadd double %9, %11, !dbg !35
  store double %12, double* @calc_ewma.c, align 8, !dbg !36
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !37
  ret double %13, !dbg !38
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !12 {
  %1 = load double, double* @get_a.a, align 8, !dbg !39
  %2 = fadd double %1, 1.000000e+00, !dbg !39
  store double %2, double* @get_a.a, align 8, !dbg !39
  %3 = load double, double* @get_a.a, align 8, !dbg !40
  ret double %3, !dbg !41
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !17 {
  %1 = load double, double* @get_b.b, align 8, !dbg !42
  %2 = load double, double* @get_b.b, align 8, !dbg !43
  %3 = fadd double %2, %1, !dbg !43
  store double %3, double* @get_b.b, align 8, !dbg !43
  %4 = load double, double* @get_b.b, align 8, !dbg !44
  ret double %4, !dbg !45
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma(double %0) #0 !dbg !46 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %2, align 8
  call void @llvm.dbg.declare(metadata double* %2, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata double* %3, metadata !51, metadata !DIExpression()), !dbg !52
  %6 = bitcast double* %3 to i8*, !dbg !53
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !53
  call void @llvm.dbg.declare(metadata double* %4, metadata !54, metadata !DIExpression()), !dbg !55
  %7 = bitcast double* %4 to i8*, !dbg !53
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !53
  call void @llvm.dbg.declare(metadata double* %5, metadata !56, metadata !DIExpression()), !dbg !57
  %8 = bitcast double* %5 to i8*, !dbg !53
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !53
  %9 = load double, double* %2, align 8, !dbg !58
  store double %9, double* %3, align 8, !dbg !59
  %10 = call double @get_b(), !dbg !60
  store double %10, double* %4, align 8, !dbg !61
  %11 = load double, double* %3, align 8, !dbg !62
  %12 = load double, double* %4, align 8, !dbg !63
  %13 = call double @calc_ewma(double %11, double %12), !dbg !64
  store double %13, double* %5, align 8, !dbg !65
  %14 = load double, double* %5, align 8, !dbg !66
  ret double %14, !dbg !67
}

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !68 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !72, metadata !DIExpression()), !dbg !73
  call void @llvm.dbg.declare(metadata double* %2, metadata !74, metadata !DIExpression()), !dbg !75
  call void @llvm.dbg.declare(metadata double* %3, metadata !76, metadata !DIExpression()), !dbg !77
  %5 = bitcast double* %3 to i8*, !dbg !78
  call void @llvm.var.annotation(i8* %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 81), !dbg !78
  call void @llvm.dbg.declare(metadata i32* %4, metadata !79, metadata !DIExpression()), !dbg !81
  store i32 0, i32* %4, align 4, !dbg !81
  br label %6, !dbg !82

6:                                                ; preds = %15, %0
  %7 = load i32, i32* %4, align 4, !dbg !83
  %8 = icmp slt i32 %7, 10, !dbg !85
  br i1 %8, label %9, label %18, !dbg !86

9:                                                ; preds = %6
  %10 = call double @get_a(), !dbg !87
  store double %10, double* %1, align 8, !dbg !89
  %11 = load double, double* %1, align 8, !dbg !90
  %12 = call double @get_ewma(double %11), !dbg !91
  store double %12, double* %3, align 8, !dbg !92
  %13 = load double, double* %3, align 8, !dbg !93
  %14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), double %13), !dbg !94
  br label %15, !dbg !95

15:                                               ; preds = %9
  %16 = load i32, i32* %4, align 4, !dbg !96
  %17 = add nsw i32 %16, 1, !dbg !96
  store i32 %17, i32* %4, align 4, !dbg !96
  br label %6, !dbg !97, !llvm.loop !98

18:                                               ; preds = %6
  ret i32 0, !dbg !100
}

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !101 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ewma_main(), !dbg !102
  ret i32 %2, !dbg !103
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 35, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 33, type: !4, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/example2-correct")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10, !15}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "a", scope: !12, file: !3, line: 43, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 40, type: !13, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "b", scope: !17, file: !3, line: 53, type: !6, isLocal: true, isDefinition: true)
!17 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 50, type: !13, scopeLine: 50, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!18 = !{i32 7, !"Dwarf Version", i32 4}
!19 = !{i32 2, !"Debug Info Version", i32 3}
!20 = !{i32 1, !"wchar_size", i32 4}
!21 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!22 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 33, type: !6)
!23 = !DILocation(line: 33, column: 25, scope: !2)
!24 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 33, type: !6)
!25 = !DILocation(line: 33, column: 35, scope: !2)
!26 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 34, type: !27)
!27 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!28 = !DILocation(line: 34, column: 17, scope: !2)
!29 = !DILocation(line: 36, column: 16, scope: !2)
!30 = !DILocation(line: 36, column: 20, scope: !2)
!31 = !DILocation(line: 36, column: 18, scope: !2)
!32 = !DILocation(line: 36, column: 13, scope: !2)
!33 = !DILocation(line: 36, column: 39, scope: !2)
!34 = !DILocation(line: 36, column: 37, scope: !2)
!35 = !DILocation(line: 36, column: 23, scope: !2)
!36 = !DILocation(line: 36, column: 5, scope: !2)
!37 = !DILocation(line: 37, column: 10, scope: !2)
!38 = !DILocation(line: 37, column: 3, scope: !2)
!39 = !DILocation(line: 46, column: 5, scope: !12)
!40 = !DILocation(line: 47, column: 10, scope: !12)
!41 = !DILocation(line: 47, column: 3, scope: !12)
!42 = !DILocation(line: 56, column: 8, scope: !17)
!43 = !DILocation(line: 56, column: 5, scope: !17)
!44 = !DILocation(line: 57, column: 10, scope: !17)
!45 = !DILocation(line: 57, column: 3, scope: !17)
!46 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 62, type: !47, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!47 = !DISubroutineType(types: !48)
!48 = !{!6, !6}
!49 = !DILocalVariable(name: "x", arg: 1, scope: !46, file: !3, line: 62, type: !6)
!50 = !DILocation(line: 62, column: 24, scope: !46)
!51 = !DILocalVariable(name: "x1", scope: !46, file: !3, line: 67, type: !6)
!52 = !DILocation(line: 67, column: 10, scope: !46)
!53 = !DILocation(line: 67, column: 3, scope: !46)
!54 = !DILocalVariable(name: "y1", scope: !46, file: !3, line: 67, type: !6)
!55 = !DILocation(line: 67, column: 14, scope: !46)
!56 = !DILocalVariable(name: "z1", scope: !46, file: !3, line: 67, type: !6)
!57 = !DILocation(line: 67, column: 18, scope: !46)
!58 = !DILocation(line: 70, column: 8, scope: !46)
!59 = !DILocation(line: 70, column: 6, scope: !46)
!60 = !DILocation(line: 71, column: 8, scope: !46)
!61 = !DILocation(line: 71, column: 6, scope: !46)
!62 = !DILocation(line: 72, column: 18, scope: !46)
!63 = !DILocation(line: 72, column: 22, scope: !46)
!64 = !DILocation(line: 72, column: 8, scope: !46)
!65 = !DILocation(line: 72, column: 6, scope: !46)
!66 = !DILocation(line: 73, column: 10, scope: !46)
!67 = !DILocation(line: 73, column: 3, scope: !46)
!68 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 76, type: !69, scopeLine: 76, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!69 = !DISubroutineType(types: !70)
!70 = !{!71}
!71 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!72 = !DILocalVariable(name: "x", scope: !68, file: !3, line: 77, type: !6)
!73 = !DILocation(line: 77, column: 10, scope: !68)
!74 = !DILocalVariable(name: "y", scope: !68, file: !3, line: 78, type: !6)
!75 = !DILocation(line: 78, column: 10, scope: !68)
!76 = !DILocalVariable(name: "ewma", scope: !68, file: !3, line: 81, type: !6)
!77 = !DILocation(line: 81, column: 10, scope: !68)
!78 = !DILocation(line: 81, column: 3, scope: !68)
!79 = !DILocalVariable(name: "i", scope: !80, file: !3, line: 84, type: !71)
!80 = distinct !DILexicalBlock(scope: !68, file: !3, line: 84, column: 3)
!81 = !DILocation(line: 84, column: 12, scope: !80)
!82 = !DILocation(line: 84, column: 8, scope: !80)
!83 = !DILocation(line: 84, column: 17, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 84, column: 3)
!85 = !DILocation(line: 84, column: 19, scope: !84)
!86 = !DILocation(line: 84, column: 3, scope: !80)
!87 = !DILocation(line: 85, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 84, column: 30)
!89 = !DILocation(line: 85, column: 7, scope: !88)
!90 = !DILocation(line: 86, column: 21, scope: !88)
!91 = !DILocation(line: 86, column: 12, scope: !88)
!92 = !DILocation(line: 86, column: 10, scope: !88)
!93 = !DILocation(line: 87, column: 20, scope: !88)
!94 = !DILocation(line: 87, column: 5, scope: !88)
!95 = !DILocation(line: 88, column: 3, scope: !88)
!96 = !DILocation(line: 84, column: 26, scope: !84)
!97 = !DILocation(line: 84, column: 3, scope: !84)
!98 = distinct !{!98, !86, !99}
!99 = !DILocation(line: 88, column: 3, scope: !80)
!100 = !DILocation(line: 89, column: 3, scope: !68)
!101 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 92, type: !69, scopeLine: 92, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!102 = !DILocation(line: 93, column: 10, scope: !101)
!103 = !DILocation(line: 93, column: 3, scope: !101)
