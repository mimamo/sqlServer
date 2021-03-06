USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POPolicyApprDefer_DBNAV]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POPolicyApprDefer_DBNAV    Script Date: 12/17/97 10:48:58 AM ******/
CREATE PROCEDURE [dbo].[POPolicyApprDefer_DBNAV] @parm1 VarChar(10), @parm2 VarChar(47), @parm3 VarChar(47),
@parm4startdate SmallDateTime, @parm4enddate SmallDateTime as
Select * from POPolicyApprDefer where Policyid like @parm1 and
UserId like @parm2 and
DeferUserID like @parm3 and
StartDate between @parm4startdate and @parm4enddate
Order by PolicyId,userid,DeferUserID, startdate
GO
