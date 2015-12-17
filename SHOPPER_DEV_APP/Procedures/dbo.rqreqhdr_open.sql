USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[rqreqhdr_open]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[rqreqhdr_open] @parm1 varchar(10) AS
SELECT * FROM RQReqHdr
WHERE ReqNbr Like @parm1
and Status in ('OP', 'SB')
ORDER BY ReqNbr DESC, ReqCntr DESC
GO
