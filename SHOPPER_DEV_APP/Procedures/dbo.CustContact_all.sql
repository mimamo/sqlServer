USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustContact_all]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustContact_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM CustContact
	WHERE CustID LIKE @parm1
	   AND ContactID LIKE @parm2
	ORDER BY CustID,
	   ContactID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
