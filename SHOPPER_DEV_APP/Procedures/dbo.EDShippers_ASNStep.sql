USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShippers_ASNStep]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShippers_ASNStep] As
Select CpnyId, ShipperId From SOShipHeader Where NextFunctionId = '5040200' And Cancelled = 0
GO
