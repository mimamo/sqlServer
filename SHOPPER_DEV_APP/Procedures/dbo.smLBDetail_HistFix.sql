USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smLBDetail_HistFix]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smLBDetail_HistFix]
		@parm1  varchar(1)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smLBDetail
		,smServcall
	WHERE
		smLBDetail.Linetypes = @parm1
			AND
		smServCall.ServiceCallCompleted = 1
			AND
		smLBDetail.ServiceContract > @parm2
			AND
		smLBDetail.ServiceCallID = smServCall.ServiceCallID
	ORDER BY
		smLBDetail.ServiceCallID
		,smLBDetail.LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
