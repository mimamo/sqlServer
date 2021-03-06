USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipMark_EdiRef]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipMark_EdiRef] @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.Addr1, A.Addr2, A.Name1, A.Name2, A.Name3, A.City, A.State, A.Zip, A.Country, A.MarkForId,
A.Attn, B.EDIShipToRef From SOShipMark A Left Outer Join EDSTCustomer B On A.CustId = B.CustId
And A.MarkForId = B.ShipToId Where A.CpnyId = @CpnyId And A.ShipperId = @ShipperId
GO
