let main_bin_file () =
  "#include <stdio.h>\n\n\
   int main(void) {\n\
  \    printf(\"hello world\\n\");\n\
  \    return 0;\n\
   }"
;;

let main_lib_file () = "int add(int a, int b) {\n    return a + b;\n}"

let main_lib_header name =
  let upper = String.uppercase_ascii name in
  let fmt =
    format_of_string
      "#ifndef __%s_H__\n\
       #define __%s_H__\n\n\
       int add(int a, int b);\n\n\
       #endif /*__%s_H__*/"
  in
  Printf.sprintf fmt upper upper upper
;;
