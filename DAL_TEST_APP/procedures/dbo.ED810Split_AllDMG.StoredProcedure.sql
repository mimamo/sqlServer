USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Split_AllDMG]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Split_AllDMG] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select * From ED810Split Where CpnyId = @CpnyId And EDIInvId = @EDIInvId
Order By CpnyId, EDIInvId, LineId, LineNbr
GO
