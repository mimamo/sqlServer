USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_Delete]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipLot_Delete] @ShipperID varchar(15), @CpnyID varchar(10), @LineRef varchar(5) AS
Delete from soshiplot
where shipperid = @ShipperID
 and cpnyid = @Cpnyid
 and lineref = @LineRef
GO
