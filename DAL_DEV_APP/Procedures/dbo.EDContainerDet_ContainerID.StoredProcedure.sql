USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ContainerID]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_ContainerID]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM EDContainerDet
 WHERE ContainerID LIKE @parm1
 ORDER BY ContainerID
GO
