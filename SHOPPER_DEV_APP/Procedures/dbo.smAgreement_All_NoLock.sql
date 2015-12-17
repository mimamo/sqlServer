USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smAgreement_All_NoLock]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smAgreement_All_NoLock]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smAgreement (NOLOCK)
	WHERE
		AgreementTypeID LIKE @parm1
	ORDER BY
		AgreementTypeID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
