USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PP_Batch_CheckForReleasedTrans]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PP_Batch_CheckForReleasedTrans] @BatNbr varchar(10)
AS

SELECT 	count(*)
FROM	AP_PPApplicDet
WHERE	BatNbr = @BatNbr
AND	Rlsed = 1
GO
