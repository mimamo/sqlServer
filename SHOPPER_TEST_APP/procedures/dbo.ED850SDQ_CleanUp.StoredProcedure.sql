USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_CleanUp]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_CleanUp] @CpnyId varchar(10), @EDIPOID varchar(10) As
Delete From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And Qty = 0
GO
