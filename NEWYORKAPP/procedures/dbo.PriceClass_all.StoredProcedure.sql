USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PriceClass_all]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceClass_all]
	@parm1 varchar( 1 ),
	@parm2 varchar( 6 )
AS
	SELECT *
	FROM PriceClass
	WHERE PriceClassType LIKE @parm1
	   AND PriceClassID LIKE @parm2
	ORDER BY PriceClassType,
	   PriceClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
