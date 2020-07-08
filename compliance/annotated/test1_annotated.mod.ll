; ModuleID = 'test1_annotated.mod.c'
source_filename = "test1_annotated.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !10
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [22 x i8] c"test1_annotated.mod.c\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !15
@.str.2 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i32 0, i32 0), i32 22 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i32 0, i32 0), i32 32 }], section "llvm.metadata"

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
define dso_local i32 @ewma_main() #0 !dbg !46 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !50, metadata !DIExpression()), !dbg !51
  %6 = bitcast double* %1 to i8*, !dbg !52
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i32 0, i32 0), i32 42), !dbg !52
  call void @llvm.dbg.declare(metadata double* %2, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata double* %3, metadata !55, metadata !DIExpression()), !dbg !56
  call void @llvm.dbg.declare(metadata double* %4, metadata !57, metadata !DIExpression()), !dbg !58
  %7 = bitcast double* %4 to i8*, !dbg !59
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i32 0, i32 0), i32 49), !dbg !59
  call void @llvm.dbg.declare(metadata i32* %5, metadata !60, metadata !DIExpression()), !dbg !62
  store i32 0, i32* %5, align 4, !dbg !62
  br label %8, !dbg !63

8:                                                ; preds = %19, %0
  %9 = load i32, i32* %5, align 4, !dbg !64
  %10 = icmp slt i32 %9, 10, !dbg !66
  br i1 %10, label %11, label %22, !dbg !67

11:                                               ; preds = %8
  %12 = call double @get_a(), !dbg !68
  store double %12, double* %2, align 8, !dbg !70
  %13 = call double @get_b(), !dbg !71
  store double %13, double* %3, align 8, !dbg !72
  %14 = load double, double* %2, align 8, !dbg !73
  %15 = load double, double* %3, align 8, !dbg !74
  %16 = call double @calc_ewma(double %14, double %15), !dbg !75
  store double %16, double* %4, align 8, !dbg !76
  %17 = load double, double* %4, align 8, !dbg !77
  %18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), double %17), !dbg !78
  br label %19, !dbg !79

19:                                               ; preds = %11
  %20 = load i32, i32* %5, align 4, !dbg !80
  %21 = add nsw i32 %20, 1, !dbg !80
  store i32 %21, i32* %5, align 4, !dbg !80
  br label %8, !dbg !81, !llvm.loop !82

