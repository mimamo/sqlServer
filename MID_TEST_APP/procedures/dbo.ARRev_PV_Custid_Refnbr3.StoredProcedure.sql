USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_PV_Custid_Refnbr3]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ARRev_PV_Custid_Refnbr3] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(13)
AS
SELECT refnbrtype=rtrim(refnbr) + "-" + rtrim(doctype)
  FROM ARDoc
 WHERE CpnyId = @parm1
   AND CustID = @parm2
   AND refnbr = substring(@parm3, 1, len(@parm3)-3)
   AND doctype like right(@parm3, 2)
   AND Doctype IN ('PA','PP','CM','SB')
   AND Rlsed = 1
Order by Refnbr
GO
