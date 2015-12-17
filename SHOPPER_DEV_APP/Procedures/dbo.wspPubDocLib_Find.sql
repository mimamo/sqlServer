USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wspPubDocLib_Find]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[wspPubDocLib_Find] @parm1 smallint, @parm2 varchar(60), @parm3 smallint
AS
	SELECT *
	FROM wsppubdoclib
	WHERE sltypeid = @parm1
		AND slobjid = @parm2
		AND DocumentID = @parm3
GO
