USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POProjApprDefer_DBNAV]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POProjApprDefer_DBNAV    Script Date: 12/17/97 10:48:58 AM ******/
CREATE PROCEDURE [dbo].[POProjApprDefer_DBNAV] @parm1 VarChar(16), @parm2 VarChar(47), @parm3 VarChar(47),
@parm4startdate SmallDateTime, @parm4enddate SmallDateTime as
Select * from POProjApprDefer where Project like @parm1 and
UserId like @parm2 and
DeferUserID like @parm3 and
StartDate between @parm4startdate and @parm4enddate
Order by Project,userid,DeferUserID, startdate
GO
