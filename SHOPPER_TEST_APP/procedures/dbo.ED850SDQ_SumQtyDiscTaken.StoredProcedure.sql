USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_SumQtyDiscTaken]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_SumQtyDiscTaken] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select Sum(Qty) From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
And DiscTaken = 1
GO