22:                                               ; preds = %8
  ret i32 0, !dbg !84
}

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !85 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !91, metadata !DIExpression()), !dbg !92
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !93, metadata !DIExpression()), !dbg !94
  %6 = call i32 @ewma_main(), !dbg !95
  ret i32 %6, !dbg !96
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 14, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 12, type: !4, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "test1_annotated.mod.c", directory: "/home/tchen/gaps/build/apps/tests/test1/annotated")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10, !15}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "a", scope: !12, file: !3, line: 22, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 19, type: !13, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "b", scope: !17, file: !3, line: 32, type: !6, isLocal: true, isDefinition: true)
!17 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 29, type: !13, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!18 = !{i32 7, !"Dwarf Version", i32 4}
!19 = !{i32 2, !"Debug Info Version", i32 3}
!20 = !{i32 1, !"wchar_size", i32 4}
!21 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!22 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 12, type: !6)
!23 = !DILocation(line: 12, column: 25, scope: !2)
!24 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 12, type: !6)
!25 = !DILocation(line: 12, column: 35, scope: !2)
!26 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 13, type: !27)
!27 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!28 = !DILocation(line: 13, column: 17, scope: !2)
!29 = !DILocation(line: 15, column: 16, scope: !2)
!30 = !DILocation(line: 15, column: 20, scope: !2)
!31 = !DILocation(line: 15, column: 18, scope: !2)
!32 = !DILocation(line: 15, column: 13, scope: !2)
!33 = !DILocation(line: 15, column: 39, scope: !2)
!34 = !DILocation(line: 15, column: 37, scope: !2)
!35 = !DILocation(line: 15, column: 23, scope: !2)
!36 = !DILocation(line: 15, column: 5, scope: !2)
!37 = !DILocation(line: 16, column: 10, scope: !2)
!38 = !DILocation(line: 16, column: 3, scope: !2)
!39 = !DILocation(line: 25, column: 5, scope: !12)
!40 = !DILocation(line: 26, column: 10, scope: !12)
!41 = !DILocation(line: 26, column: 3, scope: !12)
!42 = !DILocation(line: 35, column: 8, scope: !17)
!43 = !DILocation(line: 35, column: 5, scope: !17)
!44 = !DILocation(line: 36, column: 10, scope: !17)
!45 = !DILocation(line: 36, column: 3, scope: !17)
!46 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 39, type: !47, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!47 = !DISubroutineType(types: !48)
!48 = !{!49}
!49 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!50 = !DILocalVariable(name: "z", scope: !46, file: !3, line: 42, type: !6)
!51 = !DILocation(line: 42, column: 12, scope: !46)
!52 = !DILocation(line: 42, column: 5, scope: !46)
!53 = !DILocalVariable(name: "x", scope: !46, file: !3, line: 45, type: !6)
!54 = !DILocation(line: 45, column: 10, scope: !46)
!55 = !DILocalVariable(name: "y", scope: !46, file: !3, line: 46, type: !6)
!56 = !DILocation(line: 46, column: 10, scope: !46)
!57 = !DILocalVariable(name: "ewma", scope: !46, file: !3, line: 49, type: !6)
!58 = !DILocation(line: 49, column: 10, scope: !46)
!59 = !DILocation(line: 49, column: 3, scope: !46)
!60 = !DILocalVariable(name: "i", scope: !61, file: !3, line: 52, type: !49)
!61 = distinct !DILexicalBlock(scope: !46, file: !3, line: 52, column: 3)
!62 = !DILocation(line: 52, column: 12, scope: !61)
!63 = !DILocation(line: 52, column: 8, scope: !61)
!64 = !DILocation(line: 52, column: 17, scope: !65)
!65 = distinct !DILexicalBlock(scope: !61, file: !3, line: 52, column: 3)
!66 = !DILocation(line: 52, column: 19, scope: !65)
!67 = !DILocation(line: 52, column: 3, scope: !61)
!68 = !DILocation(line: 53, column: 9, scope: !69)
!69 = distinct !DILexicalBlock(scope: !65, file: !3, line: 52, column: 30)
!70 = !DILocation(line: 53, column: 7, scope: !69)
!71 = !DILocation(line: 54, column: 9, scope: !69)
!72 = !DILocation(line: 54, column: 7, scope: !69)
!73 = !DILocation(line: 55, column: 22, scope: !69)
!74 = !DILocation(line: 55, column: 24, scope: !69)
!75 = !DILocation(line: 55, column: 12, scope: !69)
!76 = !DILocation(line: 55, column: 10, scope: !69)
!77 = !DILocation(line: 56, column: 20, scope: !69)
!78 = !DILocation(line: 56, column: 5, scope: !69)
!79 = !DILocation(line: 57, column: 3, scope: !69)
!80 = !DILocation(line: 52, column: 26, scope: !65)
!81 = !DILocation(line: 52, column: 3, scope: !65)
!82 = distinct !{!82, !67, !83}
!83 = !DILocation(line: 57, column: 3, scope: !61)
!84 = !DILocation(line: 58, column: 3, scope: !46)
!85 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 61, type: !86, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!86 = !DISubroutineType(types: !87)
!87 = !{!49, !49, !88}
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!91 = !DILocalVariable(name: "argc", arg: 1, scope: !85, file: !3, line: 61, type: !49)
!92 = !DILocation(line: 61, column: 14, scope: !85)
!93 = !DILocalVariable(name: "argv", arg: 2, scope: !85, file: !3, line: 61, type: !88)
!94 = !DILocation(line: 61, column: 27, scope: !85)
!95 = !DILocation(line: 62, column: 10, scope: !85)
!96 = !DILocation(line: 62, column: 3, scope: !85)
