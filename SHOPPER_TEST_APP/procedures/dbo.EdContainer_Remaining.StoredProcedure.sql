USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EdContainer_Remaining]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EdContainer_Remaining] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And LabelLastPrinted = '1900-01-01'
GO
