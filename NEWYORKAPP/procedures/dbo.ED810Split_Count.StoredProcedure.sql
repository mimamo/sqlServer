USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Split_Count]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Split_Count] @CpnyId varchar(10), @EDIInvId varchar(10), @LineId int As
Select Count(*) From ED810Split Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And LineId = @LineId
GO
