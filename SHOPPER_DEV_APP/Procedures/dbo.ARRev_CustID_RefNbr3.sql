USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_CustID_RefNbr3]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ARRev_CustID_RefNbr3] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(10), @parm4 varchar(2) AS
SELECT *
  FROM ARDoc
 WHERE CpnyId = @parm1
   AND CustID = @parm2
   AND refnbr  = @parm3
   AND Rlsed = 1
   AND Doctype like @parm4
   AND Doctype IN ('PA','PP','CM','SB')

ORDER BY Doctype
GO
