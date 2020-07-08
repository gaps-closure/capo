; ModuleID = 'test1_orange_rpc.mod.c'
source_filename = "test1_orange_rpc.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._tag = type { i32, i32, i32 }
%struct._requesta_datatype = type { i32, %struct._trailer_datatype }
%struct._trailer_datatype = type { i32, i32, i32, i16, i16 }
%struct._responsea_datatype = type { double, %struct._trailer_datatype }
%struct._nextrpc_datatype = type { i32, i32, i32, %struct._trailer_datatype }
%struct._okay_datatype = type { i32, %struct._trailer_datatype }
%union.pthread_attr_t = type { i64, [48 x i8] }

@_handle_requesta.inited = internal global i32 0, align 4, !dbg !0
@_handle_requesta.psocket = internal global i8* null, align 8, !dbg !13
@_handle_requesta.ssocket = internal global i8* null, align 8, !dbg !15
@.str = private unnamed_addr constant [13 x i8] c"TAG_REQUESTA\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [23 x i8] c"test1_orange_rpc.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [14 x i8] c"TAG_RESPONSEA\00", section "llvm.metadata"
@_handle_nxtrpc.inited = internal global i32 0, align 4, !dbg !17
@_handle_nxtrpc.psocket = internal global i8* null, align 8, !dbg !36
@_handle_nxtrpc.ssocket = internal global i8* null, align 8, !dbg !38
@.str.3 = private unnamed_addr constant [12 x i8] c"TAG_NEXTRPC\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [9 x i8] c"TAG_OKAY\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/test1suborange\00", align 1
@.str.6 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/test1puborange\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_handle_requesta(i8* %0) #0 !dbg !2 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct._tag, align 4
  %4 = alloca %struct._tag, align 4
  %5 = alloca %struct._requesta_datatype, align 4
  %6 = alloca %struct._responsea_datatype, align 8
  %7 = alloca { i64, i32 }, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !44, metadata !DIExpression()), !dbg !45
  call void @llvm.dbg.declare(metadata %struct._tag* %3, metadata !46, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata %struct._tag* %4, metadata !48, metadata !DIExpression()), !dbg !49
  call void @llvm.dbg.declare(metadata %struct._requesta_datatype* %5, metadata !50, metadata !DIExpression()), !dbg !71
  %8 = bitcast %struct._requesta_datatype* %5 to i8*, !dbg !72
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 17), !dbg !72
  call void @llvm.dbg.declare(metadata %struct._responsea_datatype* %6, metadata !73, metadata !DIExpression()), !dbg !80
  %9 = bitcast %struct._responsea_datatype* %6 to i8*, !dbg !81
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 22), !dbg !81
  call void @tag_write(%struct._tag* %3, i32 1, i32 1, i32 3), !dbg !82
  %10 = load i32, i32* @_handle_requesta.inited, align 4, !dbg !83
  %11 = icmp ne i32 %10, 0, !dbg !83
  br i1 %11, label %22, label %12, !dbg !85

12:                                               ; preds = %1
  store i32 1, i32* @_handle_requesta.inited, align 4, !dbg !86
  %13 = call i8* @xdc_pub_socket(), !dbg !88
  store i8* %13, i8** @_handle_requesta.psocket, align 8, !dbg !89
  %14 = bitcast { i64, i32 }* %7 to i8*, !dbg !90
  %15 = bitcast %struct._tag* %3 to i8*, !dbg !90
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %14, i8* align 4 %15, i64 12, i1 false), !dbg !90
  %16 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %7, i32 0, i32 0, !dbg !90
  %17 = load i64, i64* %16, align 4, !dbg !90
  %18 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %7, i32 0, i32 1, !dbg !90
  %19 = load i32, i32* %18, align 4, !dbg !90
  %20 = call i8* @xdc_sub_socket(i64 %17, i32 %19), !dbg !90
  store i8* %20, i8** @_handle_requesta.ssocket, align 8, !dbg !91
  %21 = call i32 @sleep(i32 1), !dbg !92
  br label %22, !dbg !93

