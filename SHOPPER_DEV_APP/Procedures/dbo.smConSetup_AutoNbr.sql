USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConSetup_AutoNbr]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConSetup_AutoNbr]
	AS
	SELECT
		LastBatNbr
	FROM smConSetup

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
