USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_RefNbr_Order_Shipper_XRef]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_RefNbr_Order_Shipper_XRef]
	@RefNbr		Varchar(10)
AS
	Declare @OrderCnt Float,
		@ShipperCnt Float
		Select @OrderCnt = Count(*) From SoHeader Where InvcNbr = @RefNbr
	Select @ShipperCnt = Count(*) From SoShipHeader Where InvcNbr = @RefNbr

	If @OrderCnt = 0 And @ShipperCnt = 0
	Begin
	   DELETE RefNbr WHERE	RefNbr = @RefNbr
	End
GO
