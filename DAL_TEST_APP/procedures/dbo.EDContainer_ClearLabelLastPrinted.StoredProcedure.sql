USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_ClearLabelLastPrinted]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_ClearLabelLastPrinted] @CpnyId varchar(10), @ShipperId varchar(15) As
Update EDContainer Set LabelLastPrinted = '01/01/1900' Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