22:                                               ; preds = %12, %1
  %23 = load i8*, i8** @_handle_requesta.ssocket, align 8, !dbg !94
  %24 = bitcast %struct._requesta_datatype* %5 to i8*, !dbg !95
  call void @xdc_blocking_recv(i8* %23, i8* %24, %struct._tag* %3), !dbg !96
  %25 = call double (...) @get_a(), !dbg !97
  %26 = getelementptr inbounds %struct._responsea_datatype, %struct._responsea_datatype* %6, i32 0, i32 0, !dbg !98
  store double %25, double* %26, align 8, !dbg !99
  call void @tag_write(%struct._tag* %4, i32 2, i32 2, i32 4), !dbg !100
  %27 = load i8*, i8** @_handle_requesta.psocket, align 8, !dbg !101
  %28 = bitcast %struct._responsea_datatype* %6 to i8*, !dbg !102
  call void @xdc_asyn_send(i8* %27, i8* %28, %struct._tag* %4), !dbg !103
  ret void, !dbg !104
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local void @tag_write(%struct._tag*, i32, i32, i32) #3

declare dso_local i8* @xdc_pub_socket() #3

declare dso_local i8* @xdc_sub_socket(i64, i32) #3

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

declare dso_local i32 @sleep(i32) #3

declare dso_local void @xdc_blocking_recv(i8*, i8*, %struct._tag*) #3

declare dso_local double @get_a(...) #3

declare dso_local void @xdc_asyn_send(i8*, i8*, %struct._tag*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_handle_nxtrpc(%struct._tag* %0) #0 !dbg !19 {
  %2 = alloca %struct._tag*, align 8
  %3 = alloca %struct._tag, align 4
  %4 = alloca %struct._tag, align 4
  %5 = alloca %struct._nextrpc_datatype, align 4
  %6 = alloca %struct._okay_datatype, align 4
  %7 = alloca { i64, i32 }, align 4
  store %struct._tag* %0, %struct._tag** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._tag** %2, metadata !105, metadata !DIExpression()), !dbg !106
  call void @llvm.dbg.declare(metadata %struct._tag* %3, metadata !107, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.declare(metadata %struct._tag* %4, metadata !109, metadata !DIExpression()), !dbg !110
  call void @llvm.dbg.declare(metadata %struct._nextrpc_datatype* %5, metadata !111, metadata !DIExpression()), !dbg !119
  %8 = bitcast %struct._nextrpc_datatype* %5 to i8*, !dbg !120
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 53), !dbg !120
  call void @llvm.dbg.declare(metadata %struct._okay_datatype* %6, metadata !121, metadata !DIExpression()), !dbg !127
  %9 = bitcast %struct._okay_datatype* %6 to i8*, !dbg !128
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 58), !dbg !128
  call void @tag_write(%struct._tag* %3, i32 1, i32 1, i32 1), !dbg !129
  %10 = load i32, i32* @_handle_nxtrpc.inited, align 4, !dbg !130
  %11 = icmp ne i32 %10, 0, !dbg !130
  br i1 %11, label %22, label %12, !dbg !132

12:                                               ; preds = %1
  store i32 1, i32* @_handle_nxtrpc.inited, align 4, !dbg !133
  %13 = call i8* @xdc_pub_socket(), !dbg !135
  store i8* %13, i8** @_handle_nxtrpc.psocket, align 8, !dbg !136
  %14 = bitcast { i64, i32 }* %7 to i8*, !dbg !137
  %15 = bitcast %struct._tag* %3 to i8*, !dbg !137
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %14, i8* align 4 %15, i64 12, i1 false), !dbg !137
  %16 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %7, i32 0, i32 0, !dbg !137
  %17 = load i64, i64* %16, align 4, !dbg !137
  %18 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %7, i32 0, i32 1, !dbg !137
  %19 = load i32, i32* %18, align 4, !dbg !137
  %20 = call i8* @xdc_sub_socket(i64 %17, i32 %19), !dbg !137
  store i8* %20, i8** @_handle_nxtrpc.ssocket, align 8, !dbg !138
  %21 = call i32 @sleep(i32 1), !dbg !139
  br label %22, !dbg !140

