USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EdContainer_Remaining]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EdContainer_Remaining] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And LabelLastPrinted = '1900-01-01'
GO
