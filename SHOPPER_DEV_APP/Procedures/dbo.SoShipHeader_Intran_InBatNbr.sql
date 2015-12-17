USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SoShipHeader_Intran_InBatNbr]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SoShipHeader_Intran_InBatNbr]
	@ShipperID Varchar(15)
As
     SELECT Count(S.InBatNbr)
	FROM SOShipHeader S JOIN INtran I ON I.BatNbr = S.INBatNbr
     WHERE s.Shipperid = @ShipperID And S.InBatNbr <> ''
GO
