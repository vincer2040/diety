let main_c_bin_file () =
  "#include <stdio.h>\n\n\
   int main(void) {\n\
  \    printf(\"hello world\\n\");\n\
  \    return 0;\n\
   }"
;;

let main_cpp_bin_file () =
  "#include <iostream>\n\n\
   int main(void) {\n\
  \   std::cout << \"hello world\" << \"\\n\";\n\
  \   return 0;\n\
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

let lib_c_test_file name =
  let fmt =
    format_of_string
      "#include \"../src/%s.h\"\n\
       #include <check.h>\n\
       #include <stdint.h>\n\
       #include <stdio.h>\n\
       #include <stdlib.h>\n\
       #include <string.h>\n\n\n\
       START_TEST(test_it_works) {\n\
      \    ck_assert_int_eq(add(1, 1), 2);\n\
       }\n\
       END_TEST\n\n\
       Suite* ht_suite() {\n\
      \    Suite* s;\n\
      \    TCase* tc_core;\n\
      \    s = suite_create(\"%s_test\");\n\
      \    tc_core = tcase_create(\"Core\");\n\
      \    tcase_add_test(tc_core, test_it_works);\n\
      \    suite_add_tcase(s, tc_core);\n\
      \    return s;\n\
       }\n\n\
       int main() {\n\
      \    int number_failed;\n\
      \    Suite* s;\n\
      \    SRunner* sr;\n\
      \    s = ht_suite();\n\
      \    sr = srunner_create(s);\n\
      \    srunner_run_all(sr, CK_NORMAL);\n\
      \    number_failed = srunner_ntests_failed(sr);\n\
      \    srunner_free(sr);\n\
      \    return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;\n\
       }"
  in
  Printf.sprintf fmt name name
;;

let bin_c_test_file name =
  let fmt =
    format_of_string
      "#include <check.h>\n\
       #include <stdint.h>\n\
       #include <stdio.h>\n\
       #include <stdlib.h>\n\
       #include <string.h>\n\n\n\
       START_TEST(test_it_works) {\n\
      \    ck_assert_int_eq(1, 1);\n\
       }\n\
       END_TEST\n\n\
       Suite* ht_suite() {\n\
      \    Suite* s;\n\
      \    TCase* tc_core;\n\
      \    s = suite_create(\"%s_test\");\n\
      \    tc_core = tcase_create(\"Core\");\n\
      \    tcase_add_test(tc_core, test_it_works);\n\
      \    suite_add_tcase(s, tc_core);\n\
      \    return s;\n\
       }\n\n\
       int main() {\n\
      \    int number_failed;\n\
      \    Suite* s;\n\
      \    SRunner* sr;\n\
      \    s = ht_suite();\n\
      \    sr = srunner_create(s);\n\
      \    srunner_run_all(sr, CK_NORMAL);\n\
      \    number_failed = srunner_ntests_failed(sr);\n\
      \    srunner_free(sr);\n\
      \    return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;\n\
       }"
  in
  Printf.sprintf fmt name
;;

let lib_cpp_test_file name =
  let fmt =
    format_of_string
      "#include \"../src/%s.hh\"\n\
       #include <gtest/gtest.h>\n\n\
       TEST(AddTest, SimpleAssertions) {\n\
      \   EXPECT_EQ(add(1, 1), 2);\n\
       }"
  in
  Printf.sprintf fmt name
;;

let bin_cpp_test_file () =
  "#include <gtest/gtest.h>\n\n\
   TEST(AddTest, SimpleAssertions) {\n\
  \   EXPECT_EQ(1, 1);\n\
   }"
;;
