; ModuleID = 'temp.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.global.annotations = appending global [3 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 44 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 56 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double (double)* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 67 }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !15
@.str.2 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [17 x i8] c"PURPLE_SHAREABLE\00", section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !10
@.str.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma(double %0) #0 !dbg !22 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %2, align 8
  call void @llvm.dbg.declare(metadata double* %2, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %3, metadata !27, metadata !DIExpression()), !dbg !28
  %6 = bitcast double* %3 to i8*, !dbg !29
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 74), !dbg !29
  call void @llvm.dbg.declare(metadata double* %4, metadata !30, metadata !DIExpression()), !dbg !31
  %7 = bitcast double* %4 to i8*, !dbg !29
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 74), !dbg !29
  call void @llvm.dbg.declare(metadata double* %5, metadata !32, metadata !DIExpression()), !dbg !33
  %8 = bitcast double* %5 to i8*, !dbg !29
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 74), !dbg !29
  %9 = load double, double* %2, align 8, !dbg !34
  store double %9, double* %3, align 8, !dbg !35
  %10 = call double @get_b(), !dbg !36
  store double %10, double* %4, align 8, !dbg !37
  %11 = load double, double* %3, align 8, !dbg !38
  %12 = load double, double* %4, align 8, !dbg !39
  %13 = call double @calc_ewma(double %11, double %12), !dbg !40
  store double %13, double* %5, align 8, !dbg !41
  %14 = load double, double* %5, align 8, !dbg !42
  ret double %14, !dbg !43
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !17 {
  %1 = load double, double* @get_b.b, align 8, !dbg !44
  %2 = load double, double* @get_b.b, align 8, !dbg !45
  %3 = fadd double %2, %1, !dbg !45
  store double %3, double* @get_b.b, align 8, !dbg !45
  %4 = load double, double* @get_b.b, align 8, !dbg !46
  ret double %4, !dbg !47
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !12 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !48, metadata !DIExpression()), !dbg !49
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !50, metadata !DIExpression()), !dbg !51
  call void @llvm.dbg.declare(metadata double* %5, metadata !52, metadata !DIExpression()), !dbg !54
  store double 2.500000e-01, double* %5, align 8, !dbg !54
  %6 = load double, double* %3, align 8, !dbg !55
  %7 = load double, double* %4, align 8, !dbg !56
  %8 = fadd double %6, %7, !dbg !57
  %9 = fmul double 2.500000e-01, %8, !dbg !58
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !59
  %11 = fmul double 7.500000e-01, %10, !dbg !60
  %12 = fadd double %9, %11, !dbg !61
  store double %12, double* @calc_ewma.c, align 8, !dbg !62
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !63
  ret double %13, !dbg !64
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
  %1 = load double, double* @get_a.a, align 8, !dbg !65
  %2 = fadd double %1, 1.000000e+00, !dbg !65
  store double %2, double* @get_a.a, align 8, !dbg !65
  %3 = load double, double* @get_a.a, align 8, !dbg !66
  ret double %3, !dbg !67
}

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
  call void @llvm.var.annotation(i8* %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 90), !dbg !78
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
!llvm.ident = !{!18}
!llvm.module.flags = !{!19, !20, !21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 44, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 40, type: !4, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/rbrotzman/gaps/build/src/capo/formal/ontology")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!10, !0, !15}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "c", scope: !12, file: !3, line: 35, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 33, type: !13, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!13 = !DISubroutineType(types: !14)
!14 = !{!6, !6, !6}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "b", scope: !17, file: !3, line: 56, type: !6, isLocal: true, isDefinition: true)
!17 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 52, type: !4, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!18 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!19 = !{i32 7, !"Dwarf Version", i32 4}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 67, type: !23, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!23 = !DISubroutineType(types: !24)
!24 = !{!6, !6}
!25 = !DILocalVariable(name: "x", arg: 1, scope: !22, file: !3, line: 67, type: !6)
!26 = !DILocation(line: 67, column: 24, scope: !22)
!27 = !DILocalVariable(name: "x1", scope: !22, file: !3, line: 74, type: !6)
!28 = !DILocation(line: 74, column: 10, scope: !22)
!29 = !DILocation(line: 74, column: 3, scope: !22)
!30 = !DILocalVariable(name: "y1", scope: !22, file: !3, line: 74, type: !6)
!31 = !DILocation(line: 74, column: 14, scope: !22)
!32 = !DILocalVariable(name: "z1", scope: !22, file: !3, line: 74, type: !6)
!33 = !DILocation(line: 74, column: 18, scope: !22)
!34 = !DILocation(line: 78, column: 8, scope: !22)
!35 = !DILocation(line: 78, column: 6, scope: !22)
!36 = !DILocation(line: 79, column: 8, scope: !22)
!37 = !DILocation(line: 79, column: 6, scope: !22)
!38 = !DILocation(line: 80, column: 18, scope: !22)
!39 = !DILocation(line: 80, column: 22, scope: !22)
!40 = !DILocation(line: 80, column: 8, scope: !22)
!41 = !DILocation(line: 80, column: 6, scope: !22)
!42 = !DILocation(line: 81, column: 10, scope: !22)
!43 = !DILocation(line: 81, column: 3, scope: !22)
!44 = !DILocation(line: 60, column: 8, scope: !17)
!45 = !DILocation(line: 60, column: 5, scope: !17)
!46 = !DILocation(line: 61, column: 10, scope: !17)
!47 = !DILocation(line: 61, column: 3, scope: !17)
!48 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !3, line: 33, type: !6)
!49 = !DILocation(line: 33, column: 25, scope: !12)
!50 = !DILocalVariable(name: "b", arg: 2, scope: !12, file: !3, line: 33, type: !6)
!51 = !DILocation(line: 33, column: 35, scope: !12)
!52 = !DILocalVariable(name: "alpha", scope: !12, file: !3, line: 34, type: !53)
!53 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!54 = !DILocation(line: 34, column: 17, scope: !12)
!55 = !DILocation(line: 36, column: 16, scope: !12)
!56 = !DILocation(line: 36, column: 20, scope: !12)
!57 = !DILocation(line: 36, column: 18, scope: !12)
!58 = !DILocation(line: 36, column: 13, scope: !12)
!59 = !DILocation(line: 36, column: 39, scope: !12)
!60 = !DILocation(line: 36, column: 37, scope: !12)
!61 = !DILocation(line: 36, column: 23, scope: !12)
!62 = !DILocation(line: 36, column: 5, scope: !12)
!63 = !DILocation(line: 37, column: 10, scope: !12)
!64 = !DILocation(line: 37, column: 3, scope: !12)
!65 = !DILocation(line: 48, column: 5, scope: !2)
!66 = !DILocation(line: 49, column: 10, scope: !2)
!67 = !DILocation(line: 49, column: 3, scope: !2)
!68 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 84, type: !69, scopeLine: 84, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!69 = !DISubroutineType(types: !70)
!70 = !{!71}
!71 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!72 = !DILocalVariable(name: "x", scope: !68, file: !3, line: 85, type: !6)
!73 = !DILocation(line: 85, column: 10, scope: !68)
!74 = !DILocalVariable(name: "y", scope: !68, file: !3, line: 86, type: !6)
!75 = !DILocation(line: 86, column: 10, scope: !68)
!76 = !DILocalVariable(name: "ewma", scope: !68, file: !3, line: 90, type: !6)
!77 = !DILocation(line: 90, column: 10, scope: !68)
!78 = !DILocation(line: 90, column: 3, scope: !68)
!79 = !DILocalVariable(name: "i", scope: !80, file: !3, line: 94, type: !71)
!80 = distinct !DILexicalBlock(scope: !68, file: !3, line: 94, column: 3)
!81 = !DILocation(line: 94, column: 12, scope: !80)
!82 = !DILocation(line: 94, column: 8, scope: !80)
!83 = !DILocation(line: 94, column: 17, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 94, column: 3)
!85 = !DILocation(line: 94, column: 19, scope: !84)
!86 = !DILocation(line: 94, column: 3, scope: !80)
!87 = !DILocation(line: 95, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 94, column: 30)
!89 = !DILocation(line: 95, column: 7, scope: !88)
!90 = !DILocation(line: 96, column: 21, scope: !88)
!91 = !DILocation(line: 96, column: 12, scope: !88)
!92 = !DILocation(line: 96, column: 10, scope: !88)
!93 = !DILocation(line: 97, column: 20, scope: !88)
!94 = !DILocation(line: 97, column: 5, scope: !88)
!95 = !DILocation(line: 98, column: 3, scope: !88)
!96 = !DILocation(line: 94, column: 26, scope: !84)
!97 = !DILocation(line: 94, column: 3, scope: !84)
!98 = distinct !{!98, !86, !99}
!99 = !DILocation(line: 98, column: 3, scope: !80)
!100 = !DILocation(line: 99, column: 3, scope: !68)
!101 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 102, type: !69, scopeLine: 102, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!102 = !DILocation(line: 103, column: 10, scope: !101)
!103 = !DILocation(line: 103, column: 3, scope: !101)
