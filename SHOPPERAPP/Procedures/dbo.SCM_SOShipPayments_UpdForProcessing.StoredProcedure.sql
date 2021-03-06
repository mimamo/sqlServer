USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOShipPayments_UpdForProcessing]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_SOShipPayments_UpdForProcessing]
	@CpnyID 	varchar(10),
	@ShipperID	varchar(15),
	@ShipRegisterID varchar(10),
	@OrigDocType	varchar(2)

as

	UPDATE 	SOShipPayments
	Set	S4Future11 = @ShipRegisterID,
		S4Future12 = @OrigDocType
	FROM	SOShipPayments
	Where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
GO
