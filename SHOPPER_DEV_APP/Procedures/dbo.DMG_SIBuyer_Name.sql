USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SIBuyer_Name]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SIBuyer_Name]
	@Buyer varchar(10)
AS
	Select	BuyerName
	from	SIBuyer
	where	Buyer = @Buyer

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
