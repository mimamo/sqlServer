USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_GetDfltDistShipToId]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_GetDfltDistShipToId] @CpnyId varchar(10), @EDIPOID varchar(10), @CustId varchar(15) As
Select DistCenterShipToId From EDSTCustomer Where CustId = @CustId And ShipToId In (Select SolShipToId From ED850SDQ Where
CpnyId = @CpnyId And EDIPOID = @EDIPOID)
GO
