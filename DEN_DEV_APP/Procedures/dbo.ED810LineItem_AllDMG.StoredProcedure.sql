USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_AllDMG]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810LineItem_AllDMG] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select * From ED810LineItem Where CpnyId = @CpnyId And EDIInvId = @EDIInvId Order By
CpnyId, EDIInvId, LineId
GO
