USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_SetAdminHold]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SOShipHeader_SetAdminHold]
	@CpnyID varchar(10),
	@ShipperID varchar(15),
	@AdminSet smallint 
AS
Update SOShipHeader
Set AdminHold = @AdminSet          
Where ShipperID = @ShipperID
	And CpnyID = @CpnyID
GO
