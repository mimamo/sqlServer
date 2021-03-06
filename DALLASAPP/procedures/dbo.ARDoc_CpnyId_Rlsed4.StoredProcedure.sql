USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyId_Rlsed4]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyId_Rlsed4    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROCEDURE [dbo].[ARDoc_CpnyId_Rlsed4] @parm1 VARCHAR ( 15), @parm2 VARCHAR ( 10) , @parm3 VARCHAR ( 6) AS
SELECT *
  FROM ARDoc, Currncy
 WHERE ARDoc.CuryId = Currncy.CuryId AND
       ARDoc.CustId = @parm1 AND
       ARDoc.cpnyID = @parm2 AND
       ARDoc.DocType <> 'AD' AND
       ARDoc.curyDocBal <> 0 AND
       ARDoc.Rlsed = 1	AND
       PerPost > @parm3
 ORDER BY CustId, DocDate DESC
GO
