USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_VendorRebate_All]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_VendorRebate_All]
	@CustID varchar(15),
	@InvtID varchar(30),
	@RebateID varchar(10)
AS
	SELECT *
	FROM VendorRebate
	WHERE CustID = @CustID AND
	   	InvtID = @InvtID AND
		RebateID LIKE @RebateID
	ORDER BY RebateID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
