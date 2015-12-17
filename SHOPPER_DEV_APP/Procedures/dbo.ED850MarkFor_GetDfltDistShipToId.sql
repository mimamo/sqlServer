USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850MarkFor_GetDfltDistShipToId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850MarkFor_GetDfltDistShipToId] @CpnyId varchar(10), @EDIPOID varchar(10), @CustId varchar(15) As
Select DistCenterShipToId From EDSTCustomer Where CustId = @CustId And ShipToId In (Select ShipToId From ED850MarkFor Where
CpnyId = @CpnyId And EDIPOID = @EDIPOID)
GO
