USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Vendor_Name]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Vendor_Name]
	@parm1 varchar(15)
AS
	SELECT Name
	FROM Vendor
	WHERE VendID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
