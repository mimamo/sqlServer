USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[rqreqhdr_open_cury_PV]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[rqreqhdr_open_cury_PV] @parm1 varchar(4), @parm2 varchar(10)  AS
SELECT Dept, Project, CpnyID, CuryID FROM RQReqHdr
WHERE  CuryID = @parm1 and
ReqNbr Like @parm2 and
Status in ('OP', 'SB')
ORDER BY ReqNbr DESC, ReqCntr DESC
GO
