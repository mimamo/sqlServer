USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_MfgClass_Descr]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_MfgClass_Descr]
	@MfgClassID		varchar(10)
AS
	SELECT 			Descr
	FROM 			BMMfgClass
	WHERE 			MfgClassID = @MfgClassID
GO
