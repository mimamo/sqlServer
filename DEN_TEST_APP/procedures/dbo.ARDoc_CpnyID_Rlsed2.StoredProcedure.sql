USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyID_Rlsed2]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyID_Rlsed2    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_CpnyID_Rlsed2] @parm1 varchar ( 15), @parm2 varchar ( 10) As
Select * from ARDoc, Currncy
Where ARDoc.CuryId = Currncy.CuryId and
ARDoc.CustId = @parm1 and
ARDoc.CpnyID = @parm2 and
(ARDoc.curyDocBal <> 0 or ARDoc.CurrentNbr = 1) and
ARDoc.Rlsed = 1
Order by CustId, DocDate DESC
GO
