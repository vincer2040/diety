let lib_c_main_cmake_file name =
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

let bin_c_main_cmake_file name =
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

let test_c_bin_cmake_file name =
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

let test_c_lib_cmake_file name =
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

let lib_cpp_main_cmake_file name =
  let fmt =
    format_of_string
      "cmake_minimum_required(VERSION 3.11)\n\n\
       project(%s)\n\n\
       set(CMAKE_CXX_STANDARD 17)\n\
       set(CMAKE_CXX_STANDARD_REQUIRED ON)\n\n\
       set(CMAKE_CXX_FLAGS_DEBUG \"${CMAKE_CXX_FLAGS_DEBUG} -Wall -Werror \
       -pedantic -fstack-clash-protection \\\n\
       -fstack-protector-all -fstack-protector-strong -Werror=format-security \
       -Werror=implicit-function-declaration -pipe -O2\")\n\n\
       set(CMAKE_CXX_FLAGS_RELEASE \"-Wall -Werror -pedantic \
       -fstack-clash-protection -fstack-protector-all \\\n\
       -fstack-protector-strong -Werror=format-security \
       -Werror=implicit-function-declaration -pipe -O2 -s -DNDEBUG\")\n\n\
       enable_testing()\n\
       add_subdirectory(tests)\n\n\
       add_library(%s src/%s.cc)\n"
  in
  Printf.sprintf fmt name name name
;;

let bin_cpp_main_cmake_file name =
  let fmt =
    format_of_string
      "cmake_minimum_required(VERSION 3.11)\n\n\
       project(%s)\n\n\
       set(CMAKE_CXX_STANDARD 17)\n\
       set(CMAKE_CXX_STANDARD_REQUIRED ON)\n\n\
       set(CMAKE_CXX_FLAGS_DEBUG \"${CMAKE_CXX_FLAGS_DEBUG} -Wall -Werror \
       -pedantic -fstack-clash-protection \\\n\
       -fstack-protector-all -fstack-protector-strong -Werror=format-security \
       -Werror=implicit-function-declaration -pipe -O2\")\n\n\
       set(CMAKE_CXX_FLAGS_RELEASE \"-Wall -Werror -pedantic \
       -fstack-clash-protection -fstack-protector-all \\\n\
       -fstack-protector-strong -Werror=format-security \
       -Werror=implicit-function-declaration -pipe -O2 -s -DNDEBUG\")\n\n\
       enable_testing()\n\
       add_subdirectory(tests)\n\n\
       add_executable(%s src/%s.cc)\n"
  in
  Printf.sprintf fmt name name name
;;

let test_cpp_lib_cmake_file name =
  let fmt =
    format_of_string
      "include(FetchContent)\n\
       FetchContent_Declare(\n\
      \    googletest\n\
      \    URL     \
       https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip\n\
      \    DOWNLOAD_EXTRACT_TIMESTAMP true  # Specify the option here\n\
       )\n\n\
       set(gtest_force_shared_crt ON CACHE BOOL \"\" FORCE)\n\
       FetchContent_MakeAvailable(googletest)\n\
       add_executable(\n\
      \   %s_test\n\
      \   %s_test.cc\n\
       )\n\n\
       target_link_libraries(\n\
      \    %s_test\n\
      \    GTest::gtest_main\n\
      \    %s\n\
       )\n\
       include(GoogleTest)\n\
       gtest_discover_tests(%s_test)\n"
  in
  Printf.sprintf fmt name name name name name
;;

let test_cpp_bin_cmake_file name =
  let fmt =
    format_of_string
      "include(FetchContent)\n\
       FetchContent_Declare(\n\
      \    googletest\n\
      \    URL     \
       https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip\n\
      \    DOWNLOAD_EXTRACT_TIMESTAMP true  # Specify the option here\n\
       )\n\n\
       set(gtest_force_shared_crt ON CACHE BOOL \"\" FORCE)\n\
       FetchContent_MakeAvailable(googletest)\n\
       add_executable(\n\
      \   %s_test\n\
      \   %s_test.cc\n\
       )\n\n\
       target_link_libraries(\n\
      \    %s_test\n\
      \    GTest::gtest_main\n\
       )\n\n\
      \       include(GoogleTest)\n\
       gtest_discover_tests(%s_test)\n"
  in
  Printf.sprintf fmt name name name name
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
