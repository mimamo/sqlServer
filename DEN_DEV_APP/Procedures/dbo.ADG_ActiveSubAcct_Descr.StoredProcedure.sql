USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ActiveSubAcct_Descr]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ActiveSubAcct_Descr]
	@parm1 varchar(24)
AS
       	SELECT 	Descr
	FROM 	Subacct
        WHERE 	Sub = @parm1
	  AND	Active = 1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
