; ModuleID = 'test1_purple.mod.c'
source_filename = "test1_purple.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !10
@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [19 x i8] c"test1_purple.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1, i32 0, i32 0), i32 16 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !19, metadata !DIExpression()), !dbg !20
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !21, metadata !DIExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata double* %5, metadata !23, metadata !DIExpression()), !dbg !25
  store double 2.500000e-01, double* %5, align 8, !dbg !25
  %6 = load double, double* %3, align 8, !dbg !26
  %7 = load double, double* %4, align 8, !dbg !27
  %8 = fadd double %6, %7, !dbg !28
  %9 = fmul double 2.500000e-01, %8, !dbg !29
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !30
  %11 = fmul double 7.500000e-01, %10, !dbg !31
  %12 = fadd double %9, %11, !dbg !32
  store double %12, double* @calc_ewma.c, align 8, !dbg !33
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !34
  ret double %13, !dbg !35
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !12 {
  %1 = load double, double* @get_b.b, align 8, !dbg !36
  %2 = load double, double* @get_b.b, align 8, !dbg !37
  %3 = fadd double %2, %1, !dbg !37
  store double %3, double* @get_b.b, align 8, !dbg !37
  %4 = load double, double* @get_b.b, align 8, !dbg !38
  ret double %4, !dbg !39
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !40 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !44, metadata !DIExpression()), !dbg !45
  %6 = bitcast double* %1 to i8*, !dbg !46
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1, i32 0, i32 0), i32 26), !dbg !46
  call void @llvm.dbg.declare(metadata double* %2, metadata !47, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.declare(metadata double* %3, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata double* %4, metadata !51, metadata !DIExpression()), !dbg !52
  %7 = bitcast double* %4 to i8*, !dbg !53
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1, i32 0, i32 0), i32 33), !dbg !53
  call void @llvm.dbg.declare(metadata i32* %5, metadata !54, metadata !DIExpression()), !dbg !56
  store i32 0, i32* %5, align 4, !dbg !56
  br label %8, !dbg !57

8:                                                ; preds = %19, %0
  %9 = load i32, i32* %5, align 4, !dbg !58
  %10 = icmp slt i32 %9, 10, !dbg !60
  br i1 %10, label %11, label %22, !dbg !61

11:                                               ; preds = %8
  %12 = call double (...) @_rpc_get_a(), !dbg !62
  store double %12, double* %2, align 8, !dbg !64
  %13 = call double @get_b(), !dbg !65
  store double %13, double* %3, align 8, !dbg !66
  %14 = load double, double* %2, align 8, !dbg !67
  %15 = load double, double* %3, align 8, !dbg !68
  %16 = call double @calc_ewma(double %14, double %15), !dbg !69
  store double %16, double* %4, align 8, !dbg !70
  %17 = load double, double* %4, align 8, !dbg !71
  %18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), double %17), !dbg !72
  br label %19, !dbg !73

19:                                               ; preds = %11
  %20 = load i32, i32* %5, align 4, !dbg !74
  %21 = add nsw i32 %20, 1, !dbg !74
  store i32 %21, i32* %5, align 4, !dbg !74
  br label %8, !dbg !75, !llvm.loop !76

22:                                               ; preds = %8
  ret i32 0, !dbg !78
}

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local double @_rpc_get_a(...) #3

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !79 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !85, metadata !DIExpression()), !dbg !86
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !87, metadata !DIExpression()), !dbg !88
  call void (...) @_master_rpc_init(), !dbg !89
  %6 = call i32 @ewma_main(), !dbg !90
  ret i32 %6, !dbg !91
}

