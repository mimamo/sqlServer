USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[RQReqHdrLastRev]    Script Date: 12/21/2015 15:55:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[RQReqHdrLastRev] as
SELECT * from RQReqHdr 
 WHERE ReqCntr = (SELECT max(RQH2.ReqCntr) 
                    FROM RQReqHdr as RQH2 
                   WHERE RQReqHdr.ReqNbr = RQH2.ReqNbr)
GO
