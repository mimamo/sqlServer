USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Split_Clear]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Split_Clear] @Cpnyid varchar(10), @EDIInvId varchar(10), @LineId int As
Delete From ED810Split Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And LineId = @LineId
GO
