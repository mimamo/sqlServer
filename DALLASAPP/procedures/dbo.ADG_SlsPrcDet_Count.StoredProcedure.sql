USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_Count]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SlsPrcDet_Count]

AS

	SELECT Count(*) from SlsPrcDet
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
