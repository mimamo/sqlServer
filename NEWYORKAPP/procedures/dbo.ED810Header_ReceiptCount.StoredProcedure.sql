USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_ReceiptCount]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_ReceiptCount] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select Count(*) From POReceipt Where CpnyId = @CpnyId And S4Future11 = @EDIInvId
GO
