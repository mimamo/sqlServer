USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810HeaderExt_AllDMG]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810HeaderExt_AllDMG] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select * From ED810HeaderExt Where CpnyId = @CpnyId And EDIInvId = @EDIInvId Order By CpnyId, EDIInvId
GO
