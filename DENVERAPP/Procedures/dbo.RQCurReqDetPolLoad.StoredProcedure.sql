USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQCurReqDetPolLoad]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 9/4/2003 6:21:19 PM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 7/5/2002 2:44:38 PM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 1/7/2002 12:23:09 PM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 1/2/01 9:39:34 AM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 11/17/00 11:54:28 AM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 10/25/00 8:32:14 AM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 10/10/00 4:15:36 PM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 10/2/00 4:58:11 PM ******/

/****** Object:  Stored Procedure dbo.RQCurReqDetPolLoad    Script Date: 9/1/00 9:39:18 AM ******/
CREATE PROCEDURE [dbo].[RQCurReqDetPolLoad]
@parm1 varchar(10), @parm2 varchar(2), @parm3 varchar(10), @parm4 varchar(2), @parm5 varchar(2)
 AS
Select  *  from  RQreqdet where
reqnbr = @parm1 and
ReqCntr = @parm2 and
status = 'SA' and
MaterialType = @parm3 and
PolicyLevReq >= @parm4 and
PolicyLevObt = @parm5
ORDER BY ReqNbr, ReqCntr, LineNbr
GO
