USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[rqreqhdr_open_cury]    Script Date: 12/21/2015 15:43:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[rqreqhdr_open_cury] @parm1 varchar(4), @parm2 varchar(10)  AS
SELECT * FROM RQReqHdr
WHERE  CuryID = @parm1 and
ReqNbr Like @parm2 and
Status in ('OP', 'SB')
ORDER BY ReqNbr DESC, ReqCntr DESC
GO
