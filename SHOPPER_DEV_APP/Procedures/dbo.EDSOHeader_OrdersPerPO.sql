USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_OrdersPerPO]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_OrdersPerPO] @EDIPOID varchar(10) As
Select Count(*) From SOHeader Where EDIPOID = @EDIPOID And Cancelled = 0
GO
