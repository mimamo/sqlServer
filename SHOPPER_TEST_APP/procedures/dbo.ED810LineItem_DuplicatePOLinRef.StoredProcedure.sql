USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_DuplicatePOLinRef]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810LineItem_DuplicatePOLinRef] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select POLineRef From ED810LineItem Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And
POLineRef <> '' Group By CpnyId, EDIInvId, POLineRef Having Count(*) > 1
GO
