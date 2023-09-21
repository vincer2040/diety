type project_type =
  | Binary
  | Library

type project_language =
  | C
  | Cpp

let read_project_name () =
  Printf.printf "enter the project name: ";
  try
    let line = read_line () in
    match line with
    | "" -> None
    | _ -> Some line
  with
  | _ -> None
;;

let get_project_language () =
  Printf.printf "1. C\n2. C++\nendter the project language (1- 2, default 1): ";
  try
    let line = read_line () in
    match line with
    | "1" -> Some C
    | "2" -> Some Cpp
    | "" -> Some C
    | _ -> None
  with
  | _ -> None
;;

let get_project_type () =
  Printf.printf "1. bin\n2. lib\nenter the project type (1-2, default 1): ";
  try
    let line = read_line () in
    match line with
    | "1" -> Some Binary
    | "2" -> Some Library
    | "" -> Some Binary
    | _ -> None
  with
  | _ -> None
;;

let create_main_cmake name binary_type language path =
  let channel = open_out path in
  (match binary_type with
   | Binary ->
     let file_contents =
       match language with
       | C -> Cmake.bin_c_main_cmake_file name
       | Cpp -> Cmake.bin_cpp_main_cmake_file name
     in
     file_contents |> output_string channel
   | Library ->
     let file_contents =
       match language with
       | C -> Cmake.lib_c_main_cmake_file name
       | Cpp -> Cmake.lib_cpp_main_cmake_file name
     in
     file_contents |> output_string channel);
  close_out channel
;;

let create_main_file name binary_type language file_path hdr_path =
  let file_channel = open_out file_path in
  (match binary_type with
   | Binary ->
     let file_contents =
       match language with
       | C -> Src.main_c_bin_file ()
       | Cpp -> Src.main_cpp_bin_file ()
     in
     file_contents |> output_string file_channel
   | Library ->
     let hdr_channel = open_out hdr_path in
     Src.main_lib_file () |> output_string file_channel;
     Src.main_lib_header name |> output_string hdr_channel;
     close_out hdr_channel);
  close_out file_channel
;;

let create_test_cmake name binary_type language path =
  let channel = open_out path in
  (match binary_type with
   | Binary ->
     let file_contents =
       match language with
       | C -> Cmake.test_c_bin_cmake_file name
       | Cpp -> Cmake.test_cpp_bin_cmake_file name
     in
     file_contents |> output_string channel
   | Library ->
     let file_contents =
       match language with
       | C -> Cmake.test_c_lib_cmake_file name
       | Cpp -> Cmake.test_cpp_lib_cmake_file name
     in
     file_contents |> output_string channel);
  close_out channel
;;

let create_test_file name binary_type language path =
  let channel = open_out path in
  (match binary_type with
   | Binary ->
     let file_contents =
       match language with
       | C -> Src.bin_c_test_file name
       | Cpp -> Src.bin_cpp_test_file ()
     in
     file_contents |> output_string channel
   | Library ->
     let file_contents =
       match language with
       | C -> Src.lib_c_test_file name
       | Cpp -> Src.lib_cpp_test_file name
     in
     file_contents |> output_string channel);
  close_out channel
;;

let create_dir name =
  try
    let src_dir_fmt = format_of_string "%s/src" in
    let tests_dir_fmt = format_of_string "%s/tests" in
    let src_dir = Printf.sprintf src_dir_fmt name in
    let test_dir = Printf.sprintf tests_dir_fmt name in
    if not (Sys.file_exists name) then Sys.mkdir name 0o755;
    if not (Sys.file_exists src_dir) then Sys.mkdir src_dir 0o755;
    if not (Sys.file_exists test_dir) then Sys.mkdir test_dir 0o755
  with
  | Sys_error _ ->
    Printf.printf "failed to create directory %s\n" name;
    exit 1
;;

let create_gitignore path =
  let channel = open_out path in
  output_string channel "build";
  close_out channel
;;

let create_clang_format path =
  let channel = open_out path in
  Cmake.clang_format_file () |> output_string channel;
  close_out channel
;;

let init name language binary_type =
  let main_cmake_path_fmt = format_of_string "%s/CMakeLists.txt" in
  let clang_format_path_fmt = format_of_string "%s/.clang-format" in
  let gitignore_path_fmt = format_of_string "%s/.gitignore" in
  let test_cmake_path_fmt = format_of_string "%s/tests/CMakeLists.txt" in
  let src_path_fmt =
    match language with
    | C -> format_of_string "%s/src/%s.c"
    | Cpp -> format_of_string "%s/src/%s.cc"
  in
  let hdr_path_fmt =
    match language with
    | C -> format_of_string "%s/src/%s.h"
    | Cpp -> format_of_string "%s/src/%s.hh"
  in
  let test_path_fmt =
    match language with
    | C -> format_of_string "%s/tests/%s_test.c"
    | Cpp -> format_of_string "%s/tests/%s_test.cc"
  in
  create_dir name;
  Printf.sprintf clang_format_path_fmt name |> create_clang_format;
  create_gitignore (Printf.sprintf gitignore_path_fmt name);
  Printf.sprintf main_cmake_path_fmt name
  |> create_main_cmake name binary_type language;
  Printf.sprintf test_cmake_path_fmt name
  |> create_test_cmake name binary_type language;
  create_main_file
    name
    binary_type
    language
    (Printf.sprintf src_path_fmt name name)
    (Printf.sprintf hdr_path_fmt name name);
  Printf.sprintf test_path_fmt name name
  |> create_test_file name binary_type language;
  match binary_type with
  | Binary -> Printf.printf "initialized binary project in %s\n" name
  | Library -> Printf.printf "initialized library project in %s\n" name
;;

let () =
  let name =
    match read_project_name () with
    | Some n -> n
    | None ->
      Printf.printf "Invalid name\n";
      exit 1
  in
  let project_lang =
    match get_project_language () with
    | Some l -> l
    | None ->
      Printf.printf "no language\n";
      exit 1
  in
  let binary_type =
    match get_project_type () with
    | Some pt -> pt
    | None ->
      Printf.printf "no type\n";
      exit 1
  in
  init name project_lang binary_type
;;
