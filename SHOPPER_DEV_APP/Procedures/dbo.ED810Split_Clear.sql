USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Split_Clear]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Split_Clear] @Cpnyid varchar(10), @EDIInvId varchar(10), @LineId int As
Delete From ED810Split Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And LineId = @LineId
GO
