USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vs_AppServer_All]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vs_AppServer_All]
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS
	SELECT *
	FROM vs_AppServer
	ORDER BY Servername
GO
