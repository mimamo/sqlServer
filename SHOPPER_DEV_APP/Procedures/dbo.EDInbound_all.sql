USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInbound_all]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDInbound_all]
 @parm1 varchar( 15 ),
 @parm2 varchar( 3 )
AS
 SELECT *
 FROM EDInbound
 WHERE CustId LIKE @parm1
    AND Trans LIKE @parm2
 ORDER BY CustId,
    Trans
GO
