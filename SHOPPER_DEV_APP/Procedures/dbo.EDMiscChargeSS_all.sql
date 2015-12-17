USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDMiscChargeSS_all]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDMiscChargeSS_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 10 )
AS
 SELECT *
 FROM EDMiscChargeSS
 WHERE MiscChrgId LIKE @parm1
    AND Code LIKE @parm2
 ORDER BY MiscChrgId,
    Code
GO