22:                                               ; preds = %12, %1
  %23 = load i8*, i8** @_handle_nxtrpc.ssocket, align 8, !dbg !141
  %24 = bitcast %struct._nextrpc_datatype* %5 to i8*, !dbg !142
  call void @xdc_blocking_recv(i8* %23, i8* %24, %struct._tag* %3), !dbg !143
  call void @tag_write(%struct._tag* %4, i32 2, i32 2, i32 2), !dbg !144
  %25 = getelementptr inbounds %struct._okay_datatype, %struct._okay_datatype* %6, i32 0, i32 0, !dbg !145
  store i32 0, i32* %25, align 4, !dbg !146
  %26 = load i8*, i8** @_handle_nxtrpc.psocket, align 8, !dbg !147
  %27 = bitcast %struct._okay_datatype* %6 to i8*, !dbg !148
  call void @xdc_asyn_send(i8* %26, i8* %27, %struct._tag* %4), !dbg !149
  %28 = getelementptr inbounds %struct._nextrpc_datatype, %struct._nextrpc_datatype* %5, i32 0, i32 0, !dbg !150
  %29 = load i32, i32* %28, align 4, !dbg !150
  %30 = load %struct._tag*, %struct._tag** %2, align 8, !dbg !151
  %31 = getelementptr inbounds %struct._tag, %struct._tag* %30, i32 0, i32 0, !dbg !152
  store i32 %29, i32* %31, align 4, !dbg !153
  %32 = getelementptr inbounds %struct._nextrpc_datatype, %struct._nextrpc_datatype* %5, i32 0, i32 1, !dbg !154
  %33 = load i32, i32* %32, align 4, !dbg !154
  %34 = load %struct._tag*, %struct._tag** %2, align 8, !dbg !155
  %35 = getelementptr inbounds %struct._tag, %struct._tag* %34, i32 0, i32 1, !dbg !156
  store i32 %33, i32* %35, align 4, !dbg !157
  %36 = getelementptr inbounds %struct._nextrpc_datatype, %struct._nextrpc_datatype* %5, i32 0, i32 2, !dbg !158
  %37 = load i32, i32* %36, align 4, !dbg !158
  %38 = load %struct._tag*, %struct._tag** %2, align 8, !dbg !159
  %39 = getelementptr inbounds %struct._tag, %struct._tag* %38, i32 0, i32 2, !dbg !160
  store i32 %37, i32* %39, align 4, !dbg !161
  ret void, !dbg !162
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_hal_init(i8* %0, i8* %1) #0 !dbg !163 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !166, metadata !DIExpression()), !dbg !167
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !168, metadata !DIExpression()), !dbg !169
  %5 = load i8*, i8** %3, align 8, !dbg !170
  %6 = call i8* @xdc_set_in(i8* %5), !dbg !171
  %7 = load i8*, i8** %4, align 8, !dbg !172
  %8 = call i8* @xdc_set_out(i8* %7), !dbg !173
  call void @xdc_register(void (i8*, i8*, i64*)* @nextrpc_data_encode, void (i8*, i8*, i64*)* @nextrpc_data_decode, i32 1), !dbg !174
  call void @xdc_register(void (i8*, i8*, i64*)* @okay_data_encode, void (i8*, i8*, i64*)* @okay_data_decode, i32 2), !dbg !175
  call void @xdc_register(void (i8*, i8*, i64*)* @requesta_data_encode, void (i8*, i8*, i64*)* @requesta_data_decode, i32 3), !dbg !176
  call void @xdc_register(void (i8*, i8*, i64*)* @responsea_data_encode, void (i8*, i8*, i64*)* @responsea_data_decode, i32 4), !dbg !177
  ret void, !dbg !178
}

