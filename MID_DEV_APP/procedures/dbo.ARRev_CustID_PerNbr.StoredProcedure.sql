USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_CustID_PerNbr]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_CustID_PerNbr    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROC [dbo].[ARRev_CustID_PerNbr] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(6), @parm4 varchar (6) AS
SELECT *
  FROM ARDoc
 WHERE CpnyId = @parm1
   AND CustID = @parm2
   AND PerPost >= @parm3
   AND PerPost <= @parm4
   AND Rlsed = 1
   AND Doctype IN ('PA','PP','CM','SB')
ORDER BY CustID,  Refnbr
GO
