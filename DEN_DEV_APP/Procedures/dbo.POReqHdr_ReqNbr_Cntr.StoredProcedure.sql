USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_ReqNbr_Cntr]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReqHdr_ReqNbr_Cntr    Script Date: 12/17/97 10:49:08 AM ******/
Create Procedure [dbo].[POReqHdr_ReqNbr_Cntr] @Parm1 Varchar(10), @Parm2 Varchar(2) as
SELECT * From POReqHdr WHERE ReqNbr = @Parm1 and ReqCntr LIKE @Parm2
ORDER BY ReqNbr DESC, ReqCntr DESC
GO
