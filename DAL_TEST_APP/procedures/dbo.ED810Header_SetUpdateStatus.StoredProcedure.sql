USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_SetUpdateStatus]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_SetUpdateStatus] @CpnyId varchar(10), @EDIInvId varchar(10), @UpdateStatus varchar(2) As
Update ED810Header Set UpdateStatus = @UpdateStatus Where CpnyId = @CpnyId And EDIInvId = @EDIInvId
GO
