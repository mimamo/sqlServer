USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_MfgClass_Descr]    Script Date: 12/21/2015 16:00:54 ******/
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
