USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Terms_All]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Terms_All]
	@TermsID varchar(2)
AS
	select	*
	from	Terms
	where	TermsID = @TermsID
	and	NbrInstall < 2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
