USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_FrtTerms_Descr]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_FrtTerms_Descr]
	@parm1 varchar(10)
AS
	Select Descr
	from FrtTerms
	where FrtTermsID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
