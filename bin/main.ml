type project_type =
  | Binary
  | Library

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

let create_main_cmake name binary_type =
  match binary_type with
  | Binary -> Cmake.bin_main_cmake_file name |> Printf.printf "%s\n"
  | Library -> Cmake.lib_main_cmake_file name |> Printf.printf "%s\n"
;;

let create_main_file name binary_type =
    match binary_type with
    | Binary -> Src.main_bin_file () |> Printf.printf "%s\n"
    | Library ->
            Src.main_lib_file () |> Printf.printf "%s\n";
            Src.main_lib_header name |> Printf.printf "%s\n";
;;

let () =
  let name =
    match read_project_name () with
    | Some n -> n
    | None ->
      Printf.printf "Invalid name\n";
      exit 1
  in
  let project_type =
    match get_project_type () with
    | Some pt -> pt
    | None ->
      Printf.printf "no type\n";
      exit 1
  in
  create_main_cmake name project_type;
  create_main_file name project_type;
;;
