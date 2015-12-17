USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SITEGROUP_CPNYID]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SITEGROUP_CPNYID    Script Date: 01/03/08 7:41:53 PM ******/
CREATE Proc [dbo].[SITEGROUP_CPNYID] 
    @parm1 varchar ( 10), @parm2 varchar(10) 
AS
    SELECT * 
      FROM SiteGroup 
     WHERE CpnyID = @parm1 and SiteGroupId like @parm2 
     ORDER BY CpnyID, SiteGroupId
GO
