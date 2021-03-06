USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyId_Rlsed5]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyId_Rlsed5    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_CpnyId_Rlsed5] @parm1 varchar ( 15), @parm2 varchar ( 10) As
Select * from ARDoc, Currncy
Where ARDoc.CuryId = Currncy.CuryId and
ARDoc.CustId = @parm1 and
ARDoc.cpnyID = @parm2 and
ARDoc.DocType = "PP"  and
ARDoc.curyDocBal <> 0 and
ARDoc.Rlsed = 1
Order by CustId, DocDate DESC
GO
