USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ShipperId]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_ShipperId]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDContainerDet
 WHERE ShipperId LIKE @parm1
 ORDER BY ShipperId
GO
