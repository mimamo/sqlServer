USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LostSaleCode_Descr]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LostSaleCode_Descr]
	@parm1 varchar(2)
AS
	SELECT Descr
	FROM LostSaleCode
	WHERE  LostSaleID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
