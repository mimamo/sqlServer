USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GetSiteName]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GetSiteName    Script Date: 01/02/08 12:19:55 PM ******/
CREATE PROCEDURE [dbo].[GetSiteName] 
   @parm1 varchar( 10 ), @parm2 varchar(10)
AS
   SELECT Name
     FROM Site 
    WHERE SiteID = @parm1 AND cpnyID = @Parm2
GO
