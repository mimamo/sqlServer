USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_Check_For_reversal]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARAdjust_Check_For_reversal]  @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 10) ,@parm4 varchar (15)  as
SELECT *
  FROM ARAdjust
 WHERE CustId = @parm4
   AND Adjdrefnbr = @parm2
   AND AdjgRefNbr = @parm3
   AND AdjBatnbr = @parm1
   AND AdjgDocType IN ('RP','NS')
GO