declare dso_local void @_master_rpc_init(...) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!15, !16, !17}
!llvm.ident = !{!18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 8, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 6, type: !4, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "test1_purple.mod.c", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/purple")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "b", scope: !12, file: !3, line: 16, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 13, type: !13, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !{i32 7, !"Dwarf Version", i32 4}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!19 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 6, type: !6)
!20 = !DILocation(line: 6, column: 25, scope: !2)
!21 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 6, type: !6)
!22 = !DILocation(line: 6, column: 35, scope: !2)
!23 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 7, type: !24)
!24 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!25 = !DILocation(line: 7, column: 17, scope: !2)
!26 = !DILocation(line: 9, column: 16, scope: !2)
!27 = !DILocation(line: 9, column: 20, scope: !2)
!28 = !DILocation(line: 9, column: 18, scope: !2)
!29 = !DILocation(line: 9, column: 13, scope: !2)
!30 = !DILocation(line: 9, column: 39, scope: !2)
!31 = !DILocation(line: 9, column: 37, scope: !2)
!32 = !DILocation(line: 9, column: 23, scope: !2)
!33 = !DILocation(line: 9, column: 5, scope: !2)
!34 = !DILocation(line: 10, column: 10, scope: !2)
!35 = !DILocation(line: 10, column: 3, scope: !2)
!36 = !DILocation(line: 19, column: 8, scope: !12)
!37 = !DILocation(line: 19, column: 5, scope: !12)
!38 = !DILocation(line: 20, column: 10, scope: !12)
!39 = !DILocation(line: 20, column: 3, scope: !12)
!40 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 23, type: !41, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!41 = !DISubroutineType(types: !42)
!42 = !{!43}
!43 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!44 = !DILocalVariable(name: "z", scope: !40, file: !3, line: 26, type: !6)
!45 = !DILocation(line: 26, column: 10, scope: !40)
!46 = !DILocation(line: 26, column: 3, scope: !40)
!47 = !DILocalVariable(name: "x", scope: !40, file: !3, line: 29, type: !6)
!48 = !DILocation(line: 29, column: 10, scope: !40)
!49 = !DILocalVariable(name: "y", scope: !40, file: !3, line: 30, type: !6)
!50 = !DILocation(line: 30, column: 10, scope: !40)
!51 = !DILocalVariable(name: "ewma", scope: !40, file: !3, line: 33, type: !6)
!52 = !DILocation(line: 33, column: 10, scope: !40)
!53 = !DILocation(line: 33, column: 3, scope: !40)
!54 = !DILocalVariable(name: "i", scope: !55, file: !3, line: 36, type: !43)
!55 = distinct !DILexicalBlock(scope: !40, file: !3, line: 36, column: 3)
!56 = !DILocation(line: 36, column: 12, scope: !55)
!57 = !DILocation(line: 36, column: 8, scope: !55)
!58 = !DILocation(line: 36, column: 17, scope: !59)
!59 = distinct !DILexicalBlock(scope: !55, file: !3, line: 36, column: 3)
!60 = !DILocation(line: 36, column: 19, scope: !59)
!61 = !DILocation(line: 36, column: 3, scope: !55)
!62 = !DILocation(line: 37, column: 9, scope: !63)
!63 = distinct !DILexicalBlock(scope: !59, file: !3, line: 36, column: 30)
!64 = !DILocation(line: 37, column: 7, scope: !63)
!65 = !DILocation(line: 38, column: 9, scope: !63)
!66 = !DILocation(line: 38, column: 7, scope: !63)
!67 = !DILocation(line: 39, column: 22, scope: !63)
!68 = !DILocation(line: 39, column: 24, scope: !63)
!69 = !DILocation(line: 39, column: 12, scope: !63)
!70 = !DILocation(line: 39, column: 10, scope: !63)
!71 = !DILocation(line: 40, column: 20, scope: !63)
!72 = !DILocation(line: 40, column: 5, scope: !63)
!73 = !DILocation(line: 41, column: 3, scope: !63)
!74 = !DILocation(line: 36, column: 26, scope: !59)
!75 = !DILocation(line: 36, column: 3, scope: !59)
!76 = distinct !{!76, !61, !77}
!77 = !DILocation(line: 41, column: 3, scope: !55)
!78 = !DILocation(line: 42, column: 3, scope: !40)
!79 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 45, type: !80, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!80 = !DISubroutineType(types: !81)
!81 = !{!43, !43, !82}
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!85 = !DILocalVariable(name: "argc", arg: 1, scope: !79, file: !3, line: 45, type: !43)
!86 = !DILocation(line: 45, column: 14, scope: !79)
!87 = !DILocalVariable(name: "argv", arg: 2, scope: !79, file: !3, line: 45, type: !82)
!88 = !DILocation(line: 45, column: 27, scope: !79)
!89 = !DILocation(line: 46, column: 3, scope: !79)
!90 = !DILocation(line: 47, column: 10, scope: !79)
!91 = !DILocation(line: 47, column: 3, scope: !79)
