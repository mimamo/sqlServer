USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServHist_Delete]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServHist_Delete]
	@parm1 smallint
AS
	DELETE FROM smServHist
		WHERE WrkRI_ID = @parm1

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
