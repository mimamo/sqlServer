USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Component_CmpnentId_SiteId]    Script Date: 12/21/2015 15:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Component_CmpnentId_SiteId]  @parm1 varchar(30),  @parm2 varchar(30), @parm3 varchar(30)  as
            Select * from Component where Cmpnentid = @parm1 and SiteId = @parm2 and kitid >= @parm3
             Order by CmpnentId, SiteId, Kitid, sequence
GO
