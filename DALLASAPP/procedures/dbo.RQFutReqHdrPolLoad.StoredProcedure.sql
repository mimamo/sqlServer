USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQFutReqHdrPolLoad]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 9/4/2003 6:21:20 PM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 7/5/2002 2:44:40 PM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 1/7/2002 12:23:10 PM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 1/2/01 9:39:35 AM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 11/17/00 11:54:30 AM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 10/25/00 8:32:15 AM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 10/10/00 4:15:38 PM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 10/2/00 4:58:13 PM ******/

/****** Object:  Stored Procedure dbo.RQFutReqHdrPolLoad    Script Date: 9/1/00 9:39:20 AM ******/
CREATE PROCEDURE [dbo].[RQFutReqHdrPolLoad]
@parm1 varchar(10), @parm2 varchar(2), @parm3 varchar(2)
 AS
Select  *  from  RQReqHdr
where
MaterialType = @parm1 and
status = 'SA' and
PolicyLevReq >= @parm2 and
PolicyLevObt < @parm3
ORDER BY ReqNbr, ReqCntr
GO
