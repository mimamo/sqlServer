USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_OrdersForEDIPO]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_OrdersForEDIPO] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select OrdNbr From SOHeader Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
