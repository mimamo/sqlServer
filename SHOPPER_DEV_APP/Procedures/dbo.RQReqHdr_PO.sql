USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQReqHdr_PO]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQReqHdr_PO    Script Date: 9/4/2003 6:21:39 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_PO    Script Date: 7/5/2002 2:44:45 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_PO    Script Date: 1/7/2002 12:23:15 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_PO    Script Date: 1/2/01 9:39:40 AM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_PO    Script Date: 11/17/00 11:54:33 AM ******/
CREATE PROCEDURE [dbo].[RQReqHdr_PO] @parm1 varchar(10)  AS
SELECT * FROM RQReqHdr
WHERE Status = 'PO'  and
ReqNbr like @parm1 and
ReqCntr = '00'
ORDER BY
ReqNbr DESC, ReqCntr DESC
GO
