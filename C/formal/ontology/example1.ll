; ModuleID = 'example1.bc'
source_filename = "./test/example1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !11
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !23, metadata !DIExpression()), !dbg !24
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %5, metadata !27, metadata !DIExpression()), !dbg !29
  store double 2.500000e-01, double* %5, align 8, !dbg !29
  %6 = load double, double* %3, align 8, !dbg !30
  %7 = load double, double* %4, align 8, !dbg !31
  %8 = fadd double %6, %7, !dbg !32
  %9 = fmul double 2.500000e-01, %8, !dbg !33
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !34
  %11 = fmul double 7.500000e-01, %10, !dbg !35
  %12 = fadd double %9, %11, !dbg !36
  store double %12, double* @calc_ewma.c, align 8, !dbg !37
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !38
  ret double %13, !dbg !39
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !13 {
  %1 = load double, double* @get_a.a, align 8, !dbg !40
  %2 = fadd double %1, 1.000000e+00, !dbg !40
  store double %2, double* @get_a.a, align 8, !dbg !40
  %3 = load double, double* @get_a.a, align 8, !dbg !41
  ret double %3, !dbg !42
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !43
  %2 = load double, double* @get_b.b, align 8, !dbg !44
  %3 = fadd double %2, %1, !dbg !44
  store double %3, double* @get_b.b, align 8, !dbg !44
  %4 = load double, double* @get_b.b, align 8, !dbg !45
  ret double %4, !dbg !46
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !47 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !51, metadata !DIExpression()), !dbg !52
  call void @llvm.dbg.declare(metadata double* %2, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata double* %3, metadata !55, metadata !DIExpression()), !dbg !56
  call void @llvm.dbg.declare(metadata i32* %4, metadata !57, metadata !DIExpression()), !dbg !59
  store i32 0, i32* %4, align 4, !dbg !59
  br label %5, !dbg !60

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %4, align 4, !dbg !61
  %7 = icmp slt i32 %6, 10, !dbg !63
  br i1 %7, label %8, label %19, !dbg !64

8:                                                ; preds = %5
  %9 = call double @get_a(), !dbg !65
  store double %9, double* %1, align 8, !dbg !67
  %10 = call double @get_b(), !dbg !68
  store double %10, double* %2, align 8, !dbg !69
  %11 = load double, double* %1, align 8, !dbg !70
  %12 = load double, double* %2, align 8, !dbg !71
  %13 = call double @calc_ewma(double %11, double %12), !dbg !72
  store double %13, double* %3, align 8, !dbg !73
  %14 = load double, double* %3, align 8, !dbg !74
  %15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double %14), !dbg !75
  br label %16, !dbg !76

16:                                               ; preds = %8
  %17 = load i32, i32* %4, align 4, !dbg !77
  %18 = add nsw i32 %17, 1, !dbg !77
  store i32 %18, i32* %4, align 4, !dbg !77
  br label %5, !dbg !78, !llvm.loop !79

