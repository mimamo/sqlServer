USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Single]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_Single]
 @parm3 varchar( 10 )

AS
 SELECT *
 FROM EDContainer
 WHERE  ContainerID = @parm3
 ORDER BY CpnyId,
    ShipperId,
    ContainerID
GO
