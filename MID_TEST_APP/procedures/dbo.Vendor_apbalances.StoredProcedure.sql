USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_apbalances]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Vendor_apbalances] @parm1 varchar(15), @parm2 varchar(10), @parm3 varChar(1) AS

Select V.*, A.*
FROM Vendor V JOIN AP_Balances A 
              ON V.Vendid = A.Vendid
WHERE V.Vendid LIKE @Parm1 AND
      A.CpnyID = @Parm2 AND
      V.Vend1099 = '1' AND
      V.Vendid <> '' AND
      (SELECT CASE @Parm3 WHEN 'C'  
                  THEN A.CYBox00 + A.CYBox01 + A.CYBox02 + A.CYBox03 + A.CYBox04 + A.CYBox05 +
                       A.CYBox06 + A.CYBox07 + A.CYBox08 + A.CYBox09 + A.CYBox10 + A.CYBox11 + A.CYBox12 + A.s4future03 + A.s4future04 
                  ELSE A.NYBox00 + A.NYBox01 + A.NYBox02 + A.NYBox03 + A.NYBox04 + A.NYBox05 +
                       A.NYBox06 + A.NYBox07 + A.NYBox08 + A.NYBox09 + A.NYBox10 + A.NYBox11 + A.NYBox12 + A.s4future05 + A.s4future06  
                  END) <> 0
ORDER BY V.Vendid
GO
