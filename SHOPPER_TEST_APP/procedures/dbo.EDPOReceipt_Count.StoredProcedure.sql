USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPOReceipt_Count]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPOReceipt_Count] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select Count(*) From POReceipt Where CpnyId = @CpnyId And S4Future11 = @EDIInvId
GO
