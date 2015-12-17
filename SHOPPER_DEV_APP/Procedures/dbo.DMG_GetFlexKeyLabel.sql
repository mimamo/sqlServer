USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetFlexKeyLabel]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_GetFlexKeyLabel]
 	@control_code varchar (30)
AS
    	Select 	SUBSTRING(control_data, 2, 16) FlexKeyLabel
	from 	PJCONTRL
        where 	control_code = @control_code
	  and	control_type = 'FK'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
