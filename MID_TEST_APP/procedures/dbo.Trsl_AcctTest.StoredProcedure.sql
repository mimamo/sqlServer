USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Trsl_AcctTest]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Trsl_AcctTest] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) As
Select * from FSDefDet
Where TrslId = @parm1
and @parm2 between FSDefDet.BegAcctRange and FSDefDet.EndAcctRange
and @parm3 between FSDefDet.BegSubRange and FSDefDet.EndSubRange
Order by TrslId, BegAcctRange, BegSubRange
GO