declare dso_local i8* @xdc_set_in(i8*) #3

declare dso_local i8* @xdc_set_out(i8*) #3

declare dso_local void @xdc_register(void (i8*, i8*, i64*)*, void (i8*, i8*, i64*)*, i32) #3

declare dso_local void @nextrpc_data_encode(i8*, i8*, i64*) #3

declare dso_local void @nextrpc_data_decode(i8*, i8*, i64*) #3

declare dso_local void @okay_data_encode(i8*, i8*, i64*) #3

declare dso_local void @okay_data_decode(i8*, i8*, i64*) #3

declare dso_local void @requesta_data_encode(i8*, i8*, i64*) #3

declare dso_local void @requesta_data_decode(i8*, i8*, i64*) #3

declare dso_local void @responsea_data_encode(i8*, i8*, i64*) #3

declare dso_local void @responsea_data_decode(i8*, i8*, i64*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @_wrapper_nxtrpc(i8* %0) #0 !dbg !179 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !182, metadata !DIExpression()), !dbg !183
  br label %3, !dbg !183

3:                                                ; preds = %1, %3
  %4 = load i8*, i8** %2, align 8, !dbg !184
  %5 = bitcast i8* %4 to %struct._tag*, !dbg !184
  call void @_handle_nxtrpc(%struct._tag* %5), !dbg !184
  br label %3, !dbg !183, !llvm.loop !186
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @_wrapper_requesta(i8* %0) #0 !dbg !187 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !188, metadata !DIExpression()), !dbg !189
  br label %3, !dbg !189

3:                                                ; preds = %1, %3
  %4 = load i8*, i8** %2, align 8, !dbg !190
  call void @_handle_requesta(i8* %4), !dbg !190
  br label %3, !dbg !189, !llvm.loop !192
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_slave_rpc_loop() #0 !dbg !193 {
  %1 = alloca %struct._tag, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata %struct._tag* %1, metadata !196, metadata !DIExpression()), !dbg !197
  call void @llvm.dbg.declare(metadata [2 x i64]* %2, metadata !198, metadata !DIExpression()), !dbg !205
  call void @_hal_init(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.5, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.6, i64 0, i64 0)), !dbg !206
  %4 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 0, !dbg !207
  %5 = bitcast %struct._tag* %1 to i8*, !dbg !208
  %6 = call i32 @pthread_create(i64* %4, %union.pthread_attr_t* null, i8* (i8*)* @_wrapper_nxtrpc, i8* %5) #6, !dbg !209
  %7 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 1, !dbg !210
  %8 = bitcast %struct._tag* %1 to i8*, !dbg !211
  %9 = call i32 @pthread_create(i64* %7, %union.pthread_attr_t* null, i8* (i8*)* @_wrapper_requesta, i8* %8) #6, !dbg !212
  call void @llvm.dbg.declare(metadata i32* %3, metadata !213, metadata !DIExpression()), !dbg !215
  store i32 0, i32* %3, align 4, !dbg !215
  br label %10, !dbg !216

10:                                               ; preds = %19, %0
  %11 = load i32, i32* %3, align 4, !dbg !217
  %12 = icmp slt i32 %11, 2, !dbg !219
  br i1 %12, label %13, label %22, !dbg !220

13:                                               ; preds = %10
  %14 = load i32, i32* %3, align 4, !dbg !221
  %15 = sext i32 %14 to i64, !dbg !222
  %16 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %15, !dbg !222
  %17 = load i64, i64* %16, align 8, !dbg !222
  %18 = call i32 @pthread_join(i64 %17, i8** null), !dbg !223
  br label %19, !dbg !223

