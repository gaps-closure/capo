; ModuleID = 'partitioned/multithreaded/orange/example1_orange.mod.c'
source_filename = "partitioned/multithreaded/orange/example1_orange.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [55 x i8] c"partitioned/multithreaded/orange/example1_orange.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i32 0, i32 0), i32 29 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @get_a to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i32 0, i32 0), i32 24 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
entry:
  %0 = load double, double* @get_a.a, align 8, !dbg !14
  %add = fadd double %0, 1.000000e+00, !dbg !14
  store double %add, double* @get_a.a, align 8, !dbg !14
  %1 = load double, double* @get_a.a, align 8, !dbg !15
  ret double %1, !dbg !16
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !17 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !24, metadata !DIExpression()), !dbg !25
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !26, metadata !DIExpression()), !dbg !27
  %call = call i32 (...) @_slave_rpc_loop(), !dbg !28
  ret i32 %call, !dbg !29
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @_slave_rpc_loop(...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 29, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 24, type: !4, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "partitioned/multithreaded/orange/example1_orange.mod.c", directory: "/home/mkaplan/gaps/build/apps/examples/example1")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0 (https://github.com/gaps-closure/llvm-project.git 27076be6fc363f9973ef5af6e1af3823cd6ac777)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, nameTableKind: None)
!8 = !{}
!9 = !{!0}
!10 = !{i32 2, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"clang version 10.0.0 (https://github.com/gaps-closure/llvm-project.git 27076be6fc363f9973ef5af6e1af3823cd6ac777)"}
!14 = !DILocation(line: 32, column: 5, scope: !2)
!15 = !DILocation(line: 33, column: 10, scope: !2)
!16 = !DILocation(line: 33, column: 3, scope: !2)
!17 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !18, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !20, !21}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !DILocalVariable(name: "argc", arg: 1, scope: !17, file: !3, line: 36, type: !20)
!25 = !DILocation(line: 36, column: 14, scope: !17)
!26 = !DILocalVariable(name: "argv", arg: 2, scope: !17, file: !3, line: 36, type: !21)
!27 = !DILocation(line: 36, column: 27, scope: !17)
!28 = !DILocation(line: 37, column: 10, scope: !17)
!29 = !DILocation(line: 37, column: 3, scope: !17)
