USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProductClass_Descr]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ProductClass_Descr]
	@parm1 varchar(6)
AS
	SELECT Descr
	FROM ProductClass
	WHERE ClassID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
