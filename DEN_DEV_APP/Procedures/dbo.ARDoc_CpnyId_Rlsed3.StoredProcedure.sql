USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyId_Rlsed3]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyId_Rlsed3    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_CpnyId_Rlsed3] @parm1 varchar (15), @parm2 varchar (6), @parm3 varchar ( 10) As

SELECT *
  FROM ARDoc, Currncy
 WHERE ARDoc.CuryId = Currncy.CuryId
   AND ARDoc.CustId = @parm1
   AND ARDoc.DocType <> 'AD'
   AND ARdoc.PerPost <= @parm2
   AND ARDoc.cpnyID = @parm3
   AND ARDoc.curyDocBal <> 0
   AND ARDoc.Rlsed = 1
ORDER BY CustId, DocDate DESC
GO