19:                                               ; preds = %13
  %20 = load i32, i32* %3, align 4, !dbg !224
  %21 = add nsw i32 %20, 1, !dbg !224
  store i32 %21, i32* %3, align 4, !dbg !224
  br label %10, !dbg !225, !llvm.loop !226

22:                                               ; preds = %10
  ret i32 0, !dbg !228
}

; Function Attrs: nounwind
declare !callback !229 dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #5

declare dso_local i32 @pthread_join(i64, i8**) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind willreturn }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!40, !41, !42}
!llvm.ident = !{!43}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "inited", scope: !2, file: !3, line: 10, type: !35, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "_handle_requesta", scope: !3, file: !3, line: 9, type: !4, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "test1_orange_rpc.mod.c", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/orange")
!4 = !DISubroutineType(types: !5)
!5 = !{null, !6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, retainedTypes: !9, globals: !12, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!10}
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!0, !13, !15, !17, !36, !38}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "psocket", scope: !2, file: !3, line: 11, type: !6, isLocal: true, isDefinition: true)
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "ssocket", scope: !2, file: !3, line: 12, type: !6, isLocal: true, isDefinition: true)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "inited", scope: !19, file: !3, line: 46, type: !35, isLocal: true, isDefinition: true)
!19 = distinct !DISubprogram(name: "_handle_nxtrpc", scope: !3, file: !3, line: 45, type: !20, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!20 = !DISubroutineType(types: !21)
!21 = !{null, !22}
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "gaps_tag", file: !24, line: 29, baseType: !25)
!24 = !DIFile(filename: "../../../../../../src/hal/api/xdcomms.h", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/orange")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_tag", file: !24, line: 25, size: 96, elements: !26)
!26 = !{!27, !33, !34}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "mux", scope: !25, file: !24, line: 26, baseType: !28, size: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !29, line: 26, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !31, line: 42, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!32 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "sec", scope: !25, file: !24, line: 27, baseType: !28, size: 32, offset: 32)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "typ", scope: !25, file: !24, line: 28, baseType: !28, size: 32, offset: 64)
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "psocket", scope: !19, file: !3, line: 47, type: !6, isLocal: true, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "ssocket", scope: !19, file: !3, line: 48, type: !6, isLocal: true, isDefinition: true)
!40 = !{i32 7, !"Dwarf Version", i32 4}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!44 = !DILocalVariable(name: "tag", arg: 1, scope: !2, file: !3, line: 9, type: !6)
!45 = !DILocation(line: 9, column: 52, scope: !2)
!46 = !DILocalVariable(name: "t_tag", scope: !2, file: !3, line: 13, type: !23)
!47 = !DILocation(line: 13, column: 14, scope: !2)
!48 = !DILocalVariable(name: "o_tag", scope: !2, file: !3, line: 14, type: !23)
!49 = !DILocation(line: 14, column: 14, scope: !2)
!50 = !DILocalVariable(name: "reqA", scope: !2, file: !3, line: 17, type: !51)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "requesta_datatype", file: !52, line: 57, baseType: !53)
!52 = !DIFile(filename: "../autogen/codec.h", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/orange")
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_requesta_datatype", file: !52, line: 54, size: 160, elements: !54)
!54 = !{!55, !59}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !53, file: !52, line: 55, baseType: !56, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !57, line: 26, baseType: !58)
!57 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !31, line: 41, baseType: !35)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !53, file: !52, line: 56, baseType: !60, size: 128, offset: 32)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "trailer_datatype", file: !52, line: 23, baseType: !61)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_trailer_datatype", file: !52, line: 17, size: 128, elements: !62)
!62 = !{!63, !64, !65, !66, !70}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !61, file: !52, line: 18, baseType: !28, size: 32)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "rqr", scope: !61, file: !52, line: 19, baseType: !28, size: 32, offset: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "oid", scope: !61, file: !52, line: 20, baseType: !28, size: 32, offset: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "mid", scope: !61, file: !52, line: 21, baseType: !67, size: 16, offset: 96)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !29, line: 25, baseType: !68)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !31, line: 40, baseType: !69)
!69 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "crc", scope: !61, file: !52, line: 22, baseType: !67, size: 16, offset: 112)
!71 = !DILocation(line: 17, column: 24, scope: !2)
!72 = !DILocation(line: 17, column: 5, scope: !2)
!73 = !DILocalVariable(name: "resA", scope: !2, file: !3, line: 22, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "responsea_datatype", file: !52, line: 67, baseType: !75)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_responsea_datatype", file: !52, line: 64, size: 192, elements: !76)
!76 = !{!77, !79}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !75, file: !52, line: 65, baseType: !78, size: 64)
!78 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !75, file: !52, line: 66, baseType: !60, size: 128, offset: 64)
!80 = !DILocation(line: 22, column: 24, scope: !2)
!81 = !DILocation(line: 22, column: 5, scope: !2)
!82 = !DILocation(line: 26, column: 5, scope: !2)
!83 = !DILocation(line: 27, column: 10, scope: !84)
!84 = distinct !DILexicalBlock(scope: !2, file: !3, line: 27, column: 9)
!85 = !DILocation(line: 27, column: 9, scope: !2)
!86 = !DILocation(line: 28, column: 14, scope: !87)
!87 = distinct !DILexicalBlock(scope: !84, file: !3, line: 27, column: 18)
!88 = !DILocation(line: 29, column: 17, scope: !87)
!89 = !DILocation(line: 29, column: 15, scope: !87)
!90 = !DILocation(line: 30, column: 17, scope: !87)
!91 = !DILocation(line: 30, column: 15, scope: !87)
!92 = !DILocation(line: 31, column: 7, scope: !87)
!93 = !DILocation(line: 32, column: 5, scope: !87)
!94 = !DILocation(line: 34, column: 23, scope: !2)
!95 = !DILocation(line: 34, column: 32, scope: !2)
!96 = !DILocation(line: 34, column: 5, scope: !2)
!97 = !DILocation(line: 35, column: 14, scope: !2)
!98 = !DILocation(line: 35, column: 10, scope: !2)
!99 = !DILocation(line: 35, column: 12, scope: !2)
!100 = !DILocation(line: 41, column: 5, scope: !2)
!101 = !DILocation(line: 42, column: 19, scope: !2)
!102 = !DILocation(line: 42, column: 28, scope: !2)
!103 = !DILocation(line: 42, column: 5, scope: !2)
!104 = !DILocation(line: 43, column: 1, scope: !2)
!105 = !DILocalVariable(name: "n_tag", arg: 1, scope: !19, file: !3, line: 45, type: !22)
!106 = !DILocation(line: 45, column: 31, scope: !19)
!107 = !DILocalVariable(name: "t_tag", scope: !19, file: !3, line: 49, type: !23)
!108 = !DILocation(line: 49, column: 14, scope: !19)
!109 = !DILocalVariable(name: "o_tag", scope: !19, file: !3, line: 50, type: !23)
!110 = !DILocation(line: 50, column: 14, scope: !19)
!111 = !DILocalVariable(name: "nxt", scope: !19, file: !3, line: 53, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "nextrpc_datatype", file: !52, line: 35, baseType: !113)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_nextrpc_datatype", file: !52, line: 30, size: 224, elements: !114)
!114 = !{!115, !116, !117, !118}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "mux", scope: !113, file: !52, line: 31, baseType: !56, size: 32)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "sec", scope: !113, file: !52, line: 32, baseType: !56, size: 32, offset: 32)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "typ", scope: !113, file: !52, line: 33, baseType: !56, size: 32, offset: 64)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !113, file: !52, line: 34, baseType: !60, size: 128, offset: 96)
!119 = !DILocation(line: 53, column: 22, scope: !19)
!120 = !DILocation(line: 53, column: 5, scope: !19)
!121 = !DILocalVariable(name: "okay", scope: !19, file: !3, line: 58, type: !122)
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "okay_datatype", file: !52, line: 47, baseType: !123)
!123 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_okay_datatype", file: !52, line: 44, size: 160, elements: !124)
!124 = !{!125, !126}
!125 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !123, file: !52, line: 45, baseType: !56, size: 32)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !123, file: !52, line: 46, baseType: !60, size: 128, offset: 32)
!127 = !DILocation(line: 58, column: 19, scope: !19)
!128 = !DILocation(line: 58, column: 5, scope: !19)
!129 = !DILocation(line: 62, column: 5, scope: !19)
!130 = !DILocation(line: 63, column: 10, scope: !131)
!131 = distinct !DILexicalBlock(scope: !19, file: !3, line: 63, column: 9)
!132 = !DILocation(line: 63, column: 9, scope: !19)
!133 = !DILocation(line: 64, column: 14, scope: !134)
!134 = distinct !DILexicalBlock(scope: !131, file: !3, line: 63, column: 18)
!135 = !DILocation(line: 65, column: 17, scope: !134)
!136 = !DILocation(line: 65, column: 15, scope: !134)
!137 = !DILocation(line: 66, column: 17, scope: !134)
!138 = !DILocation(line: 66, column: 15, scope: !134)
!139 = !DILocation(line: 67, column: 7, scope: !134)
!140 = !DILocation(line: 68, column: 5, scope: !134)
!141 = !DILocation(line: 70, column: 23, scope: !19)
!142 = !DILocation(line: 70, column: 32, scope: !19)
!143 = !DILocation(line: 70, column: 5, scope: !19)
!144 = !DILocation(line: 73, column: 5, scope: !19)
!145 = !DILocation(line: 74, column: 10, scope: !19)
!146 = !DILocation(line: 74, column: 12, scope: !19)
!147 = !DILocation(line: 75, column: 19, scope: !19)
!148 = !DILocation(line: 75, column: 28, scope: !19)
!149 = !DILocation(line: 75, column: 5, scope: !19)
!150 = !DILocation(line: 77, column: 22, scope: !19)
!151 = !DILocation(line: 77, column: 5, scope: !19)
!152 = !DILocation(line: 77, column: 12, scope: !19)
!153 = !DILocation(line: 77, column: 16, scope: !19)
!154 = !DILocation(line: 78, column: 22, scope: !19)
!155 = !DILocation(line: 78, column: 5, scope: !19)
!156 = !DILocation(line: 78, column: 12, scope: !19)
!157 = !DILocation(line: 78, column: 16, scope: !19)
!158 = !DILocation(line: 79, column: 22, scope: !19)
!159 = !DILocation(line: 79, column: 5, scope: !19)
!160 = !DILocation(line: 79, column: 12, scope: !19)
!161 = !DILocation(line: 79, column: 16, scope: !19)
!162 = !DILocation(line: 80, column: 1, scope: !19)
!163 = distinct !DISubprogram(name: "_hal_init", scope: !3, file: !3, line: 82, type: !164, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!164 = !DISubroutineType(types: !165)
!165 = !{null, !10, !10}
!166 = !DILocalVariable(name: "inuri", arg: 1, scope: !163, file: !3, line: 82, type: !10)
!167 = !DILocation(line: 82, column: 22, scope: !163)
!168 = !DILocalVariable(name: "outuri", arg: 2, scope: !163, file: !3, line: 82, type: !10)
!169 = !DILocation(line: 82, column: 35, scope: !163)
!170 = !DILocation(line: 84, column: 14, scope: !163)
!171 = !DILocation(line: 84, column: 3, scope: !163)
!172 = !DILocation(line: 85, column: 15, scope: !163)
!173 = !DILocation(line: 85, column: 3, scope: !163)
!174 = !DILocation(line: 86, column: 3, scope: !163)
!175 = !DILocation(line: 87, column: 3, scope: !163)
!176 = !DILocation(line: 88, column: 3, scope: !163)
!177 = !DILocation(line: 89, column: 3, scope: !163)
!178 = !DILocation(line: 90, column: 1, scope: !163)
!179 = distinct !DISubprogram(name: "_wrapper_nxtrpc", scope: !3, file: !3, line: 93, type: !180, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!180 = !DISubroutineType(types: !181)
!181 = !{!6, !6}
!182 = !DILocalVariable(name: "tag", arg: 1, scope: !179, file: !3, line: 93, type: !6)
!183 = !DILocation(line: 93, column: 1, scope: !179)
!184 = !DILocation(line: 93, column: 1, scope: !185)
!185 = distinct !DILexicalBlock(scope: !179, file: !3, line: 93, column: 1)
!186 = distinct !{!186, !183, !183}
!187 = distinct !DISubprogram(name: "_wrapper_requesta", scope: !3, file: !3, line: 94, type: !180, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!188 = !DILocalVariable(name: "tag", arg: 1, scope: !187, file: !3, line: 94, type: !6)
!189 = !DILocation(line: 94, column: 1, scope: !187)
!190 = !DILocation(line: 94, column: 1, scope: !191)
!191 = distinct !DILexicalBlock(scope: !187, file: !3, line: 94, column: 1)
!192 = distinct !{!192, !189, !189}
!193 = distinct !DISubprogram(name: "_slave_rpc_loop", scope: !3, file: !3, line: 96, type: !194, scopeLine: 96, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!194 = !DISubroutineType(types: !195)
!195 = !{!35}
!196 = !DILocalVariable(name: "n_tag", scope: !193, file: !3, line: 97, type: !23)
!197 = !DILocation(line: 97, column: 12, scope: !193)
!198 = !DILocalVariable(name: "tid", scope: !193, file: !3, line: 98, type: !199)
!199 = !DICompositeType(tag: DW_TAG_array_type, baseType: !200, size: 128, elements: !203)
!200 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !201, line: 27, baseType: !202)
!201 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!202 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!203 = !{!204}
!204 = !DISubrange(count: 2)
!205 = !DILocation(line: 98, column: 13, scope: !193)
!206 = !DILocation(line: 99, column: 3, scope: !193)
!207 = !DILocation(line: 100, column: 19, scope: !193)
!208 = !DILocation(line: 100, column: 50, scope: !193)
!209 = !DILocation(line: 100, column: 3, scope: !193)
!210 = !DILocation(line: 101, column: 19, scope: !193)
!211 = !DILocation(line: 101, column: 52, scope: !193)
!212 = !DILocation(line: 101, column: 3, scope: !193)
!213 = !DILocalVariable(name: "i", scope: !214, file: !3, line: 102, type: !35)
!214 = distinct !DILexicalBlock(scope: !193, file: !3, line: 102, column: 3)
!215 = !DILocation(line: 102, column: 12, scope: !214)
!216 = !DILocation(line: 102, column: 8, scope: !214)
!217 = !DILocation(line: 102, column: 19, scope: !218)
!218 = distinct !DILexicalBlock(scope: !214, file: !3, line: 102, column: 3)
!219 = !DILocation(line: 102, column: 21, scope: !218)
!220 = !DILocation(line: 102, column: 3, scope: !214)
!221 = !DILocation(line: 102, column: 53, scope: !218)
!222 = !DILocation(line: 102, column: 49, scope: !218)
!223 = !DILocation(line: 102, column: 36, scope: !218)
!224 = !DILocation(line: 102, column: 32, scope: !218)
!225 = !DILocation(line: 102, column: 3, scope: !218)
!226 = distinct !{!226, !220, !227}
!227 = !DILocation(line: 102, column: 61, scope: !214)
!228 = !DILocation(line: 103, column: 3, scope: !193)
!229 = !{!230}
!230 = !{i64 2, i64 3, i1 false}
