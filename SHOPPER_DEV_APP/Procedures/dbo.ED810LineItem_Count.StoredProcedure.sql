USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_Count]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810LineItem_Count] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select Count(*) From ED810LineItem Where CpnyId = @CpnyId And EDIInvId = @EDIInvId
GO
