let lib_main_cmake_file name =
  let fmt =
    format_of_string
      "cmake_minimum_required(VERSION 3.10)\n\n\
       project(%s VERSION 0.1)\n\n\
       enable_testing()\n\n\
       add_subdirectory(tests)\n\
       set(INSTALL_PREFIX \"/usr/local\")\n\n\
       set(CMAKE_C_COMPILER \"gcc\")\n\n\
       set(CMAKE_C_FLAGS_DEBUG \"${CMAKE_C_FLAGS_DEBUG} -std=c99 -Wall -Werror \
       -pedantic -fstack-clash-protection -fstack-protector-all \
       -fstack-protector-strong -Werror=format-security \
       -Werror=implicit-function-declaration -pipe -O2\")\n\n\
       set(CMAKE_C_FLAGS_RELEASE \"-std=c99 -Wall -Werror -pedantic \
       -fstack-clash-protection -fstack-protector-all -fstack-protector-strong \
       -Werror=format-security -Werror=implicit-function-declaration -pipe -O2 \
       -s -DNDEBUG\")\n\n\
       add_library(%s src/%s.c)\n\n\
       install(FILES build/lib%s.a DESTINATION \"${INSTALL_PREFIX}/lib\")\n\
       install(FILES src/%s.h DESTINATION \"${INSTALL_PREFIX}/include\")"
  in
  Printf.sprintf fmt name name name name name
;;

let bin_main_cmake_file name =
  let fmt =
    format_of_string
      "cmake_minimum_required(VERSION 3.10)\n\n\
       project(%s VERSION 0.1)\n\n\
       enable_testing()\n\n\
       add_subdirectory(tests)\n\
       set(INSTALL_PREFIX \"/usr/local\")\n\n\
       set(CMAKE_C_COMPILER \"gcc\")\n\n\
       set(CMAKE_C_FLAGS_DEBUG \"${CMAKE_C_FLAGS_DEBUG} -std=c99 -Wall -Werror \
       -pedantic -fstack-clash-protection -fstack-protector-all \
       -fstack-protector-strong -Werror=format-security \
       -Werror=implicit-function-declaration -pipe -O2\")\n\n\
       set(CMAKE_C_FLAGS_RELEASE \"-std=c99 -Wall -Werror -pedantic \
       -fstack-clash-protection -fstack-protector-all -fstack-protector-strong \
       -Werror=format-security -Werror=implicit-function-declaration -pipe -O2 \
       -s -DNDEBUG\")\n\n\
       add_executable(%s src/%s.c)\n\n\
       install(FILES build/%s DESTINATION \"${INSTALL_PREFIX}/bin\")"
  in
  Printf.sprintf fmt name name name name
;;

let test_bin_cmake_file name =
  let fmt =
    format_of_string
      "add_executable(%s_test %s_test.c)\n\n\
       target_link_libraries(%s_test PUBLIC check pthread)\n\n\
       target_include_directories(%s_test PUBLIC \"${PROJECT_BINARY_DIR}\")\n\n\
       add_test(NAME %s_test COMMAND %s_test WORKING_DIRECTORY \
       ${CMAKE_BINARY_DIR}/Testing)\n\
       set_tests_properties(%s_test PROPERTIES TIMEOUT 30)"
  in
  Printf.sprintf fmt name name name name name name name
;;

let test_lib_cmake_file name =
  let fmt =
    format_of_string
      "add_executable(%s_test ../src/%s.c %s_test.c)\n\n\
       target_link_libraries(%s_test PUBLIC check pthread)\n\n\
       target_include_directories(%s_test PUBLIC \"${PROJECT_BINARY_DIR}\")\n\n\
       add_test(NAME %s_test COMMAND %s_test WORKING_DIRECTORY \
       ${CMAKE_BINARY_DIR}/Testing)\n\
       set_tests_properties(%s_test PROPERTIES TIMEOUT 30)"
  in
  Printf.sprintf fmt name name name name name name name name
;;

let clang_format_file () =
  "# SPDX-License-Identifier: GPL-2.0\n\
   #\n\
   # clang-format configuration file. Intended for clang-format >= 11.\n\
   #\n\
   # For more information, see:\n\
   #\n\
   #   Documentation/process/clang-format.rst\n\
   #   https://clang.llvm.org/docs/ClangFormat.html\n\
   #   https://clang.llvm.org/docs/ClangFormatStyleOptions.html\n\
   #\n\
   ---\n\
   # We'll use defaults from the LLVM style, but with 4 columns indentation.\n\
   BasedOnStyle: LLVM\n\
   PointerAlignment: Left\n\
   IndentWidth: 4\n\
   ..."
;;
