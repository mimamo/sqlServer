USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_allDMG]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDContainerDet_all    Script Date: 5/28/99 1:17:40 PM ******/
CREATE PROCEDURE [dbo].[EDContainerDet_allDMG]
 @parm1 varchar( 10 ),
 @parm2 varchar( 15 ),
 @parm3 varchar( 5 ),
 @parm4 varchar( 10 )
AS
 SELECT *
 FROM EDContainerDet
 WHERE CpnyId LIKE @parm1
    AND ShipperId LIKE @parm2
    AND LineRef LIKE @parm3
    AND ContainerID LIKE @parm4
 ORDER BY CpnyId,
    ShipperId,
    LineRef,
    ContainerID
GO
