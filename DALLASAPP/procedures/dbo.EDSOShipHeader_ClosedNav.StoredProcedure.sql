USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_ClosedNav]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_ClosedNav] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From SOShipHeader Where CpnyId Like @CpnyId And ShipperId Like @ShipperId And
Status = 'C' Order By ShipperId
GO
