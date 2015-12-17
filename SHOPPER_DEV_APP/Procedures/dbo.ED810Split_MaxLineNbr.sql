USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Split_MaxLineNbr]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Split_MaxLineNbr] @CpnyId varchar(10), @EDIInvId varchar(10), @LineId int As
Select Max(LineNbr) From ED810Split Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And LineId = @LineId
GO
