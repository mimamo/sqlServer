USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_GetId]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipVia_GetId] @EDIViaCode varchar(20) As
Select ShipViaId From ShipVia Where EDIViaCode = @EDIViaCode
GO
