USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQReqHdr_NotComplete]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQReqHdr_NotComplete    Script Date: 9/4/2003 6:21:39 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_NotComplete    Script Date: 7/5/2002 2:44:44 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_NotComplete    Script Date: 1/7/2002 12:23:15 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_NotComplete    Script Date: 1/2/01 9:39:40 AM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_NotComplete    Script Date: 11/17/00 11:54:33 AM ******/
CREATE PROCEDURE [dbo].[RQReqHdr_NotComplete]	 AS
SELECT * FROM RQReqHdr
WHERE Status <> 'CP'
ORDER BY
ReqNbr DESC, ReqCntr DESC
GO
