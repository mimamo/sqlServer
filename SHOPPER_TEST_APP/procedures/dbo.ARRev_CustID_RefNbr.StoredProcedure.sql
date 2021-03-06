USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_CustID_RefNbr]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_CustID_RefNbr    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROC [dbo].[ARRev_CustID_RefNbr] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(10) AS
SELECT *
  FROM ARDoc
 WHERE CpnyId = @parm1
   AND CustID = @parm2
   AND refnbr  = @parm3
   AND Rlsed = 1
   AND Doctype IN ('PA','PP','CM','SB')
ORDER BY Doctype
GO
