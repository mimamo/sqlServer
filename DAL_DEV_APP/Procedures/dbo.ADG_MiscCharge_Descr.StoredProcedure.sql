USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_MiscCharge_Descr]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_MiscCharge_Descr]
	@MiscChrgID varchar(10)
AS
	SELECT Descr
	FROM MiscCharge
	WHERE MiscChrgID = @MiscChrgID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
