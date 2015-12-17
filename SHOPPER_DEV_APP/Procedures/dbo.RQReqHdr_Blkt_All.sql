USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQReqHdr_Blkt_All]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 9/4/2003 6:21:39 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 7/5/2002 2:44:44 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 1/7/2002 12:23:14 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 1/2/01 9:39:40 AM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 11/17/00 11:54:33 AM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 10/25/00 8:32:19 AM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 10/10/00 4:15:41 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 10/2/00 4:58:17 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 9/1/00 9:39:24 AM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 03/31/2000 12:21:23 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 2/2/00 12:18:20 PM ******/

/****** Object:  Stored Procedure dbo.RQReqHdr_Blkt_All    Script Date: 12/17/97 10:48:46 AM ******/
CREATE PROCEDURE [dbo].[RQReqHdr_Blkt_All] @parm1 Varchar(10) AS
SELECT * FROM RQReqHdr
WHERE ReqNbr Like @parm1
AND ((POType = 'BL' AND Status = 'PO') OR (POType = 'ST' AND Status = 'OP'))
ORDER BY ReqNbr DESC, ReqCntr DESC
GO