19:                                               ; preds = %5
  ret i32 0, !dbg !81
}

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !82 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !88, metadata !DIExpression()), !dbg !89
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !90, metadata !DIExpression()), !dbg !91
  %6 = call i32 @ewma_main(), !dbg !92
  ret i32 %6, !dbg !93
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 25, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 23, type: !4, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!3 = !DIFile(filename: "./test/example1.c", directory: "/home/rbrotzman/gaps/build/src/capo/formal/ontology")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, globals: !10, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "test/example1.c", directory: "/home/rbrotzman/gaps/build/src/capo/formal/ontology")
!9 = !{}
!10 = !{!0, !11, !16}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "a", scope: !13, file: !3, line: 34, type: !6, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 31, type: !14, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!14 = !DISubroutineType(types: !15)
!15 = !{!6}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 42, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 40, type: !14, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!19 = !{i32 7, !"Dwarf Version", i32 4}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!23 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 23, type: !6)
!24 = !DILocation(line: 23, column: 25, scope: !2)
!25 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 23, type: !6)
!26 = !DILocation(line: 23, column: 35, scope: !2)
!27 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 24, type: !28)
!28 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!29 = !DILocation(line: 24, column: 17, scope: !2)
!30 = !DILocation(line: 26, column: 16, scope: !2)
!31 = !DILocation(line: 26, column: 20, scope: !2)
!32 = !DILocation(line: 26, column: 18, scope: !2)
!33 = !DILocation(line: 26, column: 13, scope: !2)
!34 = !DILocation(line: 26, column: 39, scope: !2)
!35 = !DILocation(line: 26, column: 37, scope: !2)
!36 = !DILocation(line: 26, column: 23, scope: !2)
!37 = !DILocation(line: 26, column: 5, scope: !2)
!38 = !DILocation(line: 27, column: 10, scope: !2)
!39 = !DILocation(line: 27, column: 3, scope: !2)
!40 = !DILocation(line: 36, column: 5, scope: !13)
!41 = !DILocation(line: 37, column: 10, scope: !13)
!42 = !DILocation(line: 37, column: 3, scope: !13)
!43 = !DILocation(line: 44, column: 8, scope: !18)
!44 = !DILocation(line: 44, column: 5, scope: !18)
!45 = !DILocation(line: 45, column: 10, scope: !18)
!46 = !DILocation(line: 45, column: 3, scope: !18)
!47 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 48, type: !48, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!48 = !DISubroutineType(types: !49)
!49 = !{!50}
!50 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!51 = !DILocalVariable(name: "x", scope: !47, file: !3, line: 49, type: !6)
!52 = !DILocation(line: 49, column: 10, scope: !47)
!53 = !DILocalVariable(name: "y", scope: !47, file: !3, line: 50, type: !6)
!54 = !DILocation(line: 50, column: 10, scope: !47)
!55 = !DILocalVariable(name: "ewma", scope: !47, file: !3, line: 52, type: !6)
!56 = !DILocation(line: 52, column: 10, scope: !47)
!57 = !DILocalVariable(name: "i", scope: !58, file: !3, line: 54, type: !50)
!58 = distinct !DILexicalBlock(scope: !47, file: !3, line: 54, column: 3)
!59 = !DILocation(line: 54, column: 12, scope: !58)
!60 = !DILocation(line: 54, column: 8, scope: !58)
!61 = !DILocation(line: 54, column: 17, scope: !62)
!62 = distinct !DILexicalBlock(scope: !58, file: !3, line: 54, column: 3)
!63 = !DILocation(line: 54, column: 19, scope: !62)
!64 = !DILocation(line: 54, column: 3, scope: !58)
!65 = !DILocation(line: 55, column: 9, scope: !66)
!66 = distinct !DILexicalBlock(scope: !62, file: !3, line: 54, column: 30)
!67 = !DILocation(line: 55, column: 7, scope: !66)
!68 = !DILocation(line: 56, column: 9, scope: !66)
!69 = !DILocation(line: 56, column: 7, scope: !66)
!70 = !DILocation(line: 57, column: 22, scope: !66)
!71 = !DILocation(line: 57, column: 24, scope: !66)
!72 = !DILocation(line: 57, column: 12, scope: !66)
!73 = !DILocation(line: 57, column: 10, scope: !66)
!74 = !DILocation(line: 58, column: 20, scope: !66)
!75 = !DILocation(line: 58, column: 5, scope: !66)
!76 = !DILocation(line: 59, column: 3, scope: !66)
!77 = !DILocation(line: 54, column: 26, scope: !62)
!78 = !DILocation(line: 54, column: 3, scope: !62)
!79 = distinct !{!79, !64, !80}
!80 = !DILocation(line: 59, column: 3, scope: !58)
!81 = !DILocation(line: 60, column: 3, scope: !47)
!82 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 63, type: !83, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!83 = !DISubroutineType(types: !84)
!84 = !{!50, !50, !85}
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!88 = !DILocalVariable(name: "argc", arg: 1, scope: !82, file: !3, line: 63, type: !50)
!89 = !DILocation(line: 63, column: 14, scope: !82)
!90 = !DILocalVariable(name: "argv", arg: 2, scope: !82, file: !3, line: 63, type: !85)
!91 = !DILocation(line: 63, column: 27, scope: !82)
!92 = !DILocation(line: 64, column: 10, scope: !82)
!93 = !DILocation(line: 64, column: 3, scope: !82)
