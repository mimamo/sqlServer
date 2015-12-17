USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PP_Batch_CheckForReleasedTrans]    Script Date: 12/16/2015 15:55:12 ******/
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
