USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_SingleContainer]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDWrkLabelPrint_SingleContainer]
 @ContainerId varchar( 10 )
AS
 SELECT *
 FROM EDWrkLabelPrint
 WHERE  ContainerID LIKE  @ContainerId
 ORDER BY
    ContainerID
GO
