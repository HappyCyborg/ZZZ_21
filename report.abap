REPORT zzz_21.

*  Selection screen
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(33) gv_comm FOR FIELD p_digits.
PARAMETERS p_digits TYPE n DEFAULT 4.
SELECTION-SCREEN END OF LINE.

*  Classes
CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.

    METHODS:
      main IMPORTING iv_digits TYPE n
                     iv_sum    TYPE i DEFAULT 21.
ENDCLASS.
CLASS lcl_report IMPLEMENTATION.
  METHOD main.
    DATA lv_number_min TYPE string VALUE '100000000'.
    DATA lv_number_max TYPE string VALUE '999999999'.
    DATA lv_number TYPE string.

    "Get min and max possible values to get start value and to count number of iterations
    lv_number_min = lv_number_min(iv_digits).
    lv_number_max = lv_number_max(iv_digits).

    lv_number = lv_number_min.

    DO lv_number_max - lv_number_min + 1 TIMES.
      DATA(lv_offset) = VALUE i( ).
      DATA(lv_sum) = VALUE i( ).
      "Get sum of numbers in each digit
      DO iv_digits TIMES.
        lv_sum = lv_sum + lv_number+lv_offset(1).
        lv_offset = lv_offset + 1.
      ENDDO.
      "Print satisfying numbers
      IF lv_sum = iv_sum.
        WRITE / lv_number.
      ENDIF.
      lv_number = lv_number + 1.
    ENDDO.
  ENDMETHOD.
ENDCLASS.

*  Events
AT SELECTION-SCREEN OUTPUT.
  gv_comm = 'Длина номерного знака'.

AT SELECTION-SCREEN ON p_digits.
  IF p_digits < 3 OR p_digits > 5.
    MESSAGE 'Введите значение в диапазоне от 3 до 5' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  NEW lcl_report( )->main( p_digits ).
