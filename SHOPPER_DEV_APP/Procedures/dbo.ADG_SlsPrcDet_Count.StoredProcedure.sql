USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_Count]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SlsPrcDet_Count]

AS

	SELECT Count(*) from SlsPrcDet
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
